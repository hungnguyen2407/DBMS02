/*
19. Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ
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