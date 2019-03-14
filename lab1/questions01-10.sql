/* câu 1: In ra danh sách(Mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp */
SELECT hv.MAHV, hv.HO, hv.TEN, hv.NGSINH, hv.MALOP 
FROM HOCVIEN hv inner join LOP l 
ON hv.MAHV = l.TRGLOP;
/* câu 2: In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”,
sắp xếp theo tên, họ học viên. */
SELECT hv.MAHV, hv.HO, hv.TEN, kq.LT, kq.DIEM 
FROM HOCVIEN hv inner join KETQUATHI kq 
	ON kq.MAHV = hv.MAHV and kq.MAMH='CTRR' and hv.MALOP='K12';
/* câu 3: In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó
thi lần thứ nhất đã đạt. */
SELECT hv.MAHV, hv.HO, hv.TEN, mh.*
FROM HOCVIEN hv, MONHOC mh inner join KETQUATHI kq 
ON kq.LT='1' and kq.MAMH = mh.MAMH
WHERE kq.MAHV = hv.MAHV;
/* câu 4: In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở
lần thi 1). */
SELECT hv.MAHV, hv.HO, hv.TEN
FROM LOP l, HOCVIEN hv inner join KETQUATHI kq 
ON kq.MAMH='CTRR' and kq.LT>1 and kq.MAHV = hv.MAHV 
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
ON hv.MAHV = TSLT.MAHV and TSLT.TONGSOLANTHI = kq.LT
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