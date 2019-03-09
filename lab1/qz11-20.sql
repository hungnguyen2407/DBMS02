
/*11.Cho biết họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ
1 năm 2006*/
select HOTEN
from GIAOVIEN
where MAGV like
(
    select MAGV
    from GIANGDAY
    where MAMH like 'CTRR'
          and MALOP like 'K11'
          and HOCKY = 1
          and NAM = 2006
)
      and MAGV like
(
    select MAGV
    from GIANGDAY
    where MAMH like 'CTRR'
          and MALOP like 'K12'
          and HOCKY = 1
          and NAM = 2006
);

/*12.Cho biết những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1
nhưng chưa thi lại môn này.*/
select THIROT.MAHV
from
(
    select HOCVIEN.MAHV
    from HOCVIEN
         join KETQUATHI on HOCVIEN.MAHV = KETQUATHI.MAHV
    where LANTHI > 1
          and MAMH like 'CSDL'
) as THILAI
right join
(
    select HOCVIEN.MAHV
    from HOCVIEN
         join KETQUATHI on HOCVIEN.MAHV = KETQUATHI.MAHV
    where MAMH like 'CSDL'
          and LANTHI = 1
          and KQUA like 'Khong Dat'
) as THIROT on THILAI.MAHV = THIROT.MAHV
where THILAI.MAHV is null;

/*13.Cho biết giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học
nào*/
select GIAOVIEN.MAGV,
       HOTEN
from GIAOVIEN
     left join
(
    select MAGV
    from GIANGDAY
    group by MAGV
) as GVGD on GIAOVIEN.MAGV = GVGD.MAGV
where GVGD.MAGV is null;

/*14.Cho biết giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học
nào thuộc khoa giáo viên đó phụ trách.*/
select GIAOVIEN.MAGV,
       GIAOVIEN.HOTEN
from GIANGDAY
     join MONHOC on GIANGDAY.MAMH = MONHOC.MAMH
     right join GIAOVIEN on GIANGDAY.MAGV = GIAOVIEN.MAGV
where MONHOC.MAKHOA is null
      or MONHOC.MAKHOA not like GIAOVIEN.MAKHOA
group by GIAOVIEN.MAGV,
         GIAOVIEN.HOTEN;

/*15. Cho biết họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat”
hoặc thi lần thứ 2 môn CTRR được 5 điểm.*/
select HOCVIEN.HO,
       HOCVIEN.TEN
from KETQUATHI
     join HOCVIEN on KETQUATHI.MAHV = HOCVIEN.MAHV
where MALOP like 'K11'
      and ((LANTHI = 3
            and KQUA like 'Khong dat')
           or (LANTHI = 2
               and MAMH like 'CSDL'
               and DIEM = 5.00));

/*16.Cho biết họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của
một năm học.*/
select GIAOVIEN.HOTEN
from
(
    select count(GD1.MALOP) as SL,
           GD1.MAGV
    from GIANGDAY GD1,
         GIANGDAY GD2
    where GD1.MAMH like 'CTRR'
          and GD2.MAMH like 'CTRR'
          and GD1.MALOP = GD2.MALOP
          and GD1.NAM = GD2.NAM
          and GD1.HOCKY = GD2.HOCKY
    group by GD1.MAGV
) as RS
join GIAOVIEN on RS.MAGV = GIAOVIEN.MAGV
where RS.SL >= 2;

/*17.Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng)*/
select HOCVIEN.*,
       DIEM
from HOCVIEN
     join
(
    select KETQUATHI.MAHV,
           DIEM
    from KETQUATHI
         right join
    (
        select MAHV,
               count(LANTHI) as SLT
        from KETQUATHI
        where MAMH like 'CSDL'
        group by MAHV
    ) as SLTCSDL on KETQUATHI.MAHV = SLTCSDL.MAHV
    where KETQUATHI.MAMH like 'CSDL'
          and LANTHI = SLT
) as KQTCSDL on HOCVIEN.MAHV = KQTCSDL.MAHV;

/*18.Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần
thi).*/
select HOCVIEN.*,
       DIEMCAONHAT
from HOCVIEN
     join
(
    select MAHV,
           max(DIEM) as DIEMCAONHAT
    from KETQUATHI
    where MAMH like 'CSDL'
    group by MAHV
) as KQTCSDL on HOCVIEN.MAHV = KQTCSDL.MAHV;

/*19.Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất*/
select MAKHOA,
       TENKHOA
from KHOA
where NGTLAP =
(
    select min(NGTLAP)
    from KHOA
);

/*20.Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”*/
select count(MAGV) as SLGV
from GIAOVIEN
where HOCHAM like 'GS'
      or HOCHAM like 'PGS';