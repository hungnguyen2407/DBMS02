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
