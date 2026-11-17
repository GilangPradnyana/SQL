-- UTS Basis Data Lanjut - Kelas A
-- Jalankan 01_setup_tabel_data.sql dulu. Lalu klik satu query dan tekan F9.
-- (MK01 = A01, MK02 = A02, MK03 = A03 sesuai data di tabel)

USE db_uts;

-- 1. Barang yang terjual secara kredit
SELECT b.id_barang, b.nama_barang, SUBSTR(t.detail_trx, 5, 6) AS jenis_pembayaran
FROM transaksi t
JOIN barang b ON LEFT(t.detail_trx, 3) = b.id_barang
WHERE t.detail_trx LIKE '%Credit%';


-- 2. Transaksi beserta nama kasir
SELECT t.*, k.nama_kasir
FROM transaksi t
JOIN kasir k ON t.id_kasir = k.id_kasir;


-- 3. Transaksi dengan nama barang dan kasir
SELECT t.*, b.nama_barang, k.nama_kasir
FROM transaksi t
JOIN barang b ON LEFT(t.detail_trx, 3) = b.id_barang
JOIN kasir k ON t.id_kasir = k.id_kasir;


-- 4. Nilai tertinggi di MK02
SELECT m.namaMhs, a.nilai
FROM tb_mhs m
JOIN tb_ambilmk a ON m.nim = a.nim
WHERE a.kodeMK = 'A02'
AND a.nilai = (SELECT MAX(nilai) FROM tb_ambilmk WHERE kodeMK = 'A02');


-- 5. Nilai di atas rata-rata di MK03
SELECT m.nim, m.namaMhs
FROM tb_mhs m
JOIN tb_ambilmk a ON m.nim = a.nim
WHERE a.kodeMK = 'A03'
AND a.nilai > (SELECT AVG(nilai) FROM tb_ambilmk WHERE kodeMK = 'A03');


-- 6. Mahasiswa yang tidak mengambil MK01
SELECT namaMhs
FROM tb_mhs
WHERE nim NOT IN (SELECT nim FROM tb_ambilmk WHERE kodeMK = 'A01');


-- 7. Nilai terendah mahasiswa bernama RAHMA
SELECT MIN(a.nilai) AS nilai_terendah
FROM tb_mhs m
JOIN tb_ambilmk a ON m.nim = a.nim
WHERE m.namaMhs = 'RAHMA';


-- 8. Mahasiswa yang mengambil MK01
SELECT m.namaMhs
FROM tb_mhs m
JOIN tb_ambilmk a ON m.nim = a.nim
WHERE a.kodeMK = 'A01';


-- 9. Nilai di bawah rata-rata di MK01
SELECT m.nim, m.namaMhs
FROM tb_mhs m
JOIN tb_ambilmk a ON m.nim = a.nim
WHERE a.kodeMK = 'A01'
AND a.nilai < (SELECT AVG(nilai) FROM tb_ambilmk WHERE kodeMK = 'A01');


-- 10. Mahasiswa yang punya nilai 4
SELECT DISTINCT m.namaMhs
FROM tb_mhs m
JOIN tb_ambilmk a ON m.nim = a.nim
WHERE a.nilai = 4;


-- 11. Nilai terendah di MK03
SELECT m.namaMhs, a.nilai
FROM tb_mhs m
JOIN tb_ambilmk a ON m.nim = a.nim
WHERE a.kodeMK = 'A03'
AND a.nilai = (SELECT MIN(nilai) FROM tb_ambilmk WHERE kodeMK = 'A03');


-- 12. Mahasiswa yang mengambil Kalkulus
SELECT m.namaMhs
FROM tb_mhs m
JOIN tb_ambilmk a ON m.nim = a.nim
JOIN tb_mk k ON a.kodeMK = k.kodeMK
WHERE k.namaMK = 'Kalkulus';
