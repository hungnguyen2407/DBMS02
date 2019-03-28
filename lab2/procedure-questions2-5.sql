------------------------------------
/* Procedures */

/* Câu 2: Tạo thủ tục P_GVMH, cho biết danh sách sinh viên học môn (p_mamh) do giáo viên
(p_mgv) phụ trách trong học kỳ (p_hocky), năm học (p_nam).
 Thông tin gồm: Mã GV, mã môn học, mahv, ho&ten hoc vien
 Thủ tục nhận các tham số đầu vào là mã môn học (p_mamh), mã giáo viên
(p_mgv), học kỳ (p_hocky), năm học (p_nam).
*/
GO
CREATE PROCEDURE P_GVMH (@MaMH varchar(100), @MaGV varchar(100), @HocKi varchar(100), @NamHoc varchar(100)) AS
	SELECT gd.MAGV, gd.MAMH, hv.MAHV, hv.HO, hv.TEN 
	FROM HOCVIEN hv INNER JOIN GIANGDAY gd ON gd.MAMH = @MaMH and gd.HOCKY = @HocKi and gd.NAM = @NamHoc
		and gd.MALOP = hv.MALOP INNER JOIN GIAOVIEN gv ON gv.MAGV = @MaGV and gv.MAGV = gd.MAGV;
GO
	EXECUTE P_GVMH @MaMH='CSDL',@MaGV='GV09',@HocKi='2',@NamHoc='2006';
GO

/* Câu 3: Tạo thủ tục P_LOP cho biết danh sách học viên của lớp (p_malop).
 Thông tin gồm: mã lớp, mgvcn, tên gv chủ nhiệm, tên trưởng lớp, mahv, ho&ten
học viên.
 Thủ tục nhận 1 tham số đầu vào là mã lớp (p_malop).
*/
GO
CREATE PROCEDURE P_LOP (@MaLop varchar(100)) AS
	SELECT l.MALOP, l.MAGVCN, l.TRGLOP, hv.MAHV, hv.HO, hv.TEN 
	FROM LOP l INNER JOIN HOCVIEN hv ON l.MALOP = @MaLop and hv.MALOP = l.MALOP;
GO
	EXECUTE P_LOP @MaLop='K11';
GO

/* Câu 4: Tạo thủ tục P_TOPN liệt kê danh sách n môn học có số lượng học đăng ký học nhiều
nhất.
 Thông tin gồm: Mã môn học, tên môn học, số lượng học viên
 Thủ tục nhận 1 tham số đầu vào là n.
*/
GO
CREATE PROCEDURE P_TOPN (@SoMonHoc int) AS
	SELECT TOP (@SoMonHoc) mh.MAMH, mh.TENMH, COUNT(hv.MAHV) AS SLHOCVIEN
	FROM MONHOC mh INNER JOIN GIANGDAY gd ON gd.MAMH = mh.MAMH 
		INNER JOIN HOCVIEN hv ON hv.MALOP = gd.MALOP GROUP BY mh.MAMH, mh.TENMH ORDER BY SLHOCVIEN DESC;
GO
	EXECUTE P_TOPN @SoMonHoc='5';
GO

/* Câu 5: Tạo thủ tục P_TK, thống kê số lượng học viên của từng môn học mà giáo viên (p_magv)
đã phụ trách giảng dạy.
 Thông tin gồm: MAGV, tên gv, mamh, tenmh, số lượng học viên
 Thủ tục nhận 1 tham số đầu vào là mã giáo viên (p_magv).
*/
CREATE PROCEDURE P_TK (@MaGV varchar(100)) AS
	SELECT gv.MAGV, gv.HOTEN, mh.MAMH, mh.TENMH, COUNT(hv.MAHV) AS SLHOCVIEN 
	FROM GIAOVIEN gv INNER JOIN GIANGDAY gd ON gv.MAGV = gd.MAGV and gv.MAGV = @MaGV
		INNER JOIN MONHOC mh ON mh.MAMH = gd.MAMH INNER JOIN HOCVIEN hv ON gd.MALOP = hv.MALOP 
			GROUP BY gv.MAGV, gv.HOTEN, mh.MAMH, mh.TENMH;
GO 
	EXECUTE P_TK @MaGV='GV07';
GO
/* End Procedures */
------------------------------------