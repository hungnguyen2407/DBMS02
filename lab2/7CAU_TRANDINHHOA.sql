use QLGV

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

--View
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

--Procedures:
--1. Tạo thủ tục P_KQMH, cho biết bảng điểm của học viên (p_mahv).  
-- Thông tin gồm: Mã học viên, tên học viên, mã môn học, tên môn học, điểm, kết quả  
-- Thủ tục nhận 2 tham số đầu vào là mã môn học (MH) và mã  học viên (SV) 
GO
CREATE PROCEDURE P_KQMH (@MaMonHoc VARCHAR(10) ,@MaHocVien CHAR(5)) AS 
	SELECT hv.MAHV,hv.TEN,mh.MAMH,mh.TENMH, kqt.DIEM ,kqt.KQUA
		FROM HOCVIEN hv   JOIN KETQUATHI kqt ON hv.MAHV=kqt.MAHV JOIN MONHOC mh ON kqt.MAMH=mh.MAMH
			WHERE hv.MAHV=@MaHocVien AND mh.MAMH=@MaMonHoc AND kqt.LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI WHERE MAHV= @MaHocVien);
GO
 EXECUTE P_KQMH @MaMonHoc ='CTDLGT', @MaHocVien='K1102'; 

GO 
DROP PROCEDURE P_KQMH;

--Functions: 
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