
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