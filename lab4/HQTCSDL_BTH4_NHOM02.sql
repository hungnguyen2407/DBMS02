/*
- Môn: Hệ quản trị cơ sở dữ liệu
- Giảng viên: Nguyễn Thị Minh Hương
- Thứ 3 tiết 456
- Bài thực hành số 4
- Nhóm 02
*/
------------------------------------
/* Câu 1-3: 
Họ và tên: Nguyễn Hoàng Hưng
MSSV: 14130047

Câu 4-7 + câu 19:
Họ và tên: Phạm Duy Bảo Minh
MSSV: 15130102

Câu 8-10:
Họ và tên: Trần Đình Hòa
MSSV: 15130061
*/
------------------------------------

/* Tạo bảng */
create database QLBH;

go
use QLBH;

go
create table MatHang(MaMH varchar(5), TenMH nvarchar(30), Dvt int, SLTonDau int, TGTonDau int, SLNhap int, TGNhap int, SLXuat int, TGXuat int, primary key (MaMH), constraint R2 check(SLTonDau >= 0 and TGTonDau >= 0));

create table NhaCC(MaNCC varchar(5), TenNCC nvarchar(30) constraint R9 check(TenNCC not like null), DiachiNCC varchar(20), NoDau money, primary key (MaNCC));

create table DonHang(SoDH varchar(5), NgayDH date constraint R7 check(NgayDH not like null), MaNCC varchar(5), TriGia decimal(10,2), HinhthucTT text constraint R1 check(HinhthucTT = N'1' or HinhthucTT = N'2'), primary key (SoDH), foreign key (MaNCC) references NhaCC(MaNCC));

create table CTDonHang(SoDH varchar(5), MaMH varchar(5), SLDat int, DonGia decimal(10,3), foreign key (SoDH) references DonHang(SoDH),foreign key (MaMH) references MatHang(MaMH), constraint R3 check(SLDat >= 0 and DonGia >=0));

create table PHIEUNHAP(SoPN varchar(5), NgayNH date constraint R8 check(NgayNH not like null), NguoiNhan varchar(5), SoDH varchar(5), primary key (SoPN),foreign key (SoDH) references DonHang(SoDH));

create table CTNhap(SoPN varchar(5), MaMH varchar(5), SLNhap int, foreign key (MaMH) references MatHang(MaMH), foreign key (SoPN) references PHIEUNHAP(SoPN));

create table PhieuXuat(SoPX varchar(5), NgayXuat date, NguoiXuat varchar(5), LydoXuat text, primary key (SoPX));

create table CTXuat(SoPX varchar(5), MaMH varchar(5), SLXuat int, DonGiaXuat int, foreign key (SoPX) references PhieuXuat(SoPX), foreign key (MaMH) references MatHang(MaMH), constraint R4 check(SLXuat >= 0 and DonGiaXuat >= 0))

create table ThanhToan(SoCT varchar(5), NgayCT date constraint R6 check(NgayCT not like null), DienGiai text, SoHD varchar(5), SoTien decimal(10,2) constraint R5 check(SoTien > 0), primary key (SoCT), foreign key (SoHD) references DonHang(SoDH));

/*
1. Trên table CTDonHang, tạo các trigger trong các trường hợp sau:
a. Mỗi khi chèn một bộ vào table CTDonHang, nếu thao tác thành công thì tự
động tăng giá trị của đơn hàng tương ứng một lượng bằng với giá trị của
mặt hàng vừa thêm (giá trị của mặt hàng vừa thêm = số lượng * đơn giá)
b. Mỗi khi xoá một bộ trong table CTDonHang, nếu thao tác thành công thì tự
động giảm giá trị của đơn hàng tương ứng một lượng bằng với giá giá trị
của mặt hàng vừa xoá (giá trị của mặt hàng vừa xoá = số lượng * đơn giá)
c. Mỗi khi sửa dữ liệu của một bộ trong table CTDonHang, nếu thao tác thành
công thì tự động cập nhật lại giá trị của đơn hàng có liên quan.
*/

--a
create trigger CTDonHang_ADD on CTDonHang for insert
as
if exists(select * from CTDonHang join inserted on CTDonHang.SoDH = inserted.SoDH and CTDonHang.MaMH = inserted.MaMH)
begin
declare @soDH varchar(5), @donGia decimal(10,3), @slDat int;
select @soDH = SoDH, @donGia = DonGia, @slDat = SLDat from inserted;
update DonHang
set TriGia = TriGia + (@donGia * @slDat)
where SoDH = @soDH;
end
else
begin
raiserror('Thêm chi tiết đơn hàng thất bại!', 10, 1)
rollback
end


go
--b
create trigger CTDonHang_DELETE on CTDonHang for delete
as
if exists(select * from CTDonHang join deleted on CTDonHang.SoDH = deleted.SoDH and CTDonHang.MaMH = deleted.MaMH)
begin
declare @soDH varchar(5), @donGia decimal(10,3), @slDat int;
select @soDH = SoDH, @donGia = DonGia, @slDat = SLDat from deleted;
update DonHang
set TriGia = TriGia - (@donGia * @slDat)
where SoDH = @soDH;
end
else
begin
raiserror('Xóa chi tiết đơn hàng thất bại!', 10, 1)
rollback
end


go
--c
create trigger CTDonHang_UPDATE on CTDonHang for update
as
declare @soDH varchar(5), @donGia decimal(10,3), @slDat int;
if exists(select * from CTDonHang join inserted on CTDonHang.SoDH = inserted.SoDH and CTDonHang.MaMH = inserted.MaMH)
begin
select @soDH = SoDH, @donGia = DonGia, @slDat = SLDat from deleted;
update DonHang
set TriGia = TriGia - (@donGia * @slDat)
where SoDH = @soDH;
end
else if exists(select * from CTDonHang join deleted on CTDonHang.SoDH = deleted.SoDH and CTDonHang.MaMH = deleted.MaMH)
begin
select @soDH = SoDH, @donGia = DonGia, @slDat = SLDat from deleted;
update DonHang
set TriGia = TriGia - (@donGia * @slDat)
where SoDH = @soDH;
end
else
begin
raiserror('Sửa chi tiết đơn hàng thất bại!', 10, 1)
rollback
end




/*
2. Trên table CTNhap, tạo các Trigger thực hiện yêu cầu sau sau:
a. Mỗi khi chèn một bộ vào table CTNhap, nếu thành công thì tự động tăng
thêm SLGiao của mặt hàng trong đơn hàng tương ứng với SLNhap đồng
thời tăng SLNhap, TGNhap tương ứng với lượng hàng đã nhận. Ngoài các
RBTV đã được cài đặt, thao tác là thành công nếu thoả thêm các điều kiện
sau đây:
i. Mặt hàng nhận phải có trong đơn hàng tương ứng
ii. Tổng số lượng hàng đã giao <= SL Đặt
iii. Số lượng mặt hàng trên một đơn hàng <=10
iv. Ngay giao >=Ngày đặt
b. Mỗi khi xoá một bộ từ table CTNhap, nếu thành công thì tự động giảm
SLGiao của mặt hàng trong đơn hàng tương ứng với SLNhap đã xoá đi
c. Mỗi khi sửa đổi một bộ trong CTNhap, nếu thành công thì cập nhật tự động
SLGiao của mặt hàng trong đơn hàng tương ứng. Thao tác được gọi là
thàng công nếu thoả các điều kiện như trong câu a.
*/

go
--a
create trigger CTNhap_ADD on CTNhap for insert
as
if exists(select * from CTNhap join inserted on CTNhap.SoPN = inserted.SoPN and CTNhap.MaMH = inserted.MaMH)
begin
declare @maMH varchar(5), @soPN varchar(5), @slNhap int, @soDH varchar(5), @slDat int, @slDaGiao int, @slMH int, @ngayNH date, @ngayDH date
declare c_inserted cursor for select * from inserted
open c_inserted
fetch next into @maMH, @soPN, @slNhap
while (@@FETCH_STATUS = 0)
begin
select @soDH = SoDH from inserted join PHIEUNHAP on inserted.SoPN = PHIEUNHAP.SoPN
select @slDaGiao = SLGiao, @slDat = SLDat from CTDonHang where SoDH = @soDH and MaMH = @maMH
select @slMH = sum(SLDat) from CTDonHang where SoDH = @soDH
select @ngayNH = NgayNH from PHIEUNHAP where SoPN = @soPN
select @ngayDH = NgayDH from DonHang where SoDH = @soDH	
if exists(select * from CTDonHang where SoDH = @soDH and MaMH = @maMH) and @slDaGiao <= @slDat and @slMH <= 10 and @ngayNH >= @ngayDH
begin
update CTDonHang
set SLGiao = SLGiao + @slNhap
where SoDH = @soDH and MaMH = @maMH
update MatHang
set SLNhap = SLNhap + @slNhap, TGNhap = GETDATE()
where MaMH = @maMH
end
else
begin
raiserror('Thêm chi tiết phiếu nhập thất bại!', 10,1)
rollback
end
fetch next into @maMH, @soPN, @slNhap
end
close c_inserted
deallocate c_inserted 
end
else
begin
raiserror('Thêm chi tiết phiếu nhập thất bại!', 10,1)
rollback
end

go
--b
create trigger CTNhap_DELETE on CTNhap for delete
as
if exists(select * from CTNhap join deleted on CTNhap.SoPN = deleted.SoPN and CTNhap.MaMH = deleted.MaMH)
begin
declare @soDH varchar(5), @soPN varchar(5), @maMH varchar(5), @slNhap int
declare c_deleted cursor for select * from deleted
open c_deleted
fetch next into @soPN, @maMH, @slNhap
while(@@FETCH_STATUS = 0)
begin
select @soDH = SoDH from PHIEUNHAP where SoPN = @soPN
update CTDonHang
set SLGiao = SLGiao - @slNhap
where SoDH = @soDH and MaMH = @maMH
fetch next into @soPN, @maMH, @slNhap
end
close c_deleted
deallocate c_deleted
end
else
begin
raiserror('Xóa chi tiết phiếu nhập thất bại!', 10,1)
rollback
end

go
--c
create trigger CTNhap_UPDATE on CTNHAP for update
as
if exists(select * from CTNhap join inserted on CTNhap.SoPN = inserted.SoPN and CTNhap.MaMH = inserted.MaMH)
begin
declare @maMH varchar(5), @soPN varchar(5), @slNhap int, @soDH varchar(5), @slDat int, @slDaGiao int, @slMH int, @ngayNH date, @ngayDH date
declare c_inserted cursor for select * from inserted
open c_inserted
fetch next into @maMH, @soPN, @slNhap
while (@@FETCH_STATUS = 0)
begin
select @soDH = SoDH from inserted join PHIEUNHAP on inserted.SoPN = PHIEUNHAP.SoPN
select @slDaGiao = SLGiao, @slDat = SLDat from CTDonHang where SoDH = @soDH and MaMH = @maMH
select @slMH = sum(SLDat) from CTDonHang where SoDH = @soDH
select @ngayNH = NgayNH from PHIEUNHAP where SoPN = @soPN
select @ngayDH = NgayDH from DonHang where SoDH = @soDH	
if exists(select * from CTDonHang where SoDH = @soDH and MaMH = @maMH) and @slDaGiao <= @slDat and @slMH <= 10 and @ngayNH >= @ngayDH
begin
update CTDonHang
set SLGiao = SLGiao + @slNhap
where SoDH = @soDH and MaMH = @maMH
update MatHang
set SLNhap = SLNhap + @slNhap, TGNhap = GETDATE()
where MaMH = @maMH
end
else
begin
raiserror('Sửa chi tiết phiếu nhập thất bại!', 10,1)
rollback
end
fetch next into @maMH, @soPN, @slNhap
end
close c_inserted
deallocate c_inserted 
end
else if exists(select * from CTNhap join deleted on CTNhap.SoPN = deleted.SoPN and CTNhap.MaMH = deleted.MaMH)
begin
declare c_deleted cursor for select * from deleted
open c_deleted
fetch next into @soPN, @maMH, @slNhap
while(@@FETCH_STATUS = 0)
begin
select @soDH = SoDH from PHIEUNHAP where SoPN = @soPN
update CTDonHang
set SLGiao = SLGiao - @slNhap
where SoDH = @soDH and MaMH = @maMH
fetch next into @soPN, @maMH, @slNhap
end
close c_deleted
deallocate c_deleted
end
else
begin
raiserror('Sửa chi tiết phiếu nhập thất bại!', 10,1)
rollback
end




/*
3. Tạo các thủ tục lưu trữ (Store procedure) để thêm các bộ vào các table.
 Lưu ý: - Sinh viên tự tạo cho mình một bộ dữ liệu để kiểm tra.
- Nếu việc gọi thủ tục thêm dữ liệu vào CSDL có xảy ra lỗi, hãy xem
xét các RBTV đã lập
*/
go
create procedure them_mat_hang
as
begin
insert into MatHang values
('MH01','san pham 1', 'cai', 100, 10-2-2007, 29, 20-5-2005, 20, 29-4-2008),
('MH02','san pham 2', 'cai', 230, 13-1-2006, 29, 10-2-2005, 20, 23-5-2008),
('MH03','san pham 3', 'cai', 50, 14-3-2006, 29, 24-3-2005, 20, 23-1-2008),
('MH04','san pham 4', 'cai', 70, 02-7-2007, 29, 30-7-2005, 20, 21-3-2008);
end

go
create procedure them_nhacc
as
begin
insert into NhaCC values
('NCC01', 'nha cung cap 1', '23/34', 10000),
('NCC02', 'nha cung cap 2', '23/34', 23400),
('NCC03', 'nha cung cap 3', '23/34', 1100),
('NCC04', 'nha cung cap 4', '23/34', 5000);
end

go
create procedure them_donhang
as
begin
insert into DonHang values
('DH001', 12-3-2005, 'NCC01', 200000, '1');
end

go
create procedure them_ctdonhang
as
begin
insert into CTDonHang values
('DH001', 'MH001', 200, 1000);
end

go
create procedure them_phieunhap
as
begin
insert into PHIEUNHAP values
('PN001', 31-1-2008, 'Nguyen Van A', 'DH001');
end

go
create procedure them_ctnhap
as
begin
insert into CTNhap values
('PN001', 'MH001', 200);
end

go
create procedure them_phieuxuat
as
begin
insert into PhieuXuat values
('PX001', 29-1-2008, 'Tran Van B', 'Giao hang');
end

go
create procedure them_ctxuat
as
begin
insert into CTXuat values
('PX001', 'MH001', 200, 1000);
end

go
create procedure them_thanhtoan
as
begin
insert into ThanhToan values
('CT001', 29-1-2008, '', 'DH001', 200000);
end

/* Câu 4: Tạo các thủ tục lưu trữ, mỗi thủ tục nhận vào tham số là giá trị các thuộc tính khóa
của một bộ quan hệ, tìm kiếm và xóa bộ tìm thấy trong quan hệ (lưu ý trường hợp
xóa lan truyền)
*/
GO
CREATE PROCEDURE XOABOMATHANG (@MaMH varchar(100)) AS
	DELETE MatHang, CTDonHang, CTNhap, CTXuat
	FROM MatHang mh INNER JOIN CTDonHang dh ON mh.MaMH = dh.MaMH INNER JOIN CTNhap nhap
		ON dh.MaMH = nhap.MaMH INNER JOIN CTXuat xuat ON nhap.MaMH = xuat.MaMH 
	WHERE mh.MaMH = @MaMH
GO
	EXECUTE XOABOMATHANG @MaMH='MH001';
GO

/* Câu 5: Tạo thủ tục lưu trữ cập nhật lại số lượng đặt của một mặt hàng trong một đơn
hàng. Thủ tục nhận vào tham số là mã số của một mặt hàng, số hiệu của một đơn
hàng và số lượng đặt. Tìm kiếm bộ tương ứng trong quan hệ CTDonHang, nếu tìm
thấy thì thay thế số lượng đặt bởi giá trị mới.
*/
GO
CREATE PROCEDURE CAPNHATSL (@MaMH varchar(100), @SLDatHang varchar(50)) AS
	UPDATE CTDonHang
	SET SLDat=@SLDatHang
	WHERE mh.MaMH = @MaMH
GO
	EXECUTE CAPNHATSL @MaMH='MH001', @SLDatHang='500';
GO	

/* Câu 6: Tạo thủ tục lưu trữ, nhận vào số hiệu của một đơn hàng, cho biết danh sách các
mặt hàng cùng với số lượng đặt trên đơn hàng đó.
*/
GO
CREATE PROCEDURE XUATDANHSACH (@SoHieu varchar(100)) AS
	SELECT mh.MaMH, mh.TenMH, mh.Dvt, mh.SLTonDau, mh.TGTonDau, mh.SLNhap, mh.TGNhap, mh.SLXuat, mh.TGXuat, dh.SLDat
	FROM DonHang d JOIN CTDonHang dh ON dh.SoDH = d.SoDH JOIN MatHang mh
		ON mh.MaMH = dh.MaMH
	WHERE d.SoDH = @SoHieu
GO
	EXECUTE XUATDANHSACH @SoHieu='DH001';
GO

/* Câu 7: Tạo thủ tục lưu trữ, nhận vào 2 ngày : Ngay1, Ngay2. Trả về kết quả là tổng số
lượng từng mặt hàng đã nhập trong thời gian giữa 2 ngày đó.
*/
GO
CREATE PROCEDURE TONGSONHAP (@Ngay1 Date, @Ngay2 Date) AS
	SELECT SUM(SLNhap) AS TONGSOMATHANGNHAP
	FROM CTNhap nhap JOIN PHIEUNHAP pn ON nhap.SoPN = pn.SoPN 
	WHERE NgayNH < @Ngay2 and NgayNH > Ngay1
	GROUP BY SLNhap
GO
	EXECUTE XUATDANHSACH @Ngay1='2019-01-02', @Ngay2='2019-01-05';
GO

--8. Tạo view xem chi tiết các đơn hàng. Kết quả gồm các thông tin: SoHieuDH,
--NgayDat, MaMatHang, TenMathang, Dvt, SoLuongDat, DonGia, TriGia. Kết quả
--sắp tăng dần theo NgayDat, SoHieuDH

CREATE VIEW CHI_TIET_DON_HANG AS
SELECT TOP 100 PERCENT  c.SoDH, d.NgayDH, m.MaMH, m.TenMH, m.Dvt, c.SLDat, c.DonGia, d.TriGia
FROM CTDonHang c JOIN DonHang d ON c.SoDH = d.SoDH 
	 JOIN MatHang m ON  c.MaMH = m.MaMH
ORDER BY d.NgayDH,  c.SoDH ASC

--9. Tạo view cho biết tổng số lượng và trị giá của từng mặt hàng đã nhập






--10. Tạo view cho biết tổng số lượng và trị giá của từng mặt hàng đã xuất