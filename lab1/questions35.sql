/* câu 35: Cho biết học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở
lần thi sau cùng). */
SELECT hv.MAHV, hv.HO, hv.TEN, kq.MAMH, kq.DIEM
FROM HOCVIEN hv, KETQUATHI kq inner join
	(SELECT kq.MAHV, kq.MAMH, MAX(kq.DIEM) AS DIEMCAONHAT, COUNT(kq.LT) AS TONGSOLANTHI
	FROM KETQUATHI kq 
	GROUP BY kq.MAHV, kq.MAMH) AS KQCN
ON KQCN.DIEMCAONHAT = kq.DIEM and KQCN.MAMH = kq.MAMH and KQCN.MAHV = kq.MAHV and KQCN.TONGSOLANTHI = kq.LT
WHERE hv.MAHV = kq.MAHV
