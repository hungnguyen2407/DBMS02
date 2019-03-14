/*
- Môn: Hệ quản trị cơ sở dữ liệu
- Giảng viên: Nguyễn Thị Minh Hương
- Thứ 3 tiết 456
- Bài thực hành số 1 
- Nhóm 02
*/
------------------------------------
/* Phần 1: 
Từ câu 1-10
Họ và tên: Phạm Duy Bảo Minh
MSSV: 15130102

Phần 2: 
Từ câu 11-20
Họ và tên: Nguyễn Hoàng Hưng
MSSV: 14130047

Phần 3: 
Từ câu 21-30
Họ và tên: Trần Đình Hòa
MSSV: 15130061

Phần 4:
Từ câu 31-35
Cả nhóm ngồi làm chung với nhau
*/
------------------------------------
/* câu 1: In ra danh sách(Mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp */
SELECT hv.MAHV, hv.HO, hv.TEN, hv.NGSINH, hv.MALOP 
FROM HOCVIEN hv inner join LOP l 
ON hv.MAHV = l.TRGLOP;
/* câu 2: In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”,
sắp xếp theo tên, họ học viên. */
SELECT hv.MAHV, hv.HO, hv.TEN, kq.LANTHI, kq.DIEM 
FROM HOCVIEN hv inner join KETQUATHI kq 
	ON kq.MAHV = hv.MAHV and kq.MAMH='CTRR' and hv.MALOP='K12';
/* câu 3: In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó
thi lần thứ nhất đã đạt. */
SELECT hv.MAHV, hv.HO, hv.TEN, mh.*
FROM HOCVIEN hv, MONHOC mh inner join KETQUATHI kq 
ON kq.LANTHI='1' and kq.MAMH = mh.MAMH
WHERE kq.MAHV = hv.MAHV;
/* câu 4: In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở
lần thi 1). */
SELECT hv.MAHV, hv.HO, hv.TEN
FROM LOP l, HOCVIEN hv inner join KETQUATHI kq 
ON kq.MAMH='CTRR' and kq.LANTHI>1 and kq.MAHV = hv.MAHV 
WHERE l.MALOP='K11' and l.MALOP = hv.MALOP;
/* câu 5: Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả
các lần thi). */
SELECT hv.MAHV, hv.HO, hv.TEN 
FROM HOCVIEN hv inner join KETQUATHI kq 
ON hv.MAHV = kq.MAHV and kq.MAMH='CTRR'
		and hv.MALOP LIKE 'K%' and kq.KQUA != 'Dat' 
		inner join (SELECT COUNT(kq.MAHV) AS TONGSOLANTHI, kq.MAHV 
					FROM KETQUATHI kq 
					WHERE kq.MAMH='CTRR'
					GROUP BY kq.MAHV) AS TSLT 
ON hv.MAHV = TSLT.MAHV and TSLT.TONGSOLANTHI = kq.LANTHI
/* câu 6: Cho biết tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1
năm 2006. */
SELECT mh.TENMH 
FROM MONHOC mh, GIANGDAY gd inner join GIAOVIEN gv
ON gv.MAGV = gd.MAGV and gv.HOTEN='Tran Tam Thanh' 
WHERE gd.NAM='2006' and gd.HOCKY='1' and mh.MAMH = gd.MAMH;
/* câu 7: Cho biết những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11”
dạy trong học kỳ 1 năm 2006. */
SELECT mh.MAMH, mh.TENMH 
FROM MONHOC mh, GIANGDAY gd inner join GIAOVIEN gv 
ON gv.MAGV = gd.MAGV and gd.HOCKY='1' and gd.NAM='2006' inner join LOP l 
ON l.MAGVCN = gv.MAGV and l.MALOP='K11'
WHERE mh.MAMH = gd.MAMH 
/* câu 8: Cho biết họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co
So Du Lieu”. */
SELECT hv.HO, hv.TEN 
FROM HOCVIEN hv, LOP l, GIAOVIEN gv inner join GIANGDAY gd 
ON gv.MAGV = gd.MAGV and gv.HOTEN='Nguyen To Lan' inner join MONHOC mh
ON mh.MAMH = gd.MAMH and mh.TENMH='Co So Du Lieu' 
WHERE hv.MAHV = l.TRGLOP
/* câu 9: In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co
So Du Lieu”. */
SELECT DISTINCT mh.MAMH, mh.TENMH
FROM MONHOC mh, DIEUKIEN dk inner join
	(SELECT mh.MAMH, mh.TENMH 
	FROM MONHOC mh, DIEUKIEN dk 
	WHERE mh.MAMH = dk.MAMH and mh.TENMH='Co So Du Lieu') AS MHTQ
ON MHTQ.MAMH = dk.MAMH
WHERE mh.MAMH = dk.MAMH_TRUOC
/* câu 10: Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn
học, tên môn học) nào. */
SELECT mh.MAMH, mh.TENMH FROM MONHOC mh, DIEUKIEN dk inner join 
	(SELECT mh.MAMH, mh.TENMH 
	FROM MONHOC mh, DIEUKIEN dk
	WHERE mh.MAMH = dk.MAMH_TRUOC and mh.TENMH='Cau Truc Roi Rac') AS MHT 
ON MHT.MAMH = dk.MAMH_TRUOC
WHERE mh.MAMH = dk.MAMH


/*11.Cho biết họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ
1 năm 2006*/
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV LIKE
(
    SELECT MAGV
    FROM GIANGDAY
    WHERE MAMH LIKE 'CTRR'
          AND MALOP LIKE 'K11'
          AND HOCKY = 1
          AND NAM = 2006
)
      AND MAGV LIKE
(
    SELECT MAGV
    FROM GIANGDAY
    WHERE MAMH LIKE 'CTRR'
          AND MALOP LIKE 'K12'
          AND HOCKY = 1
          AND NAM = 2006
);

/*12.Cho biết những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1
nhưng chưa thi lại môn này.*/
SELECT THIROT.MAHV
FROM
(
    SELECT HOCVIEN.MAHV
    FROM HOCVIEN
         JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
    WHERE LANTHI > 1
          AND MAMH LIKE 'CSDL'
) AS THILAI
RIGHT JOIN
(
    SELECT HOCVIEN.MAHV
    FROM HOCVIEN
         JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
    WHERE MAMH LIKE 'CSDL'
          AND LANTHI = 1
          AND KQUA LIKE 'Khong Dat'
) AS THIROT ON THILAI.MAHV = THIROT.MAHV
WHERE THILAI.MAHV IS NULL;

/*13.Cho biết giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học
nào*/
SELECT GIAOVIEN.MAGV, 
       HOTEN
FROM GIAOVIEN
     LEFT JOIN
(
    SELECT MAGV
    FROM GIANGDAY
    GROUP BY MAGV
) AS GVGD ON GIAOVIEN.MAGV = GVGD.MAGV
WHERE GVGD.MAGV IS NULL;

/*14.Cho biết giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học
nào thuộc khoa giáo viên đó phụ trách.*/
SELECT GIAOVIEN.MAGV, 
       GIAOVIEN.HOTEN
FROM GIANGDAY
     JOIN MONHOC ON GIANGDAY.MAMH = MONHOC.MAMH
     RIGHT JOIN GIAOVIEN ON GIANGDAY.MAGV = GIAOVIEN.MAGV
WHERE MONHOC.MAKHOA IS NULL
      OR MONHOC.MAKHOA NOT LIKE GIAOVIEN.MAKHOA
GROUP BY GIAOVIEN.MAGV, 
         GIAOVIEN.HOTEN;

/*15. Cho biết họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat”
hoặc thi lần thứ 2 môn CTRR được 5 điểm.*/
SELECT HOCVIEN.HO, 
       HOCVIEN.TEN
FROM KETQUATHI
     JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE MALOP LIKE 'K11'
      AND ((LANTHI = 3
            AND KQUA LIKE 'Khong dat')
           OR (LANTHI = 2
               AND MAMH LIKE 'CSDL'
               AND DIEM = 5.00));

/*16.Cho biết họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của
một năm học.*/
SELECT GIAOVIEN.HOTEN
FROM
(
    SELECT COUNT(GD1.MALOP) AS SL, 
           GD1.MAGV
    FROM GIANGDAY GD1, 
         GIANGDAY GD2
    WHERE GD1.MAMH LIKE 'CTRR'
          AND GD2.MAMH LIKE 'CTRR'
          AND GD1.MALOP = GD2.MALOP
          AND GD1.NAM = GD2.NAM
          AND GD1.HOCKY = GD2.HOCKY
    GROUP BY GD1.MAGV
) AS RS
JOIN GIAOVIEN ON RS.MAGV = GIAOVIEN.MAGV
WHERE RS.SL >= 2;

/*17.Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng)*/
SELECT HOCVIEN.*, 
       DIEM
FROM HOCVIEN
     JOIN
(
    SELECT KETQUATHI.MAHV, 
           DIEM
    FROM KETQUATHI
         RIGHT JOIN
    (
        SELECT MAHV, 
               MAX(LANTHI) AS SLT
        FROM KETQUATHI
        WHERE MAMH LIKE 'CSDL'
        GROUP BY MAHV
    ) AS SLTCSDL ON KETQUATHI.MAHV = SLTCSDL.MAHV
    WHERE KETQUATHI.MAMH LIKE 'CSDL'
          AND LANTHI = SLT
) AS KQTCSDL ON HOCVIEN.MAHV = KQTCSDL.MAHV;

/*18.Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần
thi).*/
SELECT HOCVIEN.*, 
       DIEMCAONHAT
FROM HOCVIEN
     JOIN
(
    SELECT MAHV, 
           MAX(DIEM) AS DIEMCAONHAT
    FROM KETQUATHI
    WHERE MAMH LIKE 'CSDL'
    GROUP BY MAHV
) AS KQTCSDL ON HOCVIEN.MAHV = KQTCSDL.MAHV;

/*19.Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất*/
SELECT MAKHOA, 
       TENKHOA
FROM KHOA
WHERE NGTLAP =
(
    SELECT MIN(NGTLAP)
    FROM KHOA
);

/*20.Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”*/
SELECT COUNT(MAGV) AS SLGV
FROM GIAOVIEN
WHERE HOCHAM LIKE 'GS'
      OR HOCHAM LIKE 'PGS';


--Câu 21: Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT HOCVI,COUNT(*)AS SOLUONG
FROM GIAOVIEN
GROUP BY HOCVI;
--Câu 22: Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT KQUA, COUNT(MAHV) AS SOLUONG
FROM KETQUATHI
GROUP BY KQUA;
--Câu 23: Cho biết giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT GIAOVIEN.MAGV,GIAOVIEN.HOTEN, COUNT(GIANGDAY.MAMH) AS SOMONDAY
FROM GIAOVIEN,LOP,GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV AND GIAOVIEN.MAGV=LOP.MAGVCN AND LOP.MALOP=GIANGDAY.MALOP
GROUP BY GIAOVIEN.MAGV,GIAOVIEN.HOTEN;
--24.Cho biết họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT hv.HO,hv.TEN FROM HOCVIEN hv WHERE hv.MAHV IN (SELECT l.TRGLOP FROM LOP l WHERE l.SISO= (SELECT MAX(SISO) FROM LOP));
--25.Cho biết họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
SELECT hv.HO,hv.TEN FROM HOCVIEN hv JOIN LOP lop ON hv.MAHV=lop.TRGLOP JOIN (SELECT kqt.MAHV,kqt.MAMH,kqt.KQUA FROM KETQUATHI kqt
WHERE kqt.KQUA='Khong Dat' GROUP BY kqt.MAHV,kqt.MAMH,kqt.KQUA HAVING COUNT(kqt.MAMH)=COUNT(kqt.KQUA)) a ON a.MAHV =hv.MAHV
GROUP BY hv.HO, hv.TEN HAVING COUNT(*)>3;
--26.Cho biết học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT hv.MAHV , hv.HO, hv.TEN FROM HOCVIEN hv JOIN KETQUATHI kqt ON hv.MAHV =kqt.MAHV WHERE  kqt.DIEM >=9.00
GROUP BY hv.MAHV,hv.HO,hv.TEN HAVING COUNT(kqt.DIEM)>=ALL(SELECT COUNT(DIEM) FROM KETQUATHI WHERE DIEM>=9.00 GROUP BY MAHV);
--27. Trong từng lớp, Cho biết học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất. 
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN
FROM HOCVIEN JOIN KETQUATHI 
ON HOCVIEN.MAHV = KETQUATHI.MAHV 
WHERE KETQUATHI.DIEM >= 9.00
GROUP BY HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN
HAVING count(KETQUATHI.DIEM) >=ALL(SELECT COUNT(DIEM) 
									FROM KETQUATHI
									WHERE KETQUATHI.DIEM >= 9.00
									GROUP BY KETQUATHI.MAHV);
	
--28.Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT GIANGDAY.HOCKY, GIANGDAY.NAM,GIAOVIEN.MAGV, GIAOVIEN.HOTEN, COUNT(GIANGDAY.MAMH) AS 'SOMONHOC', COUNT(GIANGDAY.MALOP) AS 'SOLOPGIANGDAY'
FROM GIAOVIEN INNER JOIN GIANGDAY 
ON GIAOVIEN.MAGV = GIANGDAY.MAGV
GROUP BY GIANGDAY.HOCKY, GIANGDAY.NAM,GIAOVIEN.MAGV, GIAOVIEN.HOTEN;

--29.  Trong từng học kỳ của từng năm, Cho biết giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT GIANGDAY.HOCKY, GIANGDAY.NAM, GIAOVIEN.MAGV, GIAOVIEN.HOTEN,COUNT(GIANGDAY.MALOP)AS 'SOLOPGIANGDAY'
FROM GIANGDAY INNER JOIN GIAOVIEN
ON GIANGDAY.MAGV = GIAOVIEN.MAGV
GROUP BY GIANGDAY.HOCKY, GIANGDAY.NAM,GIAOVIEN.MAGV, GIAOVIEN.HOTEN
HAVING COUNT(GIANGDAY.MALOP) >=ALL(SELECT COUNT(GIANGDAY.MALOP) AS 'SOLOPGIANGDAY'
									FROM GIANGDAY INNER JOIN GIAOVIEN
									ON GIANGDAY.MAGV = GIAOVIEN.MAGV);
--30. Cho biết môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất. 
SELECT KQ.MAMH, TENMH
FROM MONHOC MH INNER JOIN KETQUATHI KQ ON KQ.MAMH = MH.MAMH
WHERE KQUA = 'Khong Dat' AND LANTHI=1
GROUP BY KQ.MAMH, TENMH
HAVING COUNT(MAHV) = (
	SELECT TOP 1 COUNT(*)
	FROM KETQUATHI
	WHERE KQUA = 'Khong Dat' AND LANTHI=1
	GROUP BY MAMH
	ORDER BY COUNT(*) DESC);

/*31.Cho biết học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).*/

SELECT KETQUATHI.MAHV, 
       HO, 
       TEN
FROM KETQUATHI
     JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
     LEFT JOIN
(
    SELECT MAHV
    FROM KETQUATHI
    WHERE LANTHI = 1
          AND KQUA LIKE 'Khong dat'
    GROUP BY MAHV
) AS HVKD ON KETQUATHI.MAHV = HVKD.MAHV
WHERE HVKD.MAHV IS NULL
GROUP BY KETQUATHI.MAHV, 
         HO, 
         TEN;

/*32.Cho biết học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).*/

SELECT KETQUATHI.MAHV, 
       HO, 
       TEN
FROM KETQUATHI
     JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
     LEFT JOIN
(
    SELECT KETQUATHI.MAHV
    FROM KETQUATHI
         JOIN
    (
        SELECT MAHV, 
               MAMH, 
               MAX(LANTHI) AS LANTHI
        FROM KETQUATHI
        GROUP BY MAHV, 
                 MAMH
    ) AS SLT ON KETQUATHI.MAHV = SLT.MAHV
    WHERE KETQUATHI.MAHV = SLT.MAHV
          AND KETQUATHI.MAMH = SLT.MAMH
          AND KETQUATHI.LANTHI = SLT.LANTHI
          AND KQUA LIKE 'Khong dat'
    GROUP BY KETQUATHI.MAHV
) AS HVKD ON KETQUATHI.MAHV = HVKD.MAHV
WHERE HVKD.MAHV IS NULL
GROUP BY KETQUATHI.MAHV, 
         HO, 
         TEN;

/*33.Cho biết học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1).*/

SELECT DSHVDTTCMH.MAHV, 
       HO, 
       TEN
FROM
(
    SELECT MAHV
    FROM
    (
        SELECT MAHV, 
               COUNT(MAMH) AS SMHDT
        FROM
        (
            SELECT MAHV, 
                   MAMH
            FROM KETQUATHI
            GROUP BY MAHV, 
                     MAMH
        ) AS DSMHHVDT
        GROUP BY MAHV
    ) AS SLMHHVDT
    WHERE SMHDT =
    (
        SELECT COUNT(MAMH)
        FROM MONHOC
    )
) AS DSHVDTTCMH
JOIN HOCVIEN ON DSHVDTTCMH.MAHV = HOCVIEN.MAHV
LEFT JOIN
(
    SELECT KETQUATHI.MAHV
    FROM KETQUATHI
         JOIN
    (
        SELECT MAHV
        FROM
        (
            SELECT MAHV, 
                   COUNT(MAMH) AS SMHDT
            FROM
            (
                SELECT MAHV, 
                       MAMH
                FROM KETQUATHI
                GROUP BY MAHV, 
                         MAMH
            ) AS DSMHHVDT
            GROUP BY MAHV
        ) AS SLMHHVDT
        WHERE SMHDT =
        (
            SELECT COUNT(MAMH)
            FROM MONHOC
        )
    ) AS DSHVDTTCMH ON KETQUATHI.MAHV = DSHVDTTCMH.MAHV
    WHERE LANTHI = 1
          AND KQUA LIKE 'Khong Dat'
    GROUP BY KETQUATHI.MAHV
) AS DSHVDTTCMHKD ON DSHVDTTCMH.MAHV = DSHVDTTCMHKD.MAHV
WHERE DSHVDTTCMHKD.MAHV IS NULL;


/*34.Cho biết học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi sau
cùng).*/

SELECT DSHVDTTCMH.MAHV, 
       HO, 
       TEN
FROM
(
    SELECT MAHV
    FROM
    (
        SELECT MAHV, 
               COUNT(MAMH) AS SMHDT
        FROM
        (
            SELECT MAHV, 
                   MAMH
            FROM KETQUATHI
            GROUP BY MAHV, 
                     MAMH
        ) AS DSMHHVDT
        GROUP BY MAHV
    ) AS SLMHHVDT
    WHERE SMHDT =
    (
        SELECT COUNT(MAMH)
        FROM MONHOC
    )
) AS DSHVDTTCMH
JOIN HOCVIEN ON DSHVDTTCMH.MAHV = HOCVIEN.MAHV
LEFT JOIN
(
    SELECT KETQUATHI.MAHV
    FROM KETQUATHI
         JOIN
    (
        SELECT MAHV
        FROM
        (
            SELECT MAHV, 
                   COUNT(MAMH) AS SMHDT
            FROM
            (
                SELECT MAHV, 
                       MAMH
                FROM KETQUATHI
                GROUP BY MAHV, 
                         MAMH
            ) AS DSMHHVDT
            GROUP BY MAHV
        ) AS SLMHHVDT
        WHERE SMHDT =
        (
            SELECT COUNT(MAMH)
            FROM MONHOC
        )
    ) AS DSHVDTTCMH ON KETQUATHI.MAHV = DSHVDTTCMH.MAHV
         JOIN
    (
        SELECT MAHV, 
               MAMH, 
               MAX(LANTHI) AS SLT
        FROM KETQUATHI
        GROUP BY MAHV, 
                 MAMH
    ) AS DSSLT ON KETQUATHI.MAHV = DSSLT.MAHV
    WHERE KETQUATHI.MAHV = DSSLT.MAHV
          AND KETQUATHI.MAMH = DSSLT.MAMH
          AND LANTHI = SLT
          AND KQUA LIKE 'Khong Dat'
    GROUP BY KETQUATHI.MAHV
) AS DSHVDTTCMHKD ON DSHVDTTCMH.MAHV = DSHVDTTCMHKD.MAHV
WHERE DSHVDTTCMHKD.MAHV IS NULL;

/* câu 35: Cho biết học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở
lần thi sau cùng). */
SELECT hv.MAHV, hv.HO, hv.TEN
FROM HOCVIEN hv, KETQUATHI kq inner join
	(SELECT kq.MAHV, kq.MAMH, MAX(kq.DIEM) AS DIEMCAONHAT, COUNT(kq.LANTHI) AS TONGSOLANTHI
	FROM KETQUATHI kq 
	GROUP BY kq.MAHV, kq.MAMH) AS KQCN
ON KQCN.DIEMCAONHAT = kq.DIEM and KQCN.MAMH = kq.MAMH and KQCN.MAHV = kq.MAHV and KQCN.TONGSOLANTHI = kq.LANTHI
WHERE hv.MAHV = kq.MAHV
