/*
- Môn: Hệ quản trị cơ sở dữ liệu
- Giảng viên: Nguyễn Thị Minh Hương
- Thứ 3 tiết 456
- Bài thực hành số 3
- Nhóm 02
*/
------------------------------------
/* Câu 1-6: 
Họ và tên: Trần Đình Hòa
MSSV: 15130061

Câu 7-12 + câu 19:
Họ và tên: Nguyễn Hoàng Hưng
MSSV: 14130047

Câu 13-18:
Họ và tên: Phạm Duy Bảo Minh
MSSV: 15130102
*/
------------------------------------


--1. Học viên thi một môn tối đa 3 lần. 
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


/*
7. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc
(DENNGAY).
*/

GO
--trigger insert giang day

create trigger giangday_insert_ngayhoc ON GIANGDAY
FOR INSERT
AS
	--khoi tao bien chua ngay bat dau giang day va ngay ket thuc
	declare @tungay date, @denngay date;
	--khoi tao cursor chua bang du lieu nhap vao 
	declare giangday_cursor CURSOR
	for select TUNGAY, DENNGAY
		from inserted;
	--mo cursor
	open giangday_cursor;
	--doc du lieu tu cursor
	fetch NEXT FROM giangday_cursor INTO @tungay, @denngay;
	--kiem tra ket qua fetch
	while @@FETCH_STATUS = 0
	begin
		--kiem tra dieu kien
		if @denngay < @tungay
		begin
			--thong bao loi va rollback
			RAISERROR('Ngay bat dau phai nho hon ngay ket thuc', 10, 1);
			rollback;
			BREAK;
		end;
		ELSE
		begin
			--lay du lieu  
			fetch NEXT FROM giangday_cursor INTO @tungay, @denngay;
		end;
	end;
	--dong cursor
	CLOSE giangday_cursor;
	--xoa cursor
	DEALLOCATE giangday_cursor;
GO
--trigger update giang day

create trigger giangday_update_ngayhoc ON GIANGDAY
FOR UPDATE
AS
	declare @tungay date, @denngay date;
	declare giangday_cursor CURSOR
	for select TUNGAY, DENNGAY
		from inserted;
	open giangday_cursor;
	fetch NEXT FROM giangday_cursor INTO @tungay, @denngay;
	while @@FETCH_STATUS = 0
	begin
		if @denngay < @tungay
		begin
			RAISERROR('Ngay bat dau phai nho hon ngay ket thuc', 10, 1);
			rollback;
			BREAK;
		end;
		ELSE
		begin
			fetch NEXT FROM giangday_cursor INTO @tungay, @denngay;
		end;
	end;
	CLOSE giangday_cursor;
	DEALLOCATE giangday_cursor;

/*
8. Giáo viên khi vào làm ít nhất là 22 tuổi.
*/

GO
--tao trigger 
create trigger giaovien_insert_tuoi ON GIAOVIEN
FOR INSERT
AS
	--khoi tao bien
	declare @ngsinh date, @hientai date= GETDATE(); -- lay ngay hien tai
	--khoi tao cursor
	declare giaovien_insert CURSOR
	for select NGSINH
		from inserted;
	--mo cursor
	open giaovien_insert;
	--lay du lieu tu cursor
	fetch FROM giaovien_insert into @ngsinh;
	--kiem tra fetch status
	while @@FETCH_STATUS = 0
	begin
		--kiem tra co tren 22 tuoi
		if YEAR(@hientai) - YEAR(@ngsinh) < 22
		--nho hon 22 tuoi tra ve loi va rollback
		begin
			RAISERROR('Giao vien phai it nhat 22 tuoi', 10, 1);
			rollback;
			BREAK;
		end;
			--kiem tra ngay/thang neu co 22 tuoi tinh theo nam
		ELSE
		begin
			if YEAR(@hientai) - YEAR(@ngsinh) = 22
			begin
				if MONTH(@ngsinh) > MONTH(@hientai)
				begin
					RAISERROR('Giao vien phai it nhat 22 tuoi', 10, 1);
					rollback;
					BREAK;
				end;
				ELSE
				begin
					if MONTH(@ngsinh) = MONTH(@hientai)
					begin
						if DAY(@ngsinh) > DAY(@hientai)
						begin
							RAISERROR('Giao vien phai it nhat 22 tuoi', 10, 1);
							rollback;
							BREAK;
						end;
					end;
				end;
			end;
			ELSE
			begin
				fetch FROM giaovien_insert into @ngsinh;
			end;
		END;
	END;
	CLOSE giaovien_insert;
	DEALLOCATE giaovien_insert;
GO

--trigger kiem tra khi update du lieu

create trigger giaovien_update_tuoi ON GIAOVIEN
FOR UPDATE
AS
	declare @ngsinh date, @hientai date= GETDATE();
	declare giaovien_insert CURSOR
	for select NGSINH
		from inserted;
	open giaovien_insert;
	fetch FROM giaovien_insert into @ngsinh;
	while @@FETCH_STATUS = 0
	begin
		if YEAR(@hientai) - YEAR(@ngsinh) < 22
		begin
			RAISERROR('Giao vien phai it nhat 22 tuoi', 10, 1);
			rollback;
			BREAK;
		end;
		ELSE
		begin
			if YEAR(@hientai) - YEAR(@ngsinh) = 22
			begin
				if MONTH(@ngsinh) > MONTH(@hientai)
				begin
					RAISERROR('Giao vien phai it nhat 22 tuoi', 10, 1);
					rollback;
					BREAK;
				end;
				ELSE
				begin
					if MONTH(@ngsinh) = MONTH(@hientai)
					begin
						if DAY(@ngsinh) > DAY(@hientai)
						begin
							RAISERROR('Giao vien phai it nhat 22 tuoi', 10, 1);
							rollback;
							BREAK;
						end;
					end;
				end;
			end;
			ELSE
			begin
				fetch FROM giaovien_insert into @ngsinh;
			end;
		END;
	END;
	CLOSE giaovien_insert;
	DEALLOCATE giaovien_insert;

/*
9. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch
nhau không quá 3.
*/

GO
--tao trigger

create trigger monhoc_insert_tinchi ON MONHOC
FOR INSERT
AS
	--khoi tao bien
	declare @tclt int, @tcth int;
	--khoi tao cursor
	declare monhoc_cursor CURSOR
	for select tclt, tcth
		from inserted;
	--mo cursor
	open monhoc_cursor;
	--lay du lieu
	fetch FROM monhoc_cursor into @tclt, @tcth;
	while @@FETCH_STATUS = 0
	begin
		--kiem tra chenh lech giua so tin chi ly thuyet va so tin chi thuc hanh
		if(abs(@tclt - @tcth) > 3)
		begin
			RAISERROR('Tin chi ly thuyet va tin chi thuc hanh chenh lech qua 3', 10, 1);
			rollback;
			BREAK;
		end;
		--lay du lieu
		fetch FROM monhoc_cursor into @tclt, @tcth;
	end;
	--dong cursor
	CLOSE monhoc_cursor;
	--xoa cursor
	DEALLOCATE monhoc_cursor;

GO

--trigger kiem tra khi update du lieu

create trigger monhoc_update_tinchi ON MONHOC
FOR UPDATE
AS
	declare @tclt int, @tcth int;
	declare monhoc_cursor CURSOR
	for select tclt, tcth
		from inserted;
	open monhoc_cursor;
	fetch FROM monhoc_cursor into @tclt, @tcth;
	while @@FETCH_STATUS = 0
	begin
		if abs(@tclt - @tcth) > 3
		begin
			RAISERROR('Tin chi ly thuyet va tin chi thuc hanh chenh lech qua 3', 10, 1);
			rollback;
			BREAK;
		end;
		fetch FROM monhoc_cursor into @tclt, @tcth;
	end;
	CLOSE monhoc_cursor;
	DEALLOCATE monhoc_cursor;

/*
10. Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong
môn học này.
*/

GO
--khoi tao trigger

create trigger ketquathi_insert_dahoc ON KETQUATHI
FOR INSERT
AS
	declare @mahv varchar(5), @mamh varchar(5), @malop varchar(5), @ngayhoc date, @ngaythi date;
	declare ketquathi_cursor CURSOR
	for select MAMH, MAHV, NGTHI
		from inserted;
	open ketquathi_cursor;
	fetch FROM ketquathi_cursor into @mamh, @mahv, @ngthi;
	while @@FETCH_STATUS = 0
	begin
		select @malop = MALOP
		from HOCVIEN
		where MAHV = @mahv;
		select @ngayhoc = DENNGAY
		from GIANGDAY;
		if exists
		(
			select *
			from GIANGDAY
			where MAMH = @mamh and
				  MALOP = @malop
		)
		begin
			if @ngayhoc > @ngaythi
			begin
				RAISERROR('Lop hoc cua hoc vien phai hoc xong mon hoc', 10, 1);
				rollback;
				BREAK;
			end;
			fetch FROM ketquathi_cursor into @mamh, @mahv, @ngthi;
		end;
		ELSE
		begin
			RAISERROR('Lop hoc khong ton tai', 10, 1);
			rollback;
			BREAK;
		end;
	end;
	CLOSE ketquathi_cursor;
	DEALLOCATE ketquathi_cursor;
	
GO

create trigger ketquathi_update_dahoc ON KETQUATHI
FOR UPDATE
AS
	declare @mahv varchar(5), @mamh varchar(5), @malop varchar(5), @ngayhoc date, @ngaythi date;
	declare ketquathi_cursor CURSOR
	for select MAMH, MAHV, NGTHI
		from inserted;
	open ketquathi_cursor;
	fetch FROM ketquathi_cursor into @mamh, @mahv, @ngthi;
	while @@FETCH_STATUS = 0
	begin
		select @malop = MALOP
		from HOCVIEN
		where MAHV = @mahv;
		select @ngayhoc = DENNGAY
		from GIANGDAY;
		if exists
		(
			select *
			from GIANGDAY
			where MAMH = @mamh and
				  MALOP = @malop
		)
		begin
			if @ngayhoc > @ngaythi
			begin
				RAISERROR('Lop hoc cua hoc vien phai hoc xong mon hoc', 10, 1);
				rollback;
				BREAK;
			end;
			fetch FROM ketquathi_cursor into @mamh, @mahv, @ngthi;
		end;
		ELSE
		begin
			RAISERROR('Lop hoc khong ton tai', 10, 1);
			rollback;
			BREAK;
		end;
	end;
	CLOSE ketquathi_cursor;
	DEALLOCATE ketquathi_cursor;

/*
11. Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn.
*/

GO

create trigger giangday_insert_somonhoc ON GIANGDAY
FOR INSERT
AS
	declare gianday_cursor CURSOR
	for select MALOP
		from inserted;
	declare @malop varchar(5), @somh int;
	open giangday_cursor;
	fetch FROM giangday_cursor into @malop;
	while @@FETCH_STATUS = 0
	begin
		select @somh = COUNT(*)
		from GIANGDAY
		where MALOP = @malop;
		if @somh > 3
		begin
			RAISERROR('Lop vuot qua 3 mon hoc cho phep trong hoc ky', 10, 1);
			rollback;
			BREAK;
		end;
		fetch FROM giangday_cursor into @malop;
	end;
	CLOSE giangday_cursor;
	DEALLOCATE giangday_cursor;


GO

create trigger giangday_update_somonhoc ON GIANGDAY
FOR UPDATE
AS
	declare gianday_cursor CURSOR
	for select MALOP
		from inserted;
	declare @malop varchar(5), @somh int;
	open giangday_cursor;
	fetch FROM giangday_cursor into @malop;
	while @@FETCH_STATUS = 0
	begin
		select @somh = COUNT(*)
		from GIANGDAY
		where MALOP = @malop;
		if @somh > 3
		begin
			RAISERROR('Lop vuot qua 3 mon hoc cho phep trong hoc ky', 10, 1);
			rollback;
			BREAK;
		end;
		fetch FROM giangday_cursor into @malop;
	end;
	CLOSE giangday_cursor;
	DEALLOCATE giangday_cursor;


/*
12. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó.
*/

GO

create trigger hocvien_insert_siso ON HOCVIEN
FOR INSERT
AS
	declare hocvien_cursor CURSOR
	for select MAHV, MALOP
		from inserted;
	declare @malop varchar(5), @mahv varchar(5);
	open hocvien_cursor;
	fetch FROM hocvien_cursor into @mahv, @malop;
	while @@FETCH_STATUS = 0
	begin
		if exists
		(
			select *
			from HOCVIEN
			where MAHV = @mahv
		)
		begin
			RAISERROR('Hoc vien da ton tai', 10, 1);
			rollback;
			BREAK;
		end;
		ELSE
		begin
			update LOP
			  set SISO = SISO + 1
			where MALOP = @malop;
			fetch FROM hocvien_cursor into @mahv, @malop;
		end;
	end;
	CLOSE hocvien_cursor;
	DEALLOCATE hocvien_cursor;


GO

create trigger hocvien_update_siso ON hocvien
FOR UPDATE
AS
	declare hocvien_cursor CURSOR
	for select MAHV, MALOP
		from inserted;
	declare @malop varchar(5), @mahv varchar(5);
	open hocvien_cursor;
	fetch FROM hocvien_cursor into @mahv, @malop;
	while @@FETCH_STATUS = 0
	begin
		if exists
		(
			select *
			from HOCVIEN
			where MAHV = @mahv
		)
		begin
			RAISERROR('Hoc vien da ton tai', 10, 1);
			rollback;
			BREAK;
		end;
		ELSE
		begin
			update LOP
			  set SISO = SISO + 1
			where MALOP = @malop;
			fetch FROM hocvien_cursor into @mahv, @malop;
		end;
	end;
	CLOSE hocvien_cursor;
	DEALLOCATE hocvien_cursor;

/* Câu 13: Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC
trong cùng một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại hai
bộ (“A”,”B”) và (“B”,”A”). */
DROP TRIGGER RANGBUOCDIEUKIEN
GO
CREATE TRIGGER RANGBUOCDIEUKIEN on DIEUKIEN
FOR Insert
AS
	IF EXISTS (SELECT * FROM Inserted i JOIN DIEUKIEN dk 
	ON i.MAMH = dk.MAMH_TRUOC WHERE i.MAMH = dk.MAMH_TRUOC or i.MAMH_TRUOC = dk.MAMH)
	BEGIN
		RAISERROR ('Khong hop le', 10, 1)
		ROLLBACK
	END;
INSERT INTO DIEUKIEN VALUES('CSDL','CSDL');
INSERT INTO DIEUKIEN VALUES('LTHDT','CTDLGT');

/* Câu 14: Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau. */
GO
CREATE TRIGGER MUCLUONGBANGNHAU ON GIAOVIEN
FOR Insert
AS
	IF EXISTS (SELECT * FROM Inserted i JOIN GIAOVIEN gv
	ON i.HOCHAM = gv.HOCHAM and i.HOCVI = gv.HOCVI and i.HESO = gv.HESO
	WHERE i.MUCLUONG != gv.MUCLUONG)
	BEGIN
		RAISERROR ('Muc luong khong bang nhau', 10, 1)
		ROLLBACK
	END;

/* Câu 15: Học viên chỉ được thi lại (lần thi >1) khi điểm của lần thi trước đó dưới 5. */
GO
CREATE TRIGGER DIEUKIENTHILAI ON KETQUATHI
FOR Insert
AS
	IF NOT EXISTS (SELECT * FROM Inserted i JOIN KETQUATHI kq 
	ON kq.MAHV = i.MAHV 
	WHERE i.LANTHI > 1 and kq.LANTHI = i.LANTHI -1 and kq.DIEM < 5)
	BEGIN
		RAISERROR ('Khong du dieu kien thi lai', 10, 1)
		ROLLBACK
	END;

/* Câu 16: Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước (cùng học viên,
cùng môn học). */
GO
CREATE TRIGGER NGAYTHISAULONHON ON KETQUATHI
FOR Insert
AS
	IF NOT EXISTS (SELECT * FROM Inserted i JOIN KETQUATHI kq
	ON i.MAHV = kq.MAHV and i.MAMH = kq.MAMH 
	WHERE i.LANTHI > kq.LANTHI and i.NGTHI > kq.NGTHI)
	BEGIN
		RAISERROR ('Ngay thi lan thi sau phai lon hon lan thi truoc', 10, 1)
		ROLLBACK
	END;

/* Câu 17: Học viên chỉ được thi những môn mà lớp của học viên đó đã học xong. */
GO
CREATE TRIGGER DIEUKIENTHI ON KETQUATHI
FOR Insert
AS
	IF NOT EXISTS (SELECT * FROM Inserted i JOIN HOCVIEN hv
	ON i.MAHV = hv.MAHV JOIN GIANGDAY gd ON hv.MALOP = gd.MALOP
	WHERE KETQUATHI.NGTHI > gd.DENNGAY and i.MAMH = gd.MAMH)
	BEGIN
		RAISERROR ('Hoc vien chi dc thi khi lop da hoc xong mon hoc', 10, 1)
		ROLLBACK
	END;

/* Câu 18: Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau giữa các
môn học (sau khi học xong những môn học phải học trước mới được học
những môn liền sau). */
GO
CREATE TRIGGER DIEUKIENGIANGDAYMONSAU ON GIANGDAY
FOR Insert
AS
	IF NOT EXISTS (SELECT * FROM Inserted i JOIN DIEUKIEN dk 
	ON i.MAMH = dk.MAMH JOIN GIANGDAY gd ON gd.MAMH = dk.MAMH_TRUOC
	WHERE gd.DENNGAY < i.DENNGAY)
	BEGIN
		RAISERROR ('Thu tu truoc sau cua cac mon hoc', 10, 1)
	END;
/* Câu 19: Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ
trách
*/
GO

CREATE TRIGGER giangday_insert_daycungkhoa ON GIANGDAY
FOR INSERT
AS
	DECLARE gianday_cursor CURSOR
	FOR SELECT MAGV, MAMH
		FROM inserted;
	DECLARE @magv varchar(5), @mamh varchar(5);
	OPEN giangday_cursor;
	FETCH FROM giangday_cursor INTO @magv, @mamh;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @makhoa1 varchar(5), @makhoa2 varchar(5);
		SELECT @makhoa1 = MAKHOA
		FROM GIAOVIEN
		WHERE MAGV = @magv;
		SELECT @makhoa2 = MAKHOA
		FROM MONHOC
		WHERE MAMH = @mamh;
		IF @makhoa1 != @makhoa2
		BEGIN
			RAISERROR('Giao vien khong thuoc khoa cua mon hoc nay', 10, 1);
			ROLLBACK;
			BREAK;
		END;
		FETCH FROM giangday_cursor INTO @magv, @mamh;
	END;
	CLOSE giangday_cursor;
	DEALLOCATE giangday_cursor;

GO

CREATE TRIGGER gianday_update_daycungkhoa ON GIANGDAY
FOR UPDATE
AS
	DECLARE gianday_cursor CURSOR
	FOR SELECT MAGV, MAMH
		FROM inserted;
	DECLARE @magv varchar(5), @mamh varchar(5);
	OPEN giangday_cursor;
	FETCH FROM giangday_cursor INTO @magv, @mamh;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @makhoa1 varchar(5), @makhoa2 varchar(5);
		SELECT @makhoa1 = MAKHOA
		FROM GIAOVIEN
		WHERE MAGV = @magv;
		SELECT @makhoa2 = MAKHOA
		FROM MONHOC
		WHERE MAMH = @mamh;
		IF @makhoa1 != @makhoa2
		BEGIN
			RAISERROR('Giao vien khong thuoc khoa cua mon hoc nay', 10, 1);
			ROLLBACK;
			BREAK;
		END;
		FETCH FROM giangday_cursor INTO @magv, @mamh;
	END;
	CLOSE giangday_cursor;
	DEALLOCATE giangday_cursor;

/* End Lab 3 */