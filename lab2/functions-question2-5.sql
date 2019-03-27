
/*
2. Tạo hàm F_XL có mã học viên là tham số, cho biết kết quả xếp loại của học viên như sau:
Nếu DIEMTB ≥ 9 thì XEPLOAI =”XS”
Nếu 8 ≤ DIEMTB < 9 thì XEPLOAI = “G”
Nếu 6.5 ≤ DIEMTB < 8 thì XEPLOAI = “K”
Nếu 5 ≤ DIEMTB < 6.5 thì XEPLOAI = “TB”
Nếu DIEMTB < 5 thì XEPLOAI = ”Y” .
*/
GO
create function F_XL
(@MAHV as CHAR(5)
)
RETURNS CHAR(5)
AS
     BEGIN
         DECLARE @XL CHAR(5), @DTB NUMERIC(4, 2);
         SET @DTB = dbo.F_DTB(@MAHV);
         SELECT @XL = CASE
                          WHEN @DTB >= 9
                          THEN 'XS'
                          WHEN @DTB >= 8
                               AND @DTB < 9
                          THEN 'G'
                          WHEN @DTB >= 6.5
                               AND @DTB < 8
                          THEN 'K'
                          WHEN @DTB >= 5
                               AND @DTB < 6.5
                          THEN 'TB'
                          WHEN @DTB < 5
                          THEN 'Y'
                      END;
         RETURN @XL;
     END;

/*
3. Tạo hàm F_DSMON cho biết danh sách điểm các môn học mà học viên có kết quả ‘đạt’.
Danh sách gồm: MAMH, TENMH, ĐIỂM
Mã học viên là tham số của hàm
*/
GO
create function F_DSMON
(@MAHV as CHAR(5)
)
RETURNS TABLE
AS
     RETURN
(
    SELECT KETQUATHI.MAMH, 
           TENMH, 
           DIEM
    FROM KETQUATHI
         JOIN MONHOC ON KETQUATHI.MAMH = MONHOC.MAMH
    WHERE MAHV LIKE @MAHV
          AND KQUA LIKE 'Dat'
);

/*
4. Tạo hàm F_DSGV cho biết danh sách giáo viên đã dạy hết các môn mà khoa phụ trách.
Hàm có tham số là mã khoa
*/
GO
create function F_DSGV
(@MAKHOA as VARCHAR(4)
)
RETURNS TABLE
AS
     RETURN
(
    SELECT *
    FROM GIAOVIEN
    WHERE MAGV LIKE
    (
        SELECT MAGV
        FROM
        (
            SELECT MAGV, 
                   COUNT(*) AS SOMH
            FROM
            (
                SELECT GIANGDAY.MAGV, 
                       GIANGDAY.MAMH
                FROM GIANGDAY
                     JOIN
                (
                    SELECT *
                    FROM GIAOVIEN
                    WHERE MAKHOA LIKE @MAKHOA
                ) AS DSGIAOVIENCUAKHOA ON GIANGDAY.MAGV = DSGIAOVIENCUAKHOA.MAGV
                     JOIN
                (
                    SELECT *
                    FROM MONHOC
                    WHERE MAKHOA LIKE @MAKHOA
                ) AS DSMONHOCCUAKHOA ON GIANGDAY.MAMH = DSMONHOCCUAKHOA.MAMH
                GROUP BY GIANGDAY.MAMH, 
                         GIANGDAY.MAGV
            ) AS DSGIAOVIENDAYMONHOCCUAKHOA
            GROUP BY MAGV
        ) AS DSGIAOVIENDAYSOMONHOCCUAKHOA
        WHERE SOMH =
        (
            SELECT COUNT(*)
            FROM MONHOC
            WHERE MAKHOA LIKE @MAKHOA
        )
    )
);

/*
5. Tạo hàm trả về danh sách học viên và kết quả xếp loại từng học viên của lớp.
Thông tin gồm: MAHV, Họ & tên HV, Điểm trung bình, xếp loại.
Mã lớp là tham số của hàm
*/
GO
create function F_DSHV
(@MALOP as CHAR(3)
)
RETURNS TABLE
AS
     RETURN
(
    SELECT MAHV, 
           HO, 
           TEN, 
           dbo.F_DTB(MAHV) AS DTB, 
           dbo.F_XL(MAHV) AS XL
    FROM HOCVIEN
    WHERE MALOP = @MALOP
);