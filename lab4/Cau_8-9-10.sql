use QLBH;

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