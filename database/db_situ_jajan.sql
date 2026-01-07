-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 07, 2026 at 01:13 PM
-- Server version: 8.4.3
-- PHP Version: 8.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_situ_jajan`
--

-- --------------------------------------------------------

--
-- Table structure for table `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `ID_Detail` int NOT NULL,
  `Jumlah` int DEFAULT NULL,
  `Harga_Satuan` decimal(10,2) DEFAULT NULL,
  `Subtotal` decimal(12,2) DEFAULT NULL,
  `ID_Menu` int DEFAULT NULL,
  `ID_Pesanan` int DEFAULT NULL,
  `Status_Detail` enum('MENUNGGU','DIPROSES','SELESAI') DEFAULT 'MENUNGGU'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `detail_pesanan`
--

INSERT INTO `detail_pesanan` (`ID_Detail`, `Jumlah`, `Harga_Satuan`, `Subtotal`, `ID_Menu`, `ID_Pesanan`, `Status_Detail`) VALUES
(26, 1, 6000.00, 6000.00, 8, 17, 'MENUNGGU'),
(27, 1, 5000.00, 5000.00, 3, 17, 'SELESAI'),
(28, 1, 15000.00, 15000.00, 1, 17, 'SELESAI'),
(29, 1, 15000.00, 15000.00, 1, 18, 'SELESAI'),
(30, 1, 12000.00, 12000.00, 2, 18, 'SELESAI'),
(31, 1, 5000.00, 5000.00, 3, 18, 'SELESAI'),
(32, 1, 6000.00, 6000.00, 4, 18, 'SELESAI'),
(33, 1, 8000.00, 8000.00, 5, 18, 'MENUNGGU'),
(34, 1, 7000.00, 7000.00, 6, 18, 'MENUNGGU');

-- --------------------------------------------------------

--
-- Table structure for table `kantin`
--

CREATE TABLE `kantin` (
  `ID_Kantin` int NOT NULL,
  `Username` varchar(50) DEFAULT NULL,
  `Nama_Petugas` varchar(100) DEFAULT NULL,
  `Kategori` varchar(50) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kantin`
--

INSERT INTO `kantin` (`ID_Kantin`, `Username`, `Nama_Petugas`, `Kategori`, `Password`) VALUES
(1, 'rina_kantin', 'Rina Maharani Putri', 'Makanan', '123'),
(2, 'sari_minum', 'Sari Puspita Dewi', 'Minuman', '123'),
(3, 'tono_snack', 'Tono Prasetyo Utama', 'Snack', '123'),
(4, 'wati_food', 'Wati Kusuma Ningrum', 'Makanan', '123'),
(5, 'agus_minum', 'Agus Setiawan Santoso', 'Minuman', '123');

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `ID_Menu` int NOT NULL,
  `Nama_Menu` varchar(100) DEFAULT NULL,
  `Harga` decimal(10,2) DEFAULT NULL,
  `Stok` int DEFAULT NULL,
  `Kategori` varchar(50) DEFAULT NULL,
  `ID_Kantin` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`ID_Menu`, `Nama_Menu`, `Harga`, `Stok`, `Kategori`, `ID_Kantin`) VALUES
(1, 'Nasi Goreng Spesial', 15000.00, 9, 'Makanan', 1),
(2, 'Mie Goreng Jawa', 12000.00, 24, 'Makanan', 1),
(3, 'Es Teh Manis', 5000.00, 35, 'Minuman', 2),
(4, 'Es Jeruk Segar', 6000.00, 32, 'Minuman', 2),
(5, 'Roti Bakar Coklat Keju', 8000.00, 27, 'Snack', 3),
(6, 'Cilok Bumbu Kacang', 7000.00, 47, 'Snack', 3),
(7, 'Ayam Geprek Sambal Merah', 18000.00, 15, 'Makanan', 4),
(8, 'Sosis Goreng Crispy', 6000.00, 43, 'Snack', 5);

-- --------------------------------------------------------

--
-- Table structure for table `orang_tua`
--

CREATE TABLE `orang_tua` (
  `ID_Ortu` int NOT NULL,
  `Nama` varchar(100) DEFAULT NULL,
  `No_HP` varchar(20) DEFAULT NULL,
  `Password` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orang_tua`
--

INSERT INTO `orang_tua` (`ID_Ortu`, `Nama`, `No_HP`, `Password`) VALUES
(1, 'Budi Rahmanto Pratama', '0811111111', '123'),
(2, 'Andi Wijaya Saputra', '0822222222', '123'),
(3, 'Citra Ayu Lestari', '0833333333', '123'),
(4, 'Dewi Kartika Sari', '0844444444', '123'),
(5, 'Eka Putra Nugroho', '0855555555', '123');

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `ID_Pembayaran` int NOT NULL,
  `Tanggal_Pembayaran` datetime DEFAULT NULL,
  `Metode_Pembayaran` varchar(50) DEFAULT NULL,
  `Total_Pembayaran` decimal(12,2) DEFAULT NULL,
  `Status` varchar(30) DEFAULT NULL,
  `ID_Tagihan` int DEFAULT NULL,
  `ID_Ortu` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`ID_Pembayaran`, `Tanggal_Pembayaran`, `Metode_Pembayaran`, `Total_Pembayaran`, `Status`, `ID_Tagihan`, `ID_Ortu`) VALUES
(13, '2026-01-07 19:28:56', 'Saldo Aplikasi', 26000.00, 'BERHASIL', 15, 3),
(14, '2026-01-07 19:42:11', 'Saldo Aplikasi', 53000.00, 'BERHASIL', 16, 1);

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `ID_Pesanan` int NOT NULL,
  `Total_Pesanan` decimal(12,2) DEFAULT NULL,
  `Tanggal_Pesanan` datetime DEFAULT NULL,
  `NIS` varchar(20) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`ID_Pesanan`, `Total_Pesanan`, `Tanggal_Pesanan`, `NIS`, `Status`) VALUES
(17, 26000.00, '2026-01-07 19:28:56', 'S003', 'MENUNGGU'),
(18, 53000.00, '2026-01-07 19:42:11', 'S001', 'MENUNGGU');

-- --------------------------------------------------------

--
-- Table structure for table `riwayat_transaksi`
--

CREATE TABLE `riwayat_transaksi` (
  `ID_Riwayat` int NOT NULL,
  `Jenis_Transaksi` varchar(30) DEFAULT NULL,
  `Tanggal` datetime DEFAULT NULL,
  `Keterangan` varchar(255) DEFAULT NULL,
  `Nominal` decimal(12,2) DEFAULT NULL,
  `ID_Ortu` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `riwayat_transaksi`
--

INSERT INTO `riwayat_transaksi` (`ID_Riwayat`, `Jenis_Transaksi`, `Tanggal`, `Keterangan`, `Nominal`, `ID_Ortu`) VALUES
(23, 'PEMBAYARAN', '2026-01-07 19:28:56', 'Jajan #17 (Saldo Aplikasi)', 26000.00, 3),
(24, 'PEMBAYARAN', '2026-01-07 19:42:11', 'Jajan #18 (Saldo Aplikasi)', 53000.00, 1);

-- --------------------------------------------------------

--
-- Table structure for table `saldo`
--

CREATE TABLE `saldo` (
  `ID_Saldo` int NOT NULL,
  `Saldo` decimal(12,2) DEFAULT NULL,
  `Created_At` datetime DEFAULT NULL,
  `Updated_At` datetime DEFAULT NULL,
  `ID_Ortu` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `saldo`
--

INSERT INTO `saldo` (`ID_Saldo`, `Saldo`, `Created_At`, `Updated_At`, `ID_Ortu`) VALUES
(1, 74010.00, '2026-01-07 14:33:59', '2026-01-07 18:40:06', 1),
(2, 40000.00, '2026-01-07 14:33:59', '2026-01-07 14:33:59', 2),
(3, 34000.00, '2026-01-07 14:33:59', '2026-01-07 14:33:59', 3),
(4, 30000.00, '2026-01-07 14:33:59', '2026-01-07 14:33:59', 4),
(5, 70000.00, '2026-01-07 14:33:59', '2026-01-07 14:33:59', 5);

-- --------------------------------------------------------

--
-- Table structure for table `siswa`
--

CREATE TABLE `siswa` (
  `NIS` varchar(20) NOT NULL,
  `Nama` varchar(100) DEFAULT NULL,
  `Kelas` varchar(20) DEFAULT NULL,
  `ID_Ortu` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `siswa`
--

INSERT INTO `siswa` (`NIS`, `Nama`, `Kelas`, `ID_Ortu`) VALUES
('S001', 'Alya Putri Rahmanto', '5A', 1),
('S002', 'Bagas Andika Wijaya', '5B', 2),
('S003', 'Celine Amara Lestari', '6A', 3),
('S004', 'Dimas Arya Kartika', '6B', 4),
('S005', 'Elena Kirana Nugroho', '4A', 5);

-- --------------------------------------------------------

--
-- Table structure for table `tagihan`
--

CREATE TABLE `tagihan` (
  `ID_Tagihan` int NOT NULL,
  `Tanggal_Tagihan` datetime DEFAULT NULL,
  `Total_Tagihan` decimal(12,2) DEFAULT NULL,
  `Status_Pembayaran` varchar(30) DEFAULT NULL,
  `ID_Pesanan` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `tagihan`
--

INSERT INTO `tagihan` (`ID_Tagihan`, `Tanggal_Tagihan`, `Total_Tagihan`, `Status_Pembayaran`, `ID_Pesanan`) VALUES
(15, '2026-01-07 19:28:56', 26000.00, 'LUNAS', 17),
(16, '2026-01-07 19:42:11', 53000.00, 'LUNAS', 18);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`ID_Detail`),
  ADD KEY `ID_Menu` (`ID_Menu`),
  ADD KEY `ID_Pesanan` (`ID_Pesanan`);

--
-- Indexes for table `kantin`
--
ALTER TABLE `kantin`
  ADD PRIMARY KEY (`ID_Kantin`),
  ADD UNIQUE KEY `Username` (`Username`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`ID_Menu`),
  ADD KEY `ID_Kantin` (`ID_Kantin`);

--
-- Indexes for table `orang_tua`
--
ALTER TABLE `orang_tua`
  ADD PRIMARY KEY (`ID_Ortu`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`ID_Pembayaran`),
  ADD KEY `ID_Tagihan` (`ID_Tagihan`),
  ADD KEY `ID_Ortu` (`ID_Ortu`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`ID_Pesanan`),
  ADD KEY `NIS` (`NIS`);

--
-- Indexes for table `riwayat_transaksi`
--
ALTER TABLE `riwayat_transaksi`
  ADD PRIMARY KEY (`ID_Riwayat`),
  ADD KEY `ID_Ortu` (`ID_Ortu`);

--
-- Indexes for table `saldo`
--
ALTER TABLE `saldo`
  ADD PRIMARY KEY (`ID_Saldo`),
  ADD KEY `ID_Ortu` (`ID_Ortu`);

--
-- Indexes for table `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`NIS`),
  ADD KEY `ID_Ortu` (`ID_Ortu`);

--
-- Indexes for table `tagihan`
--
ALTER TABLE `tagihan`
  ADD PRIMARY KEY (`ID_Tagihan`),
  ADD KEY `ID_Pesanan` (`ID_Pesanan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  MODIFY `ID_Detail` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `kantin`
--
ALTER TABLE `kantin`
  MODIFY `ID_Kantin` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `ID_Menu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `orang_tua`
--
ALTER TABLE `orang_tua`
  MODIFY `ID_Ortu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `ID_Pembayaran` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `ID_Pesanan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `riwayat_transaksi`
--
ALTER TABLE `riwayat_transaksi`
  MODIFY `ID_Riwayat` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `saldo`
--
ALTER TABLE `saldo`
  MODIFY `ID_Saldo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tagihan`
--
ALTER TABLE `tagihan`
  MODIFY `ID_Tagihan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `detail_pesanan_ibfk_1` FOREIGN KEY (`ID_Menu`) REFERENCES `menu` (`ID_Menu`),
  ADD CONSTRAINT `detail_pesanan_ibfk_2` FOREIGN KEY (`ID_Pesanan`) REFERENCES `pesanan` (`ID_Pesanan`);

--
-- Constraints for table `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`ID_Kantin`) REFERENCES `kantin` (`ID_Kantin`);

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`ID_Tagihan`) REFERENCES `tagihan` (`ID_Tagihan`),
  ADD CONSTRAINT `pembayaran_ibfk_2` FOREIGN KEY (`ID_Ortu`) REFERENCES `orang_tua` (`ID_Ortu`);

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`NIS`) REFERENCES `siswa` (`NIS`);

--
-- Constraints for table `riwayat_transaksi`
--
ALTER TABLE `riwayat_transaksi`
  ADD CONSTRAINT `riwayat_transaksi_ibfk_1` FOREIGN KEY (`ID_Ortu`) REFERENCES `orang_tua` (`ID_Ortu`);

--
-- Constraints for table `saldo`
--
ALTER TABLE `saldo`
  ADD CONSTRAINT `saldo_ibfk_1` FOREIGN KEY (`ID_Ortu`) REFERENCES `orang_tua` (`ID_Ortu`);

--
-- Constraints for table `siswa`
--
ALTER TABLE `siswa`
  ADD CONSTRAINT `siswa_ibfk_1` FOREIGN KEY (`ID_Ortu`) REFERENCES `orang_tua` (`ID_Ortu`);

--
-- Constraints for table `tagihan`
--
ALTER TABLE `tagihan`
  ADD CONSTRAINT `tagihan_ibfk_1` FOREIGN KEY (`ID_Pesanan`) REFERENCES `pesanan` (`ID_Pesanan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
