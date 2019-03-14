/*
- Môn: Hệ quản trị cơ sở dữ liệu
- Giảng viên: Nguyễn Thị Minh Hương
- Thứ 3 tiết 456
- Bài thực hành số 1 
- Nhóm 02
*/

/*
	DDL (Data Definition Language)
*/

CREATE DATABASE QLGV;

USE QLGV;

CREATE TABLE KHOA(
MAKHOA varchar(4) NOT NULL, 
TENKHOA varchar(40), 
NGTLAP smalldatetime, 
TRGKHOA char(4), 
PRIMARY KEY (MAKHOA));

CREATE TABLE GIAOVIEN(
MAGV char(4) NOT NULL, 
HOTEN varchar(40), 
HOCVI varchar(10), 
HOCHAM varchar(10), 
GIOITINH varchar(3), 
NGSINH smalldatetime, 
NGVL smalldatetime, 
HESO numeric(4,2), 
MUCLUONG money, 
MAKHOA varchar(4), 
PRIMARY KEY (MAGV),
FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

CREATE TABLE LOP(
MALOP char(3) NOT NULL, 
TENLOP varchar(40), 
TRGLOP char(5), 
SISO tinyint, 
MAGVCN char(4), 
PRIMARY KEY (MALOP),
FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV)
);

CREATE TABLE HOCVIEN(
MAHV CHAR(5) NOT NULL, 
HO varchar(40), 
TEN varchar(40), 
NGSINH smalldatetime, 
GIOITINH varchar(3), 
NOISINH varchar(40), 
MALOP char(3), 
PRIMARY KEY (MAHV),
FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)
);

CREATE TABLE MONHOC(
MAMH varchar(10) NOT NULL, 
TENMH varchar(40), 
TCLT tinyint, 
TCTH tinyint, 
MAKHOA varchar(4), 
PRIMARY KEY (MAMH),
FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

CREATE TABLE DIEUKIEN(
MAMH varchar(10) NOT NULL, 
MAMH_TRUOC varchar(10) NOT NULL, 
PRIMARY KEY(MAMH, MAMH_TRUOC), 
FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH), 
FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH)
);

CREATE TABLE GIANGDAY(
MALOP char(3) NOT NULL, 
MAMH varchar(10) NOT NULL, 
MAGV char(4), 
HOCKY tinyint, 
NAM smallint, 
TUNGAY smalldatetime, 
DENNGAY smalldatetime, 
PRIMARY KEY (MALOP,MAMH, MAGV), 
FOREIGN KEY (MALOP) REFERENCES LOP(MALOP), 
FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH), 
FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV)
);

CREATE TABLE KETQUATHI(
MAHV char(5) NOT NULL, 
MAMH varchar(10) NOT NULL, 
LANTHI tinyint NOT NULL, 
NGTHI smalldatetime, 
DIEM numeric(4,2), 
KQUA varchar(10), 
PRIMARY KEY (MAHV, MAMH, LANTHI),  
FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV),  
FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
);


/*

	DML (Data Manipulation Language)

*/

--KHOA
INSERT INTO KHOA(MAKHOA, TENKHOA, NGTLAP, TRGKHOA) VALUES
 ('KHMT', 'Khoa hoc may tinh', '6/7/2005', 'GV01'),
('HTTT', 'He thong thong tin', '6/7/2005', 'GV02'),
('CNPM', 'Cong nghe phan mem', '6/7/2005', 'GV04'),
('MTT', 'Mang va truyen thong', '10/20/2005', 'GV03'),
('KTMT', 'Ky thuat may tinh', '12/20/2005', NULL);

--GIAOVIEN
INSERT INTO GIAOVIEN(MAGV, HOTEN, HOCVI, HOCHAM, GIOITINH, NGSINH, NGVL, HESO, MUCLUONG, MAKHOA) VALUES
('GV01', 'Ho Thanh Son', 'PTS', 'GS', 'Nam', '5/2/1950', '1/11/2004', 5.00, 2250000, 'KHMT'),
('GV02', 'Tran Tam Thanh', 'TS', 'PGS', 'Nam', '12/17/1965', '4/20/2004', 4.50, 2025000, 'HTTT'),
('GV03', 'Do Nghiem Phung', 'TS', 'GS', 'Nu', '8/1/1950', '9/23/2004', 4.00, 1800000, 'CNPM'),
('GV04', 'Tran Nam Son', 'TS', 'PGS', 'Nam', '2/22/1961', '1/12/2005', 4.50, 2025000, 'KHMT'),
('GV05', 'Mai Thanh Danh', 'ThS', 'GV', 'Nam', '3/12/1958', '1/12/2005', 3.00, 1350000, 'HTTT'),
('GV06', 'Tran Doan Hung', 'TS', 'GV', 'Nam', '3/11/1953', '1/12/2005', 4.50, 2025000, 'KHMT'),
('GV07', 'Nguyen Minh Tien', 'ThS', 'GV', 'Nam', '11/23/1971', '3/1/2005', 4.00, 1800000, 'KHMT'),
('GV08', 'Le Thi Tran', 'KS', NULL, 'Nu', '3/26/1974', '3/1/2005', 1.69, 760500, 'KHMT'),
('GV09', 'Nguyen To Lan', 'ThS', 'GV', 'Nu', '12/31/1966', '3/1/2005', 4.00, 1800000, 'HTTT'),
('GV10', 'Le Tran Anh Loan', 'KS', NULL, 'Nu', '7/17/1972', '3/1/2005', 1.86, 837000, 'CNPM'),
('GV11', 'Ho Thanh Tung', 'CN', 'GV', 'Nam', '1/12/1980', '5/15/2005', 2.67, 1201500, 'MTT'),
('GV12', 'Tran Van Anh', 'CN', NULL, 'Nu', '3/29/1981', '5/15/2005', 1.69, 760500, 'CNPM'),
('GV13', 'Nguyen Linh Dan', 'CN', NULL, 'Nu', '5/23/1980', '5/15/2005', 1.69, 760500, 'KHMT'),
('GV14', 'Truong Minh Chau', 'ThS', 'GV', 'Nu', '11/30/1976', '5/15/2005', 3.00, 1350000, 'MTT'),
('GV15', 'Le Ha Thanh', 'ThS', 'GV', 'Nam', '5/4/1978', '5/15/2005', 3.00, 1350000, 'KHMT');

--LOP
INSERT INTO LOP(MALOP, TENLOP, TRGLOP, SISO, MAGVCN) VALUES
('K11', 'Lop 1 khoa 1', 'K1108', 11, 'GV07'),
('K12', 'Lop 2 khoa 1', 'K1205', 11, 'GV09'),
('K13', 'Lop 3 khoa 1', 'K1305', 11, 'GV14');

--HOCVIEN
INSERT INTO HOCVIEN(MAHV, HO, TEN, NGSINH, GIOITINH, NOISINH, MALOP) VALUES
 ('K1101', 'Nguyen Van', 'A', '1/27/1986', 'Nam', 'TpHCM', 'K11'),
 ('K1102', 'Tran Ngoc', 'Han', '3/14/1986', 'Nu', 'Kien Giang', 'K11'),
 ('K1103', 'Ha Duy', 'Lap', '4/18/1986', 'Nam', 'Nghe An', 'K11'),
 ('K1104', 'Tran Ngoc', 'Linh', '3/30/1986', 'Nu', 'Tay Ninh', 'K11'),
 ('K1105', 'Tran Minh Long', 'Long', '2/27/1986', 'Nam', 'TpHCM', 'K11'),
 ('K1106', 'Le Nhat', 'Minh', '1/24/1986', 'Nam', 'TpHCM', 'K11'),
 ('K1107', 'Nguyen Nhu', 'Nhut', '1/27/1986', 'Nam', 'Ha Noi', 'K11'),
 ('K1108', 'Nguyen Manh', 'Tam', '2/27/1986', 'Nam', 'Kien Giang', 'K11'),
 ('K1109', 'Phan Thi Thanh', 'Tam', '1/27/1986', 'Nu', 'Vinh Long', 'K11'),
 ('K1110', 'Le Hoai', 'Thuong', '2/5/1986', 'Nu', 'Can Tho', 'K11'),
 ('K1111', 'Le Ha', 'Vinh', '12/25/1986', 'Nam', 'Vinh Long', 'K11'),
 ('K1201', 'Nguyen Van', 'B', '2/11/1986', 'Nam', 'TpHCM', 'K12'),
 ('K1202', 'Nguyen Thi Kim', 'Duyen', '1/18/1986', 'Nu', 'TpHCM', 'K12'),
 ('K1203', 'Tran Thi Kim', 'Duyen', '9/17/1986', 'Nu', 'TpHCM', 'K12'),
 ('K1204', 'Truong My', 'Hanh', '5/19/1986', 'Nu', 'Dong Nai', 'K12'),
 ('K1205', 'Nguyen Thanh', 'Nam', '4/17/1986', 'Nam', 'TpHCM', 'K12'),
 ('K1206', 'Nguyen Thi Truc', 'Thanh', '3/4/1986', 'Nu', 'Kien Giang', 'K12'),
 ('K1207', 'Tran Thi Bich', 'Thuy', '2/8/1986', 'Nu', 'Nghe An', 'K12'),
 ('K1208', 'Huynh Thi Kim', 'Trieu', '4/8/1986', 'Nu', 'Tay Ninh', 'K12'),
 ('K1209', 'Pham Thanh', 'Trieu', '2/23/1986', 'Nam', 'TpHCM', 'K12'),
 ('K1210', 'Ngo Thanh', 'Tuan', '2/14/1986', 'Nam', 'TpHCM', 'K12'),
 ('K1211', 'Do Thi', 'Xuan', '3/9/1986', 'Nu', 'Ha Noi', 'K12'),
 ('K1212', 'Le Thi Phi', 'Yen', '3/12/1986', 'Nu', 'TpHCM', 'K12'),
 ('K1301', 'Nguyen Thi Kim', 'Cuc', '6/9/1986', 'Nu', 'Kien Giang', 'K13'),
 ('K1302', 'Truong Thi My', 'Hien', '3/18/1986', 'Nu', 'Nghe An', 'K13'),
 ('K1303', 'Le Duc', 'Hien', '3/21/1986', 'Nam', 'Tay Ninh', 'K13'),
 ('K1304', 'Le Quang', 'Hien', '4/18/1986', 'Nam', 'TpHCM', 'K13'),
 ('K1305', 'Le Thi', 'Huong', '3/27/1986', 'Nu', 'TpHCM', 'K13'),
 ('K1306', 'Nguyen Thai Huu', 'Huu', '3/30/1986', 'Nam', 'Ha Noi', 'K13'),
 ('K1307', 'Tran Minh', 'Man', '5/28/1986', 'Nam', 'TpHCM', 'K13'),
 ('K1308', 'Nguyen Hieu', 'Nghia', '4/8/1986', 'Nam', 'Kien Giang', 'K13'),
 ('K1309', 'Nguyen Trung Nghia', 'Nghia', '1/18/1986', 'Nam', 'Nghe An', 'K13'),
 ('K1310', 'Tran Thi Hong', 'Tham', '4/22/1986', 'Nu', 'Tay Ninh', 'K13'),
 ('K1311', 'Tran Minh', 'Thuc', '4/4/1986', 'Nam', 'TpHCM', 'K13'),
 ('K1312', 'Nguyen Thi Kim', 'Yen', '9/7/1986', 'Nu', 'TpHCM', 'K13');

--MONHOC
INSERT INTO MONHOC(MAMH, TENMH, TCLT, TCTH, MAKHOA) VALUES
('THDC', 'Tin hoc dai cuong', 4, 1, 'KHMT'),
('CTRR', 'Cau truc roi rac', 5, 0, 'KHMT'),
('CSDL', 'Co so du lieu', 3, 1, 'HTTT'),
('CTDLGT', 'Cau truc du lieu va giai thuat', 3, 1, 'KHMT'),
('PTTKTT', 'Phan tich thiet ke thuat toan', 4, 0, 'KHMT'),
('DHMT', 'Do hoa may tinh', 3, 1, 'KHMT'),
('KTMT', 'Kien truc may tinh ', 3, 0, 'KHMT'),
('TKCSDL', 'Thiet ke co so du lieu', 3, 1, 'HTTT'),
('PTTKHTTT', 'Phan tich thiet ke he thong thong tin', 4, 1, 'HTTT'),
('HDH', 'He dieu hanh', 4, 0, 'KTMT'),
('NMCNPM', 'Nhap mon cong nghe phan mem', 3, 0, 'CNPM'),
('LTCFW', 'Lap trinh C for win', 3, 1, 'CNPM'),
('LTHDT', 'Lap trinh huong doi tuong', 3, 1, 'CNPM');

--GIANGDAY
INSERT INTO GIANGDAY(MALOP, MAMH, MAGV, HOCKY, NAM, TUNGAY, DENNGAY) VALUES
('K11', 'THDC', 'GV07', 1, 2006, '1/2/2006', '5/12/2006'),
('K12', 'THDC', 'GV06', 1, 2006, '1/2/2006', '5/12/2006'),
('K13', 'THDC', 'GV15', 1, 2006, '1/2/2006', '5/12/2006'),
('K11', 'CTRR', 'GV02', 1, 2006, '1/9/2006', '5/17/2006'),
('K12', 'CTRR', 'GV02', 1, 2006, '1/9/2006', '5/17/2006'),
('K13', 'CTRR', 'GV08', 1, 2006, '1/9/2006', '5/17/2006'),
('K11', 'CSDL', 'GV05', 2, 2006, '6/1/2006', '7/15/2006'),
('K12', 'CSDL', 'GV09', 2, 2006, '6/1/2006', '7/15/2006'),
('K13', 'CTDLGT', 'GV15', 2, 2006, '6/1/2006', '7/15/2006'),
('K13', 'CSDL', 'GV05', 3, 2006, '8/1/2006', '12/15/2006'),
('K13', 'DHMT', 'GV07', 3, 2006, '8/1/2006', '12/15/2006'),
('K11', 'CTDLGT', 'GV15', 3, 2006, '8/1/2006', '12/15/2006'),
('K12', 'CTDLGT', 'GV15', 3, 2006, '8/1/2006', '12/15/2006'),
('K11', 'HDH', 'GV04', 1, 2007, '1/2/2007', '2/18/2007'),
('K12', 'HDH', 'GV04', 1, 2007, '1/2/2007', '3/20/2007'),
('K11', 'DHMT', 'GV07', 1, 2007, '2/18/2007', '3/20/2007');

--DIEUKIEN
INSERT INTO DIEUKIEN(MAMH, MAMH_TRUOC) VALUES
('CSDL', 'CTRR'),
('CSDL', 'CTDLGT'),
('CTDLGT', 'THDC'),
('PTTKTT', 'THDC'),
('PTTKTT', 'CTDLGT'),
('DHMT', 'THDC'),
('LTHDT', 'THDC'),
('PTTKTT', 'CSDL');

--KETQUATHI
INSERT INTO KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES
 ('K1101', 'CSDL', 1, '7/20/2006', 10.0, 'Dat'),
 ('K1101', 'CTDLGT', 1, '12/08/2006', 9.0, 'Dat'),
 ('K1101', 'THDC', 1, '5/20/2006', 9.0, 'Dat'),
 ('K1101', 'CTRR', 1, '5/13/2006', 9.5, 'Dat'),
 ('K1102', 'CSDL', 1, '7/20/2006', 4.0, 'Khong Dat'),
 ('K1102', 'CSDL', 2, '7/27/2006', 4.25, 'Khong Dat'),
 ('K1102', 'CSDL', 3, '8/10/2006', 4.50, 'Khong Dat'),
 ('K1102', 'CTDLGT', 1, '12/28/2006', 4.50, 'Khong Dat'),
 ('K1102', 'CTDLGT', 2, '1/5/2007', 4.0, 'Khong Dat'),
 ('K1102', 'CTDLGT', 3, '1/15/2007', 6.0, 'Dat'),
 ('K1102', 'THDC', 1, '5/20/2006', 5.0, 'Dat'),
 ('K1102', 'CTRR', 1, '5/13/2006', 7.0, 'Dat'),
 ('K1103', 'CSDL', 1, '7/20/2006', 3.5, 'Khong Dat'),
 ('K1103', 'CSDL', 2, '7/27/2006', 8.25, 'Dat'),
 ('K1103', 'CTDLGT', 1, '12/28/2006', 7.0, 'Dat'),
 ('K1103', 'THDC', 1, '5/20/2006', 8.0, 'Dat'),
 ('K1103', 'CTRR', 1, '5/13/2006', 6.5, 'Dat'),
 ('K1104', 'CSDL', 1, '7/20/2006', 3.75, 'Khong Dat'),
 ('K1104', 'CTDLGT', 1, '12/28/2006', 4.0, 'Khong Dat'),
 ('K1104', 'THDC', 1, '5/20/2006', 4.0, 'Khong Dat'),
 ('K1104', 'CTRR', 1, '5/13/2006', 4.0, 'Khong Dat'),
 ('K1104', 'CTRR', 2, '5/20/2006', 3.5, 'Khong Dat'),
 ('K1104', 'CTRR', 3, '6/30/2006', 4.0, 'Khong Dat'),
 ('K1201', 'CSDL', 1, '7/20/2006', 6.0, 'Khong Dat'),
 ('K1201', 'CTDLGT', 1, '12/28/2006', 5.0, 'Dat'),
 ('K1201', 'THDC', 1, '5/20/2006', 8.5, 'Dat'),
 ('K1201', 'CTRR', 1, '5/13/2006', 9.0, 'Dat'),
 ('K1202', 'CSDL', 1, '7/20/2006', 8.0, 'Dat'),
 ('K1202', 'CTDLGT', 1, '12/28/2006', 4.0, 'Khong Dat'),
 ('K1202', 'CTDLGT', 2, '1/5/2007', 5.0, 'Dat'),
 ('K1202', 'THDC', 1, '5/20/2006', 4.0, 'Khong Dat'),
 ('K1202', 'THDC', 2, '5/27/2006', 4.0, 'Khong Dat'),
 ('K1202', 'CTRR', 1, '5/13/2006', 3.0, 'Khong Dat'),
 ('K1202', 'CTRR', 2, '5/20/2006', 4.00, 'Khong Dat'),
 ('K1202', 'CTRR', 3, '6/30/2006', 6.25, 'Dat'),
 ('K1203', 'CSDL', 1, '7/20/2006', 9.25, 'Dat'),
 ('K1203', 'CTDLGT', 1, '12/28/2006', 9.50, 'Dat'),
 ('K1203', 'THDC', 1, '5/20/2006', 10.00, 'Dat'),
 ('K1203', 'CTRR', 1, '5/13/2006', 10.00, 'Dat'),
 ('K1204', 'CSDL', 1, '7/20/2006', 8.50, 'Dat '),
 ('K1204', 'CTDLGT', 1, '12/28/2006', 6.75, 'Dat'),
 ('K1204', 'THDC', 1, '5/20/2006', 4.00, 'Khong Dat'),
 ('K1204', 'CTRR', 1, '5/13/2006', 6.00, 'Dat'),
 ('K1301', 'CSDL', 1, '12/20/2006', 4.25, 'Khong Dat'),
 ('K1301', 'CTDLGT', 1, '7/25/2006', 8.00, 'Dat'),
 ('K1301', 'THDC', 1, '5/20/2006', 7.75, 'Dat'),
 ('K1301', 'CTRR', 1, '5/13/2006', 8.00, 'Dat'),
 ('K1302', 'CSDL', 1, '12/20/2006', 6.75, 'Dat'),
 ('K1302', 'CTDLGT', 1, '7/25/2006', 5.00, 'Dat'),
 ('K1302', 'THDC', 1, '5/20/2006', 8.00, 'Dat'),
 ('K1302', 'CTRR', 1, '5/13/2006', 8.50, 'Dat'),
 ('K1303', 'CSDL', 1, '12/20/2006', 4.00, 'Khong Dat'),
 ('K1303', 'CTDLGT', 1, '7/25/2006', 4.50, 'Khong Dat'),
 ('K1303', 'CTDLGT', 2, '8/7/2006', 4.00, 'Khong Dat'),
 ('K1303', 'CTDLGT', 3, '8/15/2006', 4.25, 'Khong Dat'),
 ('K1303', 'THDC', 1, '5/20/2006', 4.50, 'Khong Dat'),
 ('K1303', 'CTRR', 1, '5/13/2006', 3.25, 'Khong Dat'),
 ('K1303', 'CTRR', 2, '5/20/2006', 5.00, 'Dat'),
 ('K1304', 'CSDL', 1, '12/20/2006', 7.75, 'Dat'),
 ('K1304', 'CTDLGT', 1, '7/25/2006', 9.75, 'Dat'),
 ('K1304', 'THDC', 1, '5/20/2006', 5.50, 'Dat'),
 ('K1304', 'CTRR', 1, '5/13/2006', 5.00, 'Dat'),
 ('K1305', 'CSDL', 1, '12/20/2006', 9.25, 'Dat'),
 ('K1305', 'CTDLGT', 1, '7/25/2006', 10.00, 'Dat'),
 ('K1305', 'THDC', 1, '5/20/2006', 8.00, 'Dat'),
 ('K1305', 'CTRR', 1, '5/13/2006', 10.00, 'Dat');


/*
- Môn: Hệ quản trị cơ sở dữ liệu
- Giảng viên: Nguyễn Thị Minh Hương
- Thứ 3 tiết 456
- Bài thực hành số 1 
- Nhóm 02
*/
------------------------------------
/* Phần 1: 
Từ câu 1-10
Họ và tên: Phạm Duy Bảo Minh
MSSV: 15130102

Phần 2: 
Từ câu 11-20
Họ và tên: Nguyễn Hoàng Hưng
MSSV: 14130047

Phần 3: 
Từ câu 21-30
Họ và tên: Trần Đình Hòa
MSSV: 15130061

Phần 4:
Từ câu 31-35
Cả nhóm ngồi làm chung với nhau
*/
------------------------------------
/* câu 1: In ra danh sách(Mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp */
SELECT hv.MAHV, hv.HO, hv.TEN, hv.NGSINH, hv.MALOP 
FROM HOCVIEN hv inner join LOP l 
ON hv.MAHV = l.TRGLOP;
/* câu 2: In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”,
sắp xếp theo tên, họ học viên. */
SELECT hv.MAHV, hv.HO, hv.TEN, kq.LANTHI, kq.DIEM 
FROM HOCVIEN hv inner join KETQUATHI kq 
	ON kq.MAHV = hv.MAHV and kq.MAMH='CTRR' and hv.MALOP='K12';
/* câu 3: In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó
thi lần thứ nhất đã đạt. */
SELECT hv.MAHV, hv.HO, hv.TEN, mh.*
FROM HOCVIEN hv, MONHOC mh inner join KETQUATHI kq 
ON kq.LANTHI='1' and kq.MAMH = mh.MAMH
WHERE kq.MAHV = hv.MAHV;
/* câu 4: In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở
lần thi 1). */
SELECT hv.MAHV, hv.HO, hv.TEN
FROM LOP l, HOCVIEN hv inner join KETQUATHI kq 
ON kq.MAMH='CTRR' and kq.LANTHI>1 and kq.MAHV = hv.MAHV 
WHERE l.MALOP='K11' and l.MALOP = hv.MALOP;
/* câu 5: Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả
các lần thi). */
SELECT hv.MAHV, hv.HO, hv.TEN 
FROM HOCVIEN hv inner join KETQUATHI kq 
ON hv.MAHV = kq.MAHV and kq.MAMH='CTRR'
		and hv.MALOP LIKE 'K%' and kq.KQUA != 'Dat' 
		inner join (SELECT COUNT(kq.MAHV) AS TONGSOLANTHI, kq.MAHV 
					FROM KETQUATHI kq 
					WHERE kq.MAMH='CTRR'
					GROUP BY kq.MAHV) AS TSLT 
ON hv.MAHV = TSLT.MAHV and TSLT.TONGSOLANTHI = kq.LANTHI
/* câu 6: Cho biết tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1
năm 2006. */
SELECT mh.TENMH 
FROM MONHOC mh, GIANGDAY gd inner join GIAOVIEN gv
ON gv.MAGV = gd.MAGV and gv.HOTEN='Tran Tam Thanh' 
WHERE gd.NAM='2006' and gd.HOCKY='1' and mh.MAMH = gd.MAMH;
/* câu 7: Cho biết những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11”
dạy trong học kỳ 1 năm 2006. */
SELECT mh.MAMH, mh.TENMH 
FROM MONHOC mh, GIANGDAY gd inner join GIAOVIEN gv 
ON gv.MAGV = gd.MAGV and gd.HOCKY='1' and gd.NAM='2006' inner join LOP l 
ON l.MAGVCN = gv.MAGV and l.MALOP='K11'
WHERE mh.MAMH = gd.MAMH 
/* câu 8: Cho biết họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co
So Du Lieu”. */
SELECT hv.HO, hv.TEN 
FROM HOCVIEN hv, LOP l, GIAOVIEN gv inner join GIANGDAY gd 
ON gv.MAGV = gd.MAGV and gv.HOTEN='Nguyen To Lan' inner join MONHOC mh
ON mh.MAMH = gd.MAMH and mh.TENMH='Co So Du Lieu' 
WHERE hv.MAHV = l.TRGLOP
/* câu 9: In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co
So Du Lieu”. */
SELECT DISTINCT mh.MAMH, mh.TENMH
FROM MONHOC mh, DIEUKIEN dk inner join
	(SELECT mh.MAMH, mh.TENMH 
	FROM MONHOC mh, DIEUKIEN dk 
	WHERE mh.MAMH = dk.MAMH and mh.TENMH='Co So Du Lieu') AS MHTQ
ON MHTQ.MAMH = dk.MAMH
WHERE mh.MAMH = dk.MAMH_TRUOC
/* câu 10: Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn
học, tên môn học) nào. */
SELECT mh.MAMH, mh.TENMH FROM MONHOC mh, DIEUKIEN dk inner join 
	(SELECT mh.MAMH, mh.TENMH 
	FROM MONHOC mh, DIEUKIEN dk
	WHERE mh.MAMH = dk.MAMH_TRUOC and mh.TENMH='Cau Truc Roi Rac') AS MHT 
ON MHT.MAMH = dk.MAMH_TRUOC
WHERE mh.MAMH = dk.MAMH


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


--Câu 21: Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT HOCVI,COUNT(*)AS SOLUONG
FROM GIAOVIEN
GROUP BY HOCVI;
--Câu 22: Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT KQUA, COUNT(MAHV) AS SOLUONG
FROM KETQUATHI
GROUP BY KQUA;
--Câu 23: Cho biết giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT GIAOVIEN.MAGV,GIAOVIEN.HOTEN, COUNT(GIANGDAY.MAMH) AS SOMONDAY
FROM GIAOVIEN,LOP,GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV AND GIAOVIEN.MAGV=LOP.MAGVCN AND LOP.MALOP=GIANGDAY.MALOP
GROUP BY GIAOVIEN.MAGV,GIAOVIEN.HOTEN;
--24.Cho biết họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT hv.HO,hv.TEN FROM HOCVIEN hv WHERE hv.MAHV IN (SELECT l.TRGLOP FROM LOP l WHERE l.SISO= (SELECT MAX(SISO) FROM LOP));
--25.Cho biết họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
SELECT hv.HO,hv.TEN FROM HOCVIEN hv JOIN LOP lop ON hv.MAHV=lop.TRGLOP JOIN (SELECT kqt.MAHV,kqt.MAMH,kqt.KQUA FROM KETQUATHI kqt
WHERE kqt.KQUA='Khong Dat' GROUP BY kqt.MAHV,kqt.MAMH,kqt.KQUA HAVING COUNT(kqt.MAMH)=COUNT(kqt.KQUA)) a ON a.MAHV =hv.MAHV
GROUP BY hv.HO, hv.TEN HAVING COUNT(*)>3;
--26.Cho biết học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT hv.MAHV , hv.HO, hv.TEN FROM HOCVIEN hv JOIN KETQUATHI kqt ON hv.MAHV =kqt.MAHV WHERE  kqt.DIEM >=9.00
GROUP BY hv.MAHV,hv.HO,hv.TEN HAVING COUNT(kqt.DIEM)>=ALL(SELECT COUNT(DIEM) FROM KETQUATHI WHERE DIEM>=9.00 GROUP BY MAHV);
--27. Trong từng lớp, Cho biết học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất. 
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN
FROM HOCVIEN JOIN KETQUATHI 
ON HOCVIEN.MAHV = KETQUATHI.MAHV 
WHERE KETQUATHI.DIEM >= 9.00
GROUP BY HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN
HAVING count(KETQUATHI.DIEM) >=ALL(SELECT COUNT(DIEM) 
									FROM KETQUATHI
									WHERE KETQUATHI.DIEM >= 9.00
									GROUP BY KETQUATHI.MAHV);
	
--28.Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT GIANGDAY.HOCKY, GIANGDAY.NAM,GIAOVIEN.MAGV, GIAOVIEN.HOTEN, COUNT(GIANGDAY.MAMH) AS 'SOMONHOC', COUNT(GIANGDAY.MALOP) AS 'SOLOPGIANGDAY'
FROM GIAOVIEN INNER JOIN GIANGDAY 
ON GIAOVIEN.MAGV = GIANGDAY.MAGV
GROUP BY GIANGDAY.HOCKY, GIANGDAY.NAM,GIAOVIEN.MAGV, GIAOVIEN.HOTEN;

--29.  Trong từng học kỳ của từng năm, Cho biết giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT GIANGDAY.HOCKY, GIANGDAY.NAM, GIAOVIEN.MAGV, GIAOVIEN.HOTEN,COUNT(GIANGDAY.MALOP)AS 'SOLOPGIANGDAY'
FROM GIANGDAY INNER JOIN GIAOVIEN
ON GIANGDAY.MAGV = GIAOVIEN.MAGV
GROUP BY GIANGDAY.HOCKY, GIANGDAY.NAM,GIAOVIEN.MAGV, GIAOVIEN.HOTEN
HAVING COUNT(GIANGDAY.MALOP) >=ALL(SELECT COUNT(GIANGDAY.MALOP) AS 'SOLOPGIANGDAY'
									FROM GIANGDAY INNER JOIN GIAOVIEN
									ON GIANGDAY.MAGV = GIAOVIEN.MAGV);
--30. Cho biết môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất. 
SELECT KQ.MAMH, TENMH
FROM MONHOC MH INNER JOIN KETQUATHI KQ ON KQ.MAMH = MH.MAMH
WHERE KQUA = 'Khong Dat' AND LANTHI=1
GROUP BY KQ.MAMH, TENMH
HAVING COUNT(MAHV) = (
	SELECT TOP 1 COUNT(*)
	FROM KETQUATHI
	WHERE KQUA = 'Khong Dat' AND LANTHI=1
	GROUP BY MAMH
	ORDER BY COUNT(*) DESC);

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

/* câu 35: Cho biết học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở
lần thi sau cùng). */
SELECT hv.MAHV, hv.HO, hv.TEN
FROM HOCVIEN hv, KETQUATHI kq inner join
	(SELECT kq.MAHV, kq.MAMH, MAX(kq.DIEM) AS DIEMCAONHAT, COUNT(kq.LANTHI) AS TONGSOLANTHI
	FROM KETQUATHI kq 
	GROUP BY kq.MAHV, kq.MAMH) AS KQCN
ON KQCN.DIEMCAONHAT = kq.DIEM and KQCN.MAMH = kq.MAMH and KQCN.MAHV = kq.MAHV and KQCN.TONGSOLANTHI = kq.LANTHI
WHERE hv.MAHV = kq.MAHV
