SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS tagihan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS riwayat_transaksi;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS saldo;
DROP TABLE IF EXISTS siswa;
DROP TABLE IF EXISTS orang_tua;
DROP TABLE IF EXISTS kantin;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE orang_tua (
    ID_Ortu INT AUTO_INCREMENT PRIMARY KEY,
    Nama VARCHAR(100),
    No_HP VARCHAR(20),
    Password VARCHAR(100)
);

CREATE TABLE siswa (
    NIS VARCHAR(20) PRIMARY KEY,
    Nama VARCHAR(100),
    Kelas VARCHAR(20),
    ID_Ortu INT,
    FOREIGN KEY (ID_Ortu) REFERENCES orang_tua(ID_Ortu)
);

CREATE TABLE saldo (
    ID_Saldo INT AUTO_INCREMENT PRIMARY KEY,
    Saldo DECIMAL(12,2),
    Created_At DATETIME,
    Updated_At DATETIME,
    ID_Ortu INT,
    FOREIGN KEY (ID_Ortu) REFERENCES orang_tua(ID_Ortu)
);

CREATE TABLE kantin (
    ID_Kantin INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) UNIQUE,
    Nama_Petugas VARCHAR(100),
    Kategori VARCHAR(50),
    Password VARCHAR(255)
);

CREATE TABLE menu (
    ID_Menu INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Menu VARCHAR(100),
    Harga DECIMAL(10,2),
    Stok INT,
    Kategori VARCHAR(50),
    ID_Kantin INT,
    FOREIGN KEY (ID_Kantin) REFERENCES kantin(ID_Kantin)
);

CREATE TABLE pesanan (
    ID_Pesanan INT AUTO_INCREMENT PRIMARY KEY,
    Total_Pesanan DECIMAL(12,2),
    Tanggal_Pesanan DATETIME,
    NIS VARCHAR(20),
    Status VARCHAR(20),
    FOREIGN KEY (NIS) REFERENCES siswa(NIS)
);

CREATE TABLE detail_pesanan (
    ID_Detail INT AUTO_INCREMENT PRIMARY KEY,
    Jumlah INT,
    Harga_Satuan DECIMAL(10,2),
    Subtotal DECIMAL(12,2),
    ID_Menu INT,
    ID_Pesanan INT,
    FOREIGN KEY (ID_Menu) REFERENCES menu(ID_Menu),
    FOREIGN KEY (ID_Pesanan) REFERENCES pesanan(ID_Pesanan)
);

CREATE TABLE tagihan (
    ID_Tagihan INT AUTO_INCREMENT PRIMARY KEY,
    Tanggal_Tagihan DATETIME,
    Total_Tagihan DECIMAL(12,2),
    Status_Pembayaran VARCHAR(30),
    ID_Pesanan INT,
    FOREIGN KEY (ID_Pesanan) REFERENCES pesanan(ID_Pesanan)
);

CREATE TABLE pembayaran (
    ID_Pembayaran INT AUTO_INCREMENT PRIMARY KEY,
    Tanggal_Pembayaran DATETIME,
    Metode_Pembayaran VARCHAR(50),
    Total_Pembayaran DECIMAL(12,2),
    Status VARCHAR(30),
    ID_Tagihan INT,
    ID_Ortu INT,
    FOREIGN KEY (ID_Tagihan) REFERENCES tagihan(ID_Tagihan),
    FOREIGN KEY (ID_Ortu) REFERENCES orang_tua(ID_Ortu)
);

CREATE TABLE riwayat_transaksi (
    ID_Riwayat INT AUTO_INCREMENT PRIMARY KEY,
    Jenis_Transaksi VARCHAR(30),
    Tanggal DATETIME,
    Keterangan VARCHAR(255),
    Nominal DECIMAL(12,2),
    ID_Ortu INT,
    FOREIGN KEY (ID_Ortu) REFERENCES orang_tua(ID_Ortu)
);

INSERT INTO orang_tua (Nama, No_HP, Password) VALUES
('Budi Rahmanto Pratama','0811111111','123'),
('Andi Wijaya Saputra','0822222222','123'),
('Citra Ayu Lestari','0833333333','123'),
('Dewi Kartika Sari','0844444444','123'),
('Eka Putra Nugroho','0855555555','123');

INSERT INTO siswa (NIS, Nama, Kelas, ID_Ortu) VALUES
('S001','Alya Putri Rahmanto','5A',1),
('S002','Bagas Andika Wijaya','5B',2),
('S003','Celine Amara Lestari','6A',3),
('S004','Dimas Arya Kartika','6B',4),
('S005','Elena Kirana Nugroho','4A',5);

INSERT INTO saldo (Saldo, Created_At, Updated_At, ID_Ortu) VALUES
(50000,NOW(),NOW(),1),
(40000,NOW(),NOW(),2),
(60000,NOW(),NOW(),3),
(30000,NOW(),NOW(),4),
(70000,NOW(),NOW(),5);

INSERT INTO kantin (Username, Nama_Petugas, Kategori, Password) VALUES
('rina_kantin','Rina Maharani Putri','Makanan','123'),
('sari_minum','Sari Puspita Dewi','Minuman','123'),
('tono_snack','Tono Prasetyo Utama','Snack','123'),
('wati_food','Wati Kusuma Ningrum','Makanan','123'),
('agus_minum','Agus Setiawan Santoso','Minuman','123');

INSERT INTO menu (Nama_Menu, Harga, Stok, Kategori, ID_Kantin) VALUES
('Nasi Goreng Spesial',15000,20,'Makanan',1),
('Mie Goreng Jawa',12000,25,'Makanan',1),
('Es Teh Manis',5000,40,'Minuman',2),
('Es Jeruk Segar',6000,35,'Minuman',2),
('Roti Bakar Coklat Keju',8000,30,'Snack',3),
('Cilok Bumbu Kacang',7000,50,'Snack',3),
('Ayam Geprek Sambal Merah',18000,15,'Makanan',4),
('Sosis Goreng Crispy',6000,45,'Snack',5);

INSERT INTO pesanan (Total_Pesanan, Tanggal_Pesanan, NIS, Status) VALUES
(20000,NOW(),'S001','DIPESAN'),
(17000,NOW(),'S002','DITERIMA'),
(23000,NOW(),'S003','DITERIMA'),
(15000,NOW(),'S004','DIPESAN'),
(26000,NOW(),'S005','DITERIMA');

INSERT INTO detail_pesanan (Jumlah, Harga_Satuan, Subtotal, ID_Menu, ID_Pesanan) VALUES
(1,15000,15000,1,1),
(1,5000,5000,3,1),
(1,12000,12000,2,2),
(1,5000,5000,3,2),
(1,18000,18000,7,3),
(1,5000,5000,3,3),
(2,7000,14000,6,4),
(1,1000,1000,3,4),
(2,8000,16000,5,5),
(1,10000,10000,7,5);

INSERT INTO tagihan (Tanggal_Tagihan, Total_Tagihan, Status_Pembayaran, ID_Pesanan) VALUES
(NOW(),20000,'MENUNGGU',1),
(NOW(),17000,'LUNAS',2),
(NOW(),23000,'LUNAS',3),
(NOW(),15000,'MENUNGGU',4),
(NOW(),26000,'LUNAS',5);

INSERT INTO pembayaran (Tanggal_Pembayaran, Metode_Pembayaran, Total_Pembayaran, Status, ID_Tagihan, ID_Ortu) VALUES
(NOW(),'VA',17000,'BERHASIL',2,2),
(NOW(),'E-WALLET',23000,'BERHASIL',3,3),
(NOW(),'VA',26000,'BERHASIL',5,5);

INSERT INTO riwayat_transaksi (Jenis_Transaksi, Tanggal, Keterangan, Nominal, ID_Ortu) VALUES
('TOP UP',NOW(),'Top Up Saldo',50000,1),
('TOP UP',NOW(),'Top Up Saldo',40000,2),
('PEMBELIAN',NOW(),'Pesanan Kantin',17000,2),
('PEMBELIAN',NOW(),'Pesanan Kantin',23000,3),
('TOP UP',NOW(),'Top Up Saldo',70000,5);
