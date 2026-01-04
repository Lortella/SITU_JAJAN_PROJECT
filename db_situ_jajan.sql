-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 04, 2026 at 12:59 PM
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
-- Table structure for table `kantin`
--

CREATE TABLE `kantin` (
  `ID_Kantin` int NOT NULL,
  `Nama_Petugas` varchar(100) NOT NULL,
  `Kategori` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kantin`
--

INSERT INTO `kantin` (`ID_Kantin`, `Nama_Petugas`, `Kategori`) VALUES
(1, 'Pak Udin', 'Makanan'),
(2, 'Bu Sari', 'Minuman'),
(3, 'Pak Joko', 'Snack');

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `ID_Menu` int NOT NULL,
  `Nama_Menu` varchar(100) NOT NULL,
  `Harga` decimal(18,2) NOT NULL,
  `Stok` int NOT NULL,
  `Kategori` varchar(50) NOT NULL,
  `ID_Kantin` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`ID_Menu`, `Nama_Menu`, `Harga`, `Stok`, `Kategori`, `ID_Kantin`) VALUES
(1, 'Nasi Goreng', 15000.00, 20, 'Makanan', 1),
(2, 'Es Teh', 5000.00, 30, 'Minuman', 2),
(3, 'Roti', 7000.00, 25, 'Snack', 3);

-- --------------------------------------------------------

--
-- Table structure for table `orang_tua`
--

CREATE TABLE `orang_tua` (
  `ID_Ortu` int NOT NULL,
  `Nama` varchar(100) NOT NULL,
  `No_HP` varchar(20) NOT NULL,
  `Password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orang_tua`
--

INSERT INTO `orang_tua` (`ID_Ortu`, `Nama`, `No_HP`, `Password`) VALUES
(1, 'Budi Santoso', '0811111111', '12345'),
(2, 'Siti Aminah', '0822222222', '12345'),
(3, 'Andi Wijaya', '0833333333', '12345');

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `ID_Pembayaran` int NOT NULL,
  `Tanggal` datetime DEFAULT CURRENT_TIMESTAMP,
  `Status` varchar(20) NOT NULL,
  `Metode_Pembayaran` varchar(20) NOT NULL,
  `Total_Pembayaran` decimal(18,2) NOT NULL,
  `NIS` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`ID_Pembayaran`, `Tanggal`, `Status`, `Metode_Pembayaran`, `Total_Pembayaran`, `NIS`) VALUES
(1, '2026-01-04 12:20:04', 'Sukses', 'Saldo', 15000.00, 'S001'),
(2, '2026-01-04 12:20:04', 'Sukses', 'Saldo', 5000.00, 'S002'),
(3, '2026-01-04 12:20:04', 'Sukses', 'Saldo', 7000.00, 'S003');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `pesanan_id` bigint UNSIGNED NOT NULL,
  `ID_Pembayaran` int NOT NULL,
  `ID_Menu` int NOT NULL,
  `Jumlah` int NOT NULL,
  `Subtotal` decimal(18,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`pesanan_id`, `ID_Pembayaran`, `ID_Menu`, `Jumlah`, `Subtotal`) VALUES
(1, 1, 1, 1, 15000.00),
(2, 2, 2, 1, 5000.00),
(3, 3, 3, 1, 7000.00);

-- --------------------------------------------------------

--
-- Table structure for table `saldo`
--

CREATE TABLE `saldo` (
  `ID_Saldo` int NOT NULL,
  `ID_Ortu` int NOT NULL,
  `Saldo` decimal(18,2) NOT NULL DEFAULT '0.00',
  `Created_At` datetime DEFAULT CURRENT_TIMESTAMP,
  `Updated_At` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `saldo`
--

INSERT INTO `saldo` (`ID_Saldo`, `ID_Ortu`, `Saldo`, `Created_At`, `Updated_At`) VALUES
(1, 1, 50005.00, '2026-01-04 12:20:04', '2026-01-04 19:49:33'),
(2, 2, 75000.00, '2026-01-04 12:20:04', '2026-01-04 12:20:04'),
(3, 3, 86000.00, '2026-01-04 12:20:04', '2026-01-04 15:03:22');

-- --------------------------------------------------------

--
-- Table structure for table `siswa`
--

CREATE TABLE `siswa` (
  `NIS` varchar(20) NOT NULL,
  `Nama` varchar(100) NOT NULL,
  `Kelas` varchar(10) NOT NULL,
  `ID_Ortu` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `siswa`
--

INSERT INTO `siswa` (`NIS`, `Nama`, `Kelas`, `ID_Ortu`) VALUES
('S001', 'Rafi', '5A', 1),
('S002', 'Nina', '6B', 2),
('S003', 'Doni', '4C', 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kantin`
--
ALTER TABLE `kantin`
  ADD PRIMARY KEY (`ID_Kantin`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`ID_Menu`),
  ADD KEY `fk_menu_kantin` (`ID_Kantin`);

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
  ADD KEY `fk_pembayaran_siswa` (`NIS`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`pesanan_id`),
  ADD KEY `fk_pesanan_pembayaran` (`ID_Pembayaran`),
  ADD KEY `fk_pesanan_menu` (`ID_Menu`);

--
-- Indexes for table `saldo`
--
ALTER TABLE `saldo`
  ADD PRIMARY KEY (`ID_Saldo`),
  ADD UNIQUE KEY `ID_Ortu` (`ID_Ortu`);

--
-- Indexes for table `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`NIS`),
  ADD KEY `fk_siswa_ortu` (`ID_Ortu`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kantin`
--
ALTER TABLE `kantin`
  MODIFY `ID_Kantin` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `ID_Menu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `orang_tua`
--
ALTER TABLE `orang_tua`
  MODIFY `ID_Ortu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `ID_Pembayaran` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `pesanan_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `saldo`
--
ALTER TABLE `saldo`
  MODIFY `ID_Saldo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `fk_menu_kantin` FOREIGN KEY (`ID_Kantin`) REFERENCES `kantin` (`ID_Kantin`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `fk_pembayaran_siswa` FOREIGN KEY (`NIS`) REFERENCES `siswa` (`NIS`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `fk_pesanan_menu` FOREIGN KEY (`ID_Menu`) REFERENCES `menu` (`ID_Menu`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pesanan_pembayaran` FOREIGN KEY (`ID_Pembayaran`) REFERENCES `pembayaran` (`ID_Pembayaran`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `saldo`
--
ALTER TABLE `saldo`
  ADD CONSTRAINT `fk_saldo_ortu` FOREIGN KEY (`ID_Ortu`) REFERENCES `orang_tua` (`ID_Ortu`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `siswa`
--
ALTER TABLE `siswa`
  ADD CONSTRAINT `fk_siswa_ortu` FOREIGN KEY (`ID_Ortu`) REFERENCES `orang_tua` (`ID_Ortu`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
