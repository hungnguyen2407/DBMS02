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
