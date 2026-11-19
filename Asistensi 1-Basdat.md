# Aplikasi Penitip Kantin — Log Feedback Asistensi 1


## 1. Catatan Feedback Asistensi 1

1. **Fokus pada Relasi Pelacakan Barang Terjual:**
   Menunjukkan bagaimana relasi basis data melacak produk yang terjual beserta identitas penitip pemiliknya sebelum masuk ke tahap pembuatan UI *dashboard*.
2. **Tanpa Penambahan Tabel Redundan:**
   Pemisahan data per penitip tidak dilakukan dengan menambah tabel baru per penitip/rekap, melainkan melalui konfigurasi relasi (`Foreign Key`) antara tabel transaksi dan master produk/penitip.
3. **Registrasi Kepemilikan Produk (`1:N`):**
   Setiap produk didaftarkan dengan `id_produk` dan terikat ke `id_penitip` sebelum dicatat pada pemantauan stok harian per gedung (`STOK_HARIAN`).
4. **Konsep Filtering Dashboard Penitip:**
   Seluruh transaksi disimpan terpusat di `DETAIL_NOTA`, lalu disaring menggunakan filter `WHERE id_penitip = '...'` sehingga setiap penitip hanya melihat data barang terjual dan stok miliknya sendiri.

---

## 2. Tindak Lanjut Perbaikan Rancangan

* **Menghapus `DETAIL_REKAP_GEDUNG`:** Rancangan diringkas dari 9 tabel menjadi **8 tabel inti** (`GEDUNG`, `PENITIP`, `KATEGORI_PRODUK`, `PRODUK`, `STOK_HARIAN`, `NOTA_PENJUALAN`, `DETAIL_NOTA`, `PENCAIRAN`) karena rekap per gedung sudah terlacak via `DETAIL_NOTA -> STOK_HARIAN -> GEDUNG`.
* **Alur Relasi Utama:**
  `PENITIP (1) -> (N) PRODUK (1) -> (N) STOK_HARIAN (1) -> (N) DETAIL_NOTA`