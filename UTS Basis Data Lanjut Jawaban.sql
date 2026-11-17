-- =====================================================================
-- UTS Basis Data Lanjut - Kelas A (Ganjil 2026)
-- Dijalankan di SQLyog (MySQL / MariaDB)
-- Cara pakai: SQLyog > File > New Query Editor > paste > blok per query > F9
--             (atau Ctrl+F9 untuk menjalankan seluruh script)
-- =====================================================================

DROP DATABASE IF EXISTS db_uts;
CREATE DATABASE db_uts;
USE db_uts;

-- =====================================================================
-- BAGIAN 1 : TABEL BARANG, KASIR, TRANSAKSI (skor 40)
-- =====================================================================
CREATE TABLE barang (
  id_barang   VARCHAR(5)   PRIMARY KEY,
  nama_barang VARCHAR(50),
  harga       INT
);
CREATE TABLE kasir (
  id_kasir   VARCHAR(5)  PRIMARY KEY,
  nama_kasir VARCHAR(30)
);
CREATE TABLE transaksi (            -- di soal tertulis "tansaksi"
  id_trx     VARCHAR(5) PRIMARY KEY,
  tgl_trx    DATE,
  detail_trx VARCHAR(30),           -- format: id_barang-jenis_pembayaran[-tenor]
  id_kasir   VARCHAR(5)
);

INSERT INTO barang VALUES
('B01','TV LG 21" Flatroom',3200000),
('B02','Mini Compo Sony',750000),
('B03','TV Samsung 14" Tube',320000),
('B04','Kulkas 2 pintu LG',4550000),
('B05','Mesin Cuci LG 10 kg',3110000);

INSERT INTO kasir VALUES
('K01','Syafudin'),
('K02','Rossi'),
('K03','Anggun');

INSERT INTO transaksi VALUES
('TR01','2015-11-02','B04-Lunas','K02'),
('TR02','2015-11-06','B02-Credit-12','K02'),
('TR03','2015-11-06','B01-Credit-6','K03'),
('TR04','2015-11-08','B05-Lunas','K01'),
('TR05','2015-11-09','B03-Lunas','K02');

-- ---------------------------------------------------------------------
-- Soal 1. Barang yang terjual secara kredit (id_barang, nama_barang, jenis_pembayaran)
-- id_barang        = bagian pertama detail_trx (sebelum '-' pertama)
-- jenis_pembayaran = bagian kedua detail_trx
-- ---------------------------------------------------------------------
SELECT b.id_barang,
       b.nama_barang,
       SUBSTRING_INDEX(SUBSTRING_INDEX(t.detail_trx,'-',2),'-',-1) AS jenis_pembayaran
FROM transaksi t
JOIN barang b ON b.id_barang = SUBSTRING_INDEX(t.detail_trx,'-',1)
WHERE t.detail_trx LIKE '%Credit%';

-- ---------------------------------------------------------------------
-- Soal 2. Transaksi beserta nama kasir yang melayani
-- ---------------------------------------------------------------------
SELECT t.id_trx, t.tgl_trx, t.detail_trx, t.id_kasir, k.nama_kasir
FROM transaksi t
JOIN kasir k ON k.id_kasir = t.id_kasir;

-- ---------------------------------------------------------------------
-- Soal 3. Transaksi dengan nama barang dan kasir yang melayani
-- ---------------------------------------------------------------------
SELECT t.id_trx, t.tgl_trx, t.detail_trx,
       b.nama_barang, k.nama_kasir
FROM transaksi t
JOIN barang b ON b.id_barang = SUBSTRING_INDEX(t.detail_trx,'-',1)
JOIN kasir  k ON k.id_kasir  = t.id_kasir;

-- =====================================================================
-- BAGIAN 2 : TABEL TB_MHS, TB_MK, TB_AMBILMK (skor 60)
-- Catatan: kode MK pada data tabel adalah A01, A02, A03.
--          'MK01' = A01 (Kalkulus), 'MK02' = A02 (Geometri), 'MK03' = A03 (Aljabar)
-- =====================================================================
CREATE TABLE tb_mhs (
  nim     VARCHAR(5) PRIMARY KEY,
  namaMhs VARCHAR(30)
);
CREATE TABLE tb_mk (
  kodeMK VARCHAR(5) PRIMARY KEY,
  namaMK VARCHAR(30),
  sks    INT
);
CREATE TABLE tb_ambilmk (
  nim    VARCHAR(5),
  kodeMK VARCHAR(5),
  nilai  INT
);

INSERT INTO tb_mhs VALUES ('001','Joko'),('002','Amir'),('003','Budi');
INSERT INTO tb_mk  VALUES ('A01','Kalkulus',3),('A02','Geometri',2),('A03','Aljabar',3);
INSERT INTO tb_ambilmk VALUES
('001','A01',3),('001','A02',4),('001','A03',2),
('002','A02',3),('002','A03',2),
('003','A01',4),('003','A03',3);

-- ---------------------------------------------------------------------
-- Soal 4. Nama mahasiswa & nilai yang NILAI TERTINGGI di MK02 (A02)
-- ---------------------------------------------------------------------
SELECT m.namaMhs, a.nilai
FROM tb_ambilmk a
JOIN tb_mhs m ON m.nim = a.nim
WHERE a.kodeMK = 'A02'
  AND a.nilai = (SELECT MAX(nilai) FROM tb_ambilmk WHERE kodeMK = 'A02');

-- ---------------------------------------------------------------------
-- Soal 5. MK03 (A03): mahasiswa (nim, nama) dengan nilai DI ATAS rata-rata
-- ---------------------------------------------------------------------
SELECT m.nim, m.namaMhs
FROM tb_ambilmk a
JOIN tb_mhs m ON m.nim = a.nim
WHERE a.kodeMK = 'A03'
  AND a.nilai > (SELECT AVG(nilai) FROM tb_ambilmk WHERE kodeMK = 'A03');

-- ---------------------------------------------------------------------
-- Soal 6. Mahasiswa terdaftar yang TIDAK mengambil MK01 (A01)
-- ---------------------------------------------------------------------
SELECT m.namaMhs
FROM tb_mhs m
WHERE m.nim NOT IN (SELECT nim FROM tb_ambilmk WHERE kodeMK = 'A01');

-- ---------------------------------------------------------------------
-- Soal 7. Nilai terendah dari mahasiswa bernama RAHMA
-- (pada data contoh tidak ada RAHMA, hasil = NULL, query tetap benar)
-- ---------------------------------------------------------------------
SELECT MIN(a.nilai) AS nilai_terendah
FROM tb_ambilmk a
JOIN tb_mhs m ON m.nim = a.nim
WHERE m.namaMhs = 'RAHMA';

-- ---------------------------------------------------------------------
-- Soal 8. Nama mahasiswa yang mengambil MK01 (A01)
-- ---------------------------------------------------------------------
SELECT m.namaMhs
FROM tb_mhs m
JOIN tb_ambilmk a ON a.nim = m.nim
WHERE a.kodeMK = 'A01';

-- ---------------------------------------------------------------------
-- Soal 9. MK01 (A01): nim & nama dengan nilai DI BAWAH rata-rata
-- ---------------------------------------------------------------------
SELECT m.nim, m.namaMhs
FROM tb_ambilmk a
JOIN tb_mhs m ON m.nim = a.nim
WHERE a.kodeMK = 'A01'
  AND a.nilai < (SELECT AVG(nilai) FROM tb_ambilmk WHERE kodeMK = 'A01');

-- ---------------------------------------------------------------------
-- Soal 10. Nama mahasiswa yang mempunyai nilai = 4
-- ---------------------------------------------------------------------
SELECT DISTINCT m.namaMhs
FROM tb_mhs m
JOIN tb_ambilmk a ON a.nim = m.nim
WHERE a.nilai = 4;

-- ---------------------------------------------------------------------
-- Soal 11. Nama mahasiswa & nilai yang NILAI TERENDAH di MK03 (A03)
-- ---------------------------------------------------------------------
SELECT m.namaMhs, a.nilai
FROM tb_ambilmk a
JOIN tb_mhs m ON m.nim = a.nim
WHERE a.kodeMK = 'A03'
  AND a.nilai = (SELECT MIN(nilai) FROM tb_ambilmk WHERE kodeMK = 'A03');

-- ---------------------------------------------------------------------
-- Soal 12. Nama mahasiswa yang mengambil mata kuliah KALKULUS
-- ---------------------------------------------------------------------
SELECT m.namaMhs
FROM tb_mhs m
JOIN tb_ambilmk a ON a.nim = m.nim
JOIN tb_mk k      ON k.kodeMK = a.kodeMK
WHERE k.namaMK = 'Kalkulus';
