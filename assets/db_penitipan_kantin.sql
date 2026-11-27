-- Aplikasi Penitipan Makanan Kantin
-- Import: mysql -u root < database/schema.sql
CREATE DATABASE IF NOT EXISTS db_penitipan_kantin CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE db_penitipan_kantin;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS detail_nota, nota_penjualan, pencairan, stok_harian, produk, pengguna, penitip, gedung;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE gedung (
    id_gedung          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nama_gedung        VARCHAR(100) NOT NULL,
    status_operasional ENUM('Aktif','Nonaktif') NOT NULL DEFAULT 'Aktif',
    PRIMARY KEY (id_gedung)
) ENGINE=InnoDB;

CREATE TABLE penitip (
    id_penitip    INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nama_penitip  VARCHAR(100) NOT NULL,
    no_telepon    VARCHAR(20)  NOT NULL,
    no_rekening   VARCHAR(30)  NULL,
    status_penitip ENUM('Aktif','Nonaktif') NOT NULL DEFAULT 'Aktif',
    PRIMARY KEY (id_penitip)
) ENGINE=InnoDB;

CREATE TABLE pengguna (
    id_pengguna   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_penitip    INT UNSIGNED NULL,
    nama_pengguna VARCHAR(100) NOT NULL,
    username      VARCHAR(30)  NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    peran         ENUM('Super Admin','Admin','Penjaga Kantin','Penitip/Supplier') NOT NULL,
    status_akun   ENUM('Aktif','Nonaktif') NOT NULL DEFAULT 'Aktif',
    PRIMARY KEY (id_pengguna),
    UNIQUE KEY uq_pengguna_username (username),
    CONSTRAINT fk_pengguna_penitip FOREIGN KEY (id_penitip) REFERENCES penitip (id_penitip)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE produk (
    id_produk          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_penitip         INT UNSIGNED NOT NULL,
    kategori           ENUM('Makanan Berat','Makanan Ringan','Minuman') NOT NULL,
    nama_produk        VARCHAR(100) NOT NULL,
    harga_jual         DECIMAL(12,2) NOT NULL,
    komisi_per_pcs     DECIMAL(12,2) NOT NULL DEFAULT 0,
    tanggal_kadaluarsa DATE NULL,
    PRIMARY KEY (id_produk),
    CONSTRAINT fk_produk_penitip FOREIGN KEY (id_penitip) REFERENCES penitip (id_penitip)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ck_produk_harga CHECK (harga_jual > 0 AND komisi_per_pcs >= 0 AND komisi_per_pcs <= harga_jual)
) ENGINE=InnoDB;

CREATE TABLE stok_harian (
    id_stok     INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_produk   INT UNSIGNED NOT NULL,
    id_gedung   INT UNSIGNED NOT NULL,
    tanggal     DATE NOT NULL,
    stok_awal   INT UNSIGNED NOT NULL DEFAULT 0,
    stok_masuk  INT UNSIGNED NOT NULL DEFAULT 0,
    stok_terjual INT UNSIGNED NOT NULL DEFAULT 0,
    stok_akhir  INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id_stok),
    UNIQUE KEY uq_stok_harian (id_produk, id_gedung, tanggal),
    CONSTRAINT fk_stok_produk FOREIGN KEY (id_produk) REFERENCES produk (id_produk)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_stok_gedung FOREIGN KEY (id_gedung) REFERENCES gedung (id_gedung)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE pencairan (
    id_pencairan        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_penitip          INT UNSIGNED NOT NULL,
    periode_awal        DATE NOT NULL,
    periode_akhir       DATE NOT NULL,
    total_penjualan     DECIMAL(14,2) NOT NULL DEFAULT 0,
    total_komisi        DECIMAL(14,2) NOT NULL DEFAULT 0,
    total_dicairkan     DECIMAL(14,2) NOT NULL DEFAULT 0,
    status_pencairan    ENUM('Belum Dicairkan','Sudah Dicairkan') NOT NULL DEFAULT 'Belum Dicairkan',
    tanggal_cair        DATETIME NULL,
    id_pengguna_pencair INT UNSIGNED NULL,
    dibuat_pada         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_pencairan),
    CONSTRAINT fk_pencairan_penitip FOREIGN KEY (id_penitip) REFERENCES penitip (id_penitip)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pencairan_pengguna FOREIGN KEY (id_pengguna_pencair) REFERENCES pengguna (id_pengguna)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE nota_penjualan (
    id_nota     INT UNSIGNED NOT NULL AUTO_INCREMENT,
    no_nota     VARCHAR(30) NOT NULL,
    id_gedung   INT UNSIGNED NOT NULL,
    id_pengguna INT UNSIGNED NOT NULL,
    tanggal     DATE NOT NULL,
    total       DECIMAL(14,2) NOT NULL DEFAULT 0,
    dibuat_pada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_nota),
    UNIQUE KEY uq_nota_no (no_nota),
    KEY idx_nota_tanggal (tanggal),
    CONSTRAINT fk_nota_gedung FOREIGN KEY (id_gedung) REFERENCES gedung (id_gedung)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_nota_pengguna FOREIGN KEY (id_pengguna) REFERENCES pengguna (id_pengguna)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE detail_nota (
    id_detail      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_nota        INT UNSIGNED NOT NULL,
    id_produk      INT UNSIGNED NOT NULL,
    id_pencairan   INT UNSIGNED NULL,
    jumlah         INT UNSIGNED NOT NULL,
    harga_satuan   DECIMAL(12,2) NOT NULL,
    komisi_satuan  DECIMAL(12,2) NOT NULL,
    subtotal       DECIMAL(14,2) NOT NULL,
    PRIMARY KEY (id_detail),
    CONSTRAINT fk_detail_nota FOREIGN KEY (id_nota) REFERENCES nota_penjualan (id_nota)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detail_produk FOREIGN KEY (id_produk) REFERENCES produk (id_produk)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_detail_pencairan FOREIGN KEY (id_pencairan) REFERENCES pencairan (id_pencairan)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ck_detail_jumlah CHECK (jumlah > 0)
) ENGINE=InnoDB;

-- ===== DATA AWAL (password semua akun: password123, segera ganti!) =====
INSERT INTO gedung (nama_gedung, status_operasional) VALUES
 ('Gedung F', 'Aktif'), ('Gedung G', 'Aktif'), ('Gedung B', 'Nonaktif'), ();

INSERT INTO penitip (nama_penitip, no_telepon, no_rekening, status_penitip) VALUES
 ('Bu Sari Catering', '081234567890', '1234567890', 'Aktif'),
 ('Pak Budi Snack',   '082345678901', '0987654321', 'Aktif'),
 ('Kedai Es Segar',   '083456789012', NULL,         'Aktif');

INSERT INTO pengguna (id_penitip, nama_pengguna, username, password_hash, peran, status_akun) VALUES
 (NULL, 'Super Administrator', 'superadmin', '$2y$10$AcTaSLfgHhd6lYFeKcKw9.6PbODkiJ1t2ZQtjcrY.hkTKTz/rq1jG', 'Super Admin', 'Aktif'),
 (NULL, 'Admin Kantin',        'admin',      '$2y$10$AcTaSLfgHhd6lYFeKcKw9.6PbODkiJ1t2ZQtjcrY.hkTKTz/rq1jG', 'Admin', 'Aktif'),
 (NULL, 'Penjaga Gedung A',    'penjaga',    '$2y$10$AcTaSLfgHhd6lYFeKcKw9.6PbODkiJ1t2ZQtjcrY.hkTKTz/rq1jG', 'Penjaga Kantin', 'Aktif'),
 (1,    'Bu Sari',             'supplier',   '$2y$10$AcTaSLfgHhd6lYFeKcKw9.6PbODkiJ1t2ZQtjcrY.hkTKTz/rq1jG', 'Penitip/Supplier', 'Aktif');

INSERT INTO produk (id_penitip, kategori, nama_produk, harga_jual, komisi_per_pcs, tanggal_kadaluarsa) VALUES
 (1, 'Makanan Berat',  'Nasi Ayam Geprek', 15000, 2000, NULL),
 (1, 'Makanan Berat',  'Nasi Kuning',      10000, 1500, NULL),
 (2, 'Makanan Ringan', 'Keripik Singkong',  5000,  800, DATE_ADD(CURDATE(), INTERVAL 60 DAY)),
 (2, 'Makanan Ringan', 'Roti Cokelat',      6000,  900, DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
 (3, 'Minuman',        'Es Teh Manis',      4000,  700, NULL);

INSERT INTO stok_harian (id_produk, id_gedung, tanggal, stok_awal, stok_masuk, stok_terjual, stok_akhir) VALUES
 (1, 1, CURDATE(), 0, 30, 0, 30),
 (2, 1, CURDATE(), 0, 20, 0, 20),
 (3, 1, CURDATE(), 0, 40, 0, 40),
 (4, 1, CURDATE(), 0, 10, 0, 10),
 (5, 1, CURDATE(), 0, 50, 0, 50),
 (1, 2, CURDATE(), 0, 15, 0, 15),
 (5, 2, CURDATE(), 0, 25, 0, 25);
