/*
- Môn: Hệ quản trị cơ sở dữ liệu
- Giảng viên: Nguyễn Thị Minh Hương
- Thứ 3 tiết 456
- Bài thực hành số 2
- Nhóm 02
*/
------------------------------------
/* Phần 1 + 2 + câu 1 phần 3 + câu 1 phần 4: 
Họ và tên: Trần Đình Hòa
MSSV: 15130061

Phần 3: Procedures
Từ câu 2-5
Họ và tên: Phạm Duy Bảo Minh
MSSV: 15130102

Phần 4: Functions
Từ câu 2-5
Họ và tên: Nguyễn Hoàng Hưng
MSSV: 14130047
*/
------------------------------------

/* Batchs */
--1. Viết đoạn chương trình in danh sách các số lẻ nhỏ hơn 100 
GO
DECLARE @i AS INT = 0;

WHILE @i < 100
BEGIN 
	IF(@i % 2 != 0) 
		PRINT @i;
	SET @i = @i + 1	
END	

--2.Sử dụng cấu trúc vòng lập While, nhập 6 mẫu tin vào bảng LOP (Database Sample )với nội dung: 
--◦ MALOP tăng từ K14 đến K19 
--◦ TENLOP  là 'Lop 4 khoa 1' ,…,’Lop 9 khoa 1’ 
--◦ Các thuộc tính còn lại giá trị Null  
GO
DECLARE @i AS INT , @y INT;
SET @i = 14; 

WHILE @i < 20 
BEGIN
	INSERT INTO LOP(MALOP, TENLOP, TRGLOP, SISO, MAGVCN) VALUES ('K'+CAST(@i AS VARCHAR(2)), 'Lop ' + CAST((@i - 10) AS VARCHAR(2)) + ' khoa 1', null, null, null);
	SET @i = @i + 1;
END
GO
SELECT *
FROM LOP;

/* Views */
--1. Tạo view V_KQ cho biết kết quả của lần thi cuối cùng của sinh viên với từng môn học
--◦ Thông tin gồm: MAHV, MAMH, DIEM, KQUA
CREATE VIEW V_KQ AS
  SELECT MAHV, MAMH, DIEM, KQUA
  FROM KETQUATHI
  WHERE LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE MAHV = MAHV );

SELECT * 
FROM V_KQ;

DROP VIEW V_KQ;

--2. Tạo view V_CSDL_K cho biết danh sách sinh viên thi không đạt môn CSDL ở lần thi cuối cùng.
--◦ Thông tin gồm: MAHV, HO,TEN, MALOP, DIEM
CREATE VIEW V_CSDL_K AS
  SELECT hv.MAHV, hv.HO, hv.TEN, hv.MALOP, kqt.DIEM
  FROM KETQUATHI kqt INNER JOIN HOCVIEN hv ON kqt.MAHV = hv.MAHV
  WHERE MAMH = 'CSDL' AND kqt.KQUA = 'Khong Dat' AND LANTHI = (SELECT  MAX(LANTHI) FROM KETQUATHI WHERE MAHV = MAHV);

SELECT * 
FROM V_CSDL_K;

DROP VIEW V_CSDL_K;

--3. Tạo view V_HTTT cho biết danh sách sinh viên khoa ‘He thong thong tin’
--◦ Thông tin gồm: MALOP, hoten giao vien chu nhiem, MAHV, HOTEN hoc vien
CREATE VIEW V_HTTT AS
  SELECT  hv.MALOP, gv.HOTEN,hv.MAHV ,(hv.HO + hv.TEN) AS HOTEN_HOCVIEN
  FROM Khoa k INNER JOIN GIAOVIEN gv ON k.MAKHOA = gv.MAKHOA INNER JOIN LOP l
		ON l.MAGVCN = gv.MAGV INNER JOIN HOCVIEN hv ON hv.MALOP = l.MALOP
  WHERE k.TENKHOA = 'He Thong Thong Tin'

SELECT * 
FROM V_HTTT;

DROP VIEW V_HTTT;

/* Procedures */
--1. Tạo thủ tục P_KQMH, cho biết bảng điểm của học viên (p_mahv).  
-- Thông tin gồm: Mã học viên, tên học viên, mã môn học, tên môn học, điểm(chỉ lấy điểm của lần thi cuối cùng), kết quả  
-- Thủ tục nhận 2 tham số đầu vào là mã  học viên (SV) 
GO
CREATE PROCEDURE P_KQMH (@MaHocVien CHAR(5)) AS 
	SELECT hv.MAHV,hv.TEN,mh.MAMH,mh.TENMH, kqt.DIEM ,kqt.KQUA
		FROM HOCVIEN hv   JOIN KETQUATHI kqt ON hv.MAHV=kqt.MAHV JOIN MONHOC mh ON kqt.MAMH=mh.MAMH
			WHERE hv.MAHV=@MaHocVien AND kqt.LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE MAHV= @MaHocVien);
GO
 EXECUTE P_KQMH @MaHocVien='K1102'; 

GO 
DROP PROCEDURE P_KQMH;

/* Câu 2: Tạo thủ tục P_GVMH, cho biết danh sách sinh viên học môn (p_mamh) do giáo viên
(p_mgv) phụ trách trong học kỳ (p_hocky), năm học (p_nam).
 Thông tin gồm: Mã GV, mã môn học, mahv, ho&ten hoc vien
 Thủ tục nhận các tham số đầu vào là mã môn học (p_mamh), mã giáo viên
(p_mgv), học kỳ (p_hocky), năm học (p_nam).
*/
GO
CREATE PROCEDURE P_GVMH (@MaMH varchar(100), @MaGV varchar(100), @HocKi varchar(100), @NamHoc varchar(100)) AS
	SELECT gd.MAGV, gd.MAMH, hv.MAHV, hv.HO, hv.TEN 
	FROM HOCVIEN hv INNER JOIN GIANGDAY gd ON gd.MAMH = @MaMH and gd.HOCKY = @HocKi and gd.NAM = @NamHoc
		and gd.MALOP = hv.MALOP INNER JOIN GIAOVIEN gv ON gv.MAGV = @MaGV and gv.MAGV = gd.MAGV;
GO
	EXECUTE P_GVMH @MaMH='CSDL',@MaGV='GV09',@HocKi='2',@NamHoc='2006';
GO

/* Câu 3: Tạo thủ tục P_LOP cho biết danh sách học viên của lớp (p_malop).
 Thông tin gồm: mã lớp, mgvcn, tên gv chủ nhiệm, tên trưởng lớp, mahv, ho&ten
học viên.
 Thủ tục nhận 1 tham số đầu vào là mã lớp (p_malop).
*/
GO
CREATE PROCEDURE P_LOP (@MaLop varchar(100)) AS
	SELECT l.MALOP, l.MAGVCN, l.TRGLOP, hv.MAHV, hv.HO, hv.TEN 
	FROM LOP l INNER JOIN HOCVIEN hv ON l.MALOP = @MaLop and hv.MALOP = l.MALOP;
GO
	EXECUTE p_LOP @MaLop='K11';
GO

/* Câu 4: Tạo thủ tục P_TOPN liệt kê danh sách n môn học có số lượng học đăng ký học nhiều
nhất.
 Thông tin gồm: Mã môn học, tên môn học, số lượng học viên
 Thủ tục nhận 1 tham số đầu vào là n.
*/
GO
CREATE PROCEDURE P_TOPN (@SoMonHoc varchar(100)) AS
	SELECT mh.MAMH, mh.TENMH, MAX(HVIEN) 
	FROM MONHOC mh INNER JOIN GIANGDAY gd ON gd.MAMH = mh.MAMH 
		INNER JOIN (SELECT COUNT(hv.MAHV), hv.MALOP FROM HOCVIEN hv GROUP BY hv.MAHV) AS HVIEN 
		ON HVIEN.MALOP = gd.MALOP

		SELECT COUNT(hv.MAHV), hv.MALOP FROM HOCVIEN hv GROUP BY hv.MAHV

/* Functions */
--1. Tạo hàm F_DTB cho biết điểm trung bình  các môn thi của học viên. Mỗi môn thi,chỉ lấy điểm của lần thi cuối cùng (mã học viên là tham số của hàm). 
 GO
CREATE FUNCTION F_DTB(@MSV varchar(100))
RETURNS FLOAT
AS
BEGIN
DECLARE @TB FLOAT
SELECT @TB = AVG(KETQUATHI.DIEM)
FROM KETQUATHI
WHERE @MSV=MAHV AND LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE MAHV=@MSV);
RETURN @TB
END;
GO
SELECT dbo.F_DTB('K1101') AS DTB
DROP FUNCTION F_DTB


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

/*End Lab 2 */

