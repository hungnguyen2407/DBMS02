﻿--1. Học viên thi một môn tối đa 3 lần. 
GO
CREATE TRIGGER CHECK_LANTHI
ON KETQUATHI FOR INSERT
AS
IF(SELECT KQ.LANTHI
FROM KETQUATHI KQ INNER JOIN INSERTED I ON KQ.LANTHI = I.LANTHI)>3
BEGIN
PRINT('HỌC VIÊN THI TỐI ĐA 3 LẦN')
ROLLBACK TRANSACTION
END

--2. Học kỳ chỉ có giá trị từ 1 đến 3.
GO 
CREATE TRIGGER CHECK_HOCKY
ON GIANGDAY FOR INSERT
AS
IF EXISTS(
SELECT G.HOCKY 
FROM GIANGDAY G INNER JOIN INSERTED I ON G.MAMH = I.MAMH
WHERE G.HOCKY NOT BETWEEN '1' AND '3')
BEGIN
PRINT('HỌC KÌ CHỈ CÓ GIÁ TRỊ TỪ 1 ĐẾN 3')
ROLLBACK TRANSACTION
END
DELETE FROM GIANGDAY WHERE GIANGDAY.MALOP='K11'
INSERT INTO GIANGDAY(MALOP,MAMH,MAGV,HOCKY,NAM,TUNGAY,DENNGAY)
VALUES ('K11','CTRR','GV07','4','2006','1/2/2006','5/12/2006')
DROP TRIGGER CHECK_HOCKY;

--3. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”. 
GO
CREATE TRIGGER CHECK_HOCVI ON GIAOVIEN
FOR INSERT
AS
IF EXISTS (SELECT GV.HOCVI
FROM GIAOVIEN GV INNER JOIN INSERTED I ON GV.MAGV = I.MAGV
WHERE GV.HOCVI NOT IN('CN','KS','Ths','TS','PTS'))
BEGIN 
PRINT('HỌC VỊ CỦA GIÁO VIÊN CHỈ CÓ THỂ LÀ CN, KS, Ths, TS, PTS')
ROLLBACK TRANSACTION
END

INSERT INTO GIAOVIEN(MAGV,HOTEN,HOCVI,HOCHAM,GIOITINH,NGSINH,NGVL,HESO,MUCLUONG,MAKHOA)
VALUES('01','AB','CC','GS','NAM','12/11/1998','12/4/2006','4','1200000','CNPM');

DROP TRIGGER CHECK_HOCVI;

--4. Lớp trưởng của một lớp phải là học viên của lớp đó.
GO 
CREATE TRIGGER LOP_TRUONG
ON LOP
FOR INSERT
AS
DECLARE @mahv AS char(5)
DECLARE @malop AS CHAR(3)
SET @mahv=(SELECT I.TRGLOP FROM INSERTED I)
SET @malop=(SELECT I.MALOP FROM INSERTED I)
IF(
EXISTS(
SELECT HOCVIEN.*
FROM HOCVIEN
WHERE HOCVIEN.MALOP =@malop)
)
BEGIN
IF(@mahv NOT IN(
SELECT HOCVIEN.MAHV
FROM HOCVIEN
WHERE HOCVIEN.MALOP =@malop))
RAISERROR('LOP TRUONG KHONG CUNG MOT LOP',10,1)
ROLLBACK
END

DROP TRIGGER LOP_TRUONG


--5. Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”.
GO
CREATE TRIGGER TRKHOA_HOCVI 
ON KHOA
FOR INSERT, UPDATE
AS 
BEGIN
	DECLARE @hocvi VARCHAR(100)
	SET @hocvi = (SELECT HOCVI FROM INSERTED JOIN GIAOVIEN ON INSERTED.TRGKHOA = GIAOVIEN.MAGV)
	IF(@hocvi != 'TS' AND @hocvi != 'PTS')
		BEGIN
		PRINT N'TRUONG KHOA PHAI CO HOC VI TS HOAC PTS'
		ROLLBACK TRAN	
		END
END

DROP TRIGGER TRKHOA_HOCVI

--6. Học viên ít nhất là 18 tuổi
GO
CREATE TRIGGER TUOI_HOCVIEN
ON HOCVIEN
FOR INSERT, UPDATE 
AS 
BEGIN	
	DECLARE @ngaysinh smalldatetime 
	SET @ngaysinh = (SELECT NGSINH FROM INSERTED)
	IF(YEAR(SYSDATETIME()) - YEAR(@ngaysinh) < 18)
		BEGIN
		PRINT N'Học viên ít nhất là 18 tuổi'
		ROLLBACK TRAN
		END
END		

DROP TRIGGER TUOI_HOCVIEN