
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

/*35.Cho biết học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở
lần thi sau cùng).*/