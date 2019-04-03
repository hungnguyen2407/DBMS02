
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
