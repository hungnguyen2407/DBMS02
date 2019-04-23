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