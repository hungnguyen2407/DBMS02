create database QLBH;

go
use QLBH;

go
create table MatHang(MaMH varchar(5), TenMH nvarchar(30), Dvt int, SLTonDau int, TGTonDau int, SLNhap int, TGNhap int, SLXuat int, TGXuat int, primary key (MaMH), constraint R2 check(SLTonDau >= 0 and TGTonDau >= 0));

create table NhaCC(MaNCC varchar(5), TenNCC nvarchar(30) constraint R9 check(TenNCC not like null), DiachiNCC varchar(20), NoDau money, primary key (MaNCC));

create table DonHang(SoDH varchar(5), NgayDH date constraint R7 check(NgayDH not like null), MaNCC varchar(5), TriGia decimal(10,2), HinhthucTT nvarchar constraint R1 check(HinhthucTT = N'1' or HinhthucTT = N'2'), primary key (SoDH), foreign key (MaNCC) references NhaCC(MaNCC));

create table CTDonHang(SoDH varchar(5), MaMH varchar(5), SLDat int, DonGia decimal(10,3), foreign key (SoDH) references DonHang(SoDH),foreign key (MaMH) references MatHang(MaMH), constraint R3 check(SLDat >= 0 and DonGia >=0));

create table PHIEUNHAP(SoPN varchar(5), NgayNH date constraint R8 check(NgayNH not like null), NguoiNhan varchar(5), SoDH varchar(5), primary key (SoPN),foreign key (SoDH) references DonHang(SoDH));

create table CTNhap(SoPN varchar(5), MaMH varchar(5), SLNhap int, foreign key (MaMH) references MatHang(MaMH), foreign key (SoPN) references PHIEUNHAP(SoPN));

create table PhieuXuat(SoPX varchar(5), NgayXuat date, NguoiXuat varchar(5), LydoXuat text, primary key (SoPX));

create table CTXuat(SoPX varchar(5), MaMH varchar(5), SLXuat int, DonGiaXuat int, foreign key (SoPX) references PhieuXuat(SoPX), foreign key (MaMH) references MatHang(MaMH), constraint R4 check(SLXuat >= 0 and DonGiaXuat >= 0))

create table ThanhToan(SoCT varchar(5), NgayCT date constraint R6 check(NgayCT not like null), DienGiai text, SoHD varchar(5), SoTien decimal(10,2) constraint R5 check(SoTien > 0), primary key (SoCT), foreign key (SoHD) references DonHang(SoDH));
