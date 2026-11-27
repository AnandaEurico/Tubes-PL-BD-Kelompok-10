<?php
$barang = [
    ["nama" => "Indomie Goreng", "harga" => 3500, "stok" => 20, "pemilik" => "Kantin"],
    ["nama" => "Air Mineral", "harga" => 4000, "stok" => 15, "pemilik" => "Kantin"],
    ["nama" => "Puding Cokelat", "harga" => 5000, "stok" => 10, "pemilik" => "Rina"],
    ["nama" => "Keripik Pisang", "harga" => 8000, "stok" => 3, "pemilik" => "Budi"],
    ["nama" => "Es Teh", "harga" => 3000, "stok" => 2, "pemilik" => "Kantin"],
    ["nama" => "Roti Cokelat", "harga" => 6000, "stok" => 12, "pemilik" => "Dina"]
];

$totalBarang = count($barang);
$barangTitipan = 0;
$pemilik = [];
$stokMenipis = 0;

foreach ($barang as $item) {
    if ($item["pemilik"] != "Kantin") {
        $barangTitipan++;
        $pemilik[] = $item["pemilik"];
    }

    if ($item["stok"] <= 5) {
        $stokMenipis++;
    }
}

$totalPemilik = count(array_unique($pemilik));
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard KantinKu</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="sidebar">
    <div class="brand">
        <h2>KantinKu</h2>
        <p>Manajemen Kantin</p>
    </div>

    <p class="menu-title">MENU UTAMA</p>

    <a href="#" class="menu active"> Dashboard</a>
    <a href="#" class="menu"> Data Barang</a>
    <a href="#" class="menu"> Data Pemilik</a>

    <div class="admin">
        <div class="avatar">A</div>
        <div>
            <strong>Administrator</strong>
            <p>Admin Kantin</p>
        </div>
    </div>
</div>

<div class="main">
    <header>
        <span>Halaman / Dashboard</span>
        <span>Administrator</span>
    </header>

    <div class="content">
        <div class="heading">
            <div>
                <p class="subtitle">RINGKASAN KANTIN</p>
                <h1>Dashboard</h1>
                <p>Selamat datang! Berikut informasi barang kantin saat ini.</p>
            </div>

            <button class="btn-add" disabled>+ Tambah Barang</button>
        </div>

        <div class="stats">
            <div class="card">
                <span>Total Barang</span>
                <h2><?= $totalBarang ?></h2>
                <p>Keseluruhan barang</p>
            </div>

            <div class="card">
                <span>Barang Titipan</span>
                <h2><?= $barangTitipan ?></h2>
                <p>Barang milik penitip</p>
            </div>

            <div class="card">
                <span>Pemilik Barang</span>
                <h2><?= $totalPemilik ?></h2>
                <p>Pemilik barang titipan</p>
            </div>

            <div class="card">
                <span>Stok Menipis</span>
                <h2><?= $stokMenipis ?></h2>
                <p>Barang stok 5 atau kurang</p>
            </div>
        </div>

        <div class="table-container">
            <div class="table-heading">
                <div>
                    <h3>Daftar Barang Kantin</h3>
                    <p>Daftar barang yang tersedia di kantin.</p>
                </div>

                <input type="text" id="search" placeholder="Cari barang...">
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>Nama Barang</th>
                            <th>Harga</th>
                            <th>Stok</th>
                            <th>Pemilik</th>
                            <th>Status</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>

                    <tbody id="barangTable">
                        <?php $no = 1; ?>
                        <?php foreach ($barang as $item): ?>
                        <tr>
                            <td><?= $no++ ?></td>
                            <td><?= htmlspecialchars($item["nama"]) ?></td>
                            <td>Rp <?= number_format($item["harga"], 0, ",", ".") ?></td>
                            <td><?= $item["stok"] ?></td>
                            <td><?= htmlspecialchars($item["pemilik"]) ?></td>
                            <td>
                                <?php if ($item["stok"] <= 5): ?>
                                    <span class="status warning">Stok Menipis</span>
                                <?php else: ?>
                                    <span class="status success">Tersedia</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <button class="btn-edit" disabled>Edit</button>
                                <button class="btn-delete" disabled>Hapus</button>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>

            <div class="footer-table">
                Menampilkan <?= $totalBarang ?> barang
            </div>
        </div>
    </div>
</div>

<script>
const search = document.getElementById("search");
const rows = document.querySelectorAll("#barangTable tr");

search.addEventListener("keyup", function() {
    let keyword = search.value.toLowerCase();

    rows.forEach(function(row) {
        let nama = row.cells[1].textContent.toLowerCase();

        if (nama.includes(keyword)) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
});
</script>
</body>
</html>
