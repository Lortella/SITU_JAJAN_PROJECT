/* =========================================================
   DROP TABLE
   ========================================================= */
DROP TABLE IF EXISTS riwayat_transaksi;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS tagihan;
DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS kantin;
DROP TABLE IF EXISTS saldo;
DROP TABLE IF EXISTS siswa;
DROP TABLE IF EXISTS orang_tua;


/* =========================================================
   CREATE TABLE
   ========================================================= */

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
    ID_Ortu INT UNIQUE,
    FOREIGN KEY (ID_Ortu) REFERENCES orang_tua(ID_Ortu)
);

CREATE TABLE kantin (
    ID_Kantin INT AUTO_INCREMENT PRIMARY KEY,
    Nama_Petugas VARCHAR(100),
    Kategori VARCHAR(50)
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


/* =========================================================
   INSERT DATA
   ========================================================= */

INSERT INTO orang_tua (Nama, No_HP, Password) VALUES
('Budi Santoso', '0811111111', '123'),
('Ani Wulandari', '0822222222', '123'),
('Rizky Pratama', '0833333333', '123'),
('Siti Aminah', '0844444444', '123'),
('Dedi Kurniawan', '0855555555', '123');

INSERT INTO siswa VALUES
('S001', 'Andi', '5A', 1),
('S002', 'Bela', '5B', 2),
('S003', 'Cahya', '6A', 3),
('S004', 'Dina', '6B', 4),
('S005', 'Eko', '4A', 5);

INSERT INTO saldo (Saldo, Created_At, Updated_At, ID_Ortu) VALUES
(50000, NOW(), NOW(), 1),
(75000, NOW(), NOW(), 2),
(60000, NOW(), NOW(), 3),
(90000, NOW(), NOW(), 4),
(40000, NOW(), NOW(), 5);

INSERT INTO kantin (Nama_Petugas, Kategori) VALUES
('Kantin Bu Rina', 'Makanan'),
('Kantin Pak Agus', 'Minuman');

INSERT INTO menu (Nama_Menu, Harga, Stok, Kategori, ID_Kantin) VALUES
('Nasi Goreng', 15000, 50, 'Makanan', 1),
('Mie Ayam', 12000, 40, 'Makanan', 1),
('Es Teh', 3000, 100, 'Minuman', 2),
('Jus Jeruk', 7000, 60, 'Minuman', 2);

INSERT INTO pesanan (Total_Pesanan, Tanggal_Pesanan, NIS) VALUES
(18000, NOW(), 'S001'),
(15000, NOW(), 'S002'),
(22000, NOW(), 'S001'),
(7000,  NOW(), 'S004');

INSERT INTO detail_pesanan (Jumlah, Harga_Satuan, Subtotal, ID_Menu, ID_Pesanan) VALUES
(1, 15000, 15000, 1, 1),
(1, 3000, 3000, 3, 1),
(1, 12000, 12000, 2, 2),
(1, 3000, 3000, 3, 2),
(1, 15000, 15000, 1, 3),
(1, 7000, 7000, 4, 4);

INSERT INTO tagihan (Tanggal_Tagihan, Total_Tagihan, Status_Pembayaran, ID_Pesanan) VALUES
(NOW(), 18000, 'LUNAS', 1),
(NOW(), 15000, 'LUNAS', 2),
(NOW(), 22000, 'LUNAS', 3),
(NOW(), 7000,  'LUNAS', 4);

INSERT INTO pembayaran (Tanggal_Pembayaran, Metode_Pembayaran, Total_Pembayaran, Status, ID_Tagihan, ID_Ortu) VALUES
(NOW(), 'Saldo', 18000, 'BERHASIL', 1, 1),
(NOW(), 'Saldo', 15000, 'BERHASIL', 2, 2),
(NOW(), 'Saldo', 22000, 'BERHASIL', 3, 1),
(NOW(), 'Saldo', 7000,  'BERHASIL', 4, 4);

INSERT INTO riwayat_transaksi (Jenis_Transaksi, Tanggal, Keterangan, Nominal, ID_Ortu) VALUES
('PEMBAYARAN', NOW(), 'Pembelian jajan Andi', 18000, 1),
('PEMBAYARAN', NOW(), 'Pembelian tambahan Andi', 22000, 1),
('PEMBAYARAN', NOW(), 'Pembelian jajan Bela', 15000, 2),
('PEMBAYARAN', NOW(), 'Pembelian jajan Dina', 7000, 4);
