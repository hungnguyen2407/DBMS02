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
