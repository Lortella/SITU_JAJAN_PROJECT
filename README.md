## 🌟 Tentang Program

🎒 **SITU JAJAN (Sistem Titip Uang Jajan)** adalah sebuah sistem informasi berbasis konsol yang dirancang untuk memodernisasi pengelolaan uang jajan siswa di lingkungan sekolah. Aplikasi ini menciptakan ekosistem digital yang menghubungkan **Orang Tua** dan **Admin Kantin**, menjadikan transaksi lebih **aman, terkontrol, dan transparan**.

💡 Dengan mengubah sistem pembayaran dari tunai menjadi saldo digital, SITU JAJAN meminimalkan risiko kehilangan uang dan memberikan kemudahan bagi orang tua untuk memantau pengeluaran anak. Orang tua dapat mengelola saldo dan memesan makanan dari mana saja, sementara admin kantin dapat mengelola pesanan secara efisien.

---

## 🛠️ Teknologi dan Tools yang Digunakan

- 🐍 **Python**: Bahasa pemrograman utama untuk logika aplikasi.
- 🗄️ **MySQL**: Sistem basis data untuk menyimpan seluruh data terkait pengguna, transaksi, dan menu.
- 🚀 **Laragon & phpMyAdmin**: Lingkungan server lokal dan tool untuk pengelolaan basis data.
- 🖊️ **Draw.io / Lucidchart**: Tools untuk perancangan ERD dan alur sistem.

---

## ⚙️ Alur Kerja Sistem

Sistem ini memiliki dua peran utama dengan fungsi yang berbeda:

1.  **Orang Tua**: Mengelola keuangan dan pesanan jajan anak.
2.  **Admin Kantin**: Mengelola pesanan yang masuk dari orang tua.

Pengguna akan login menggunakan kredensial yang unik, dan sistem akan secara otomatis mengarahkan mereka ke menu yang sesuai dengan perannya.

### Fitur Menu Orang Tua

- 👨‍👩‍👧 **Login Khusus**: Orang tua login menggunakan NIS (Nomor Induk Siswa) anak dan password pribadi.
- 💰 **Cek Saldo**: Melihat sisa saldo digital yang dimiliki.
- 💳 **Top Up Saldo**: Menambah saldo melalui dua metode simulasi:
    - **Virtual Account**: Transfer ke nomor VA unik.
    - **E-Wallet**: Transfer via OVO, DANA, atau GoPay.
    - Transaksi top up memiliki **batas waktu 5 menit** untuk konfirmasi.
- 🛒 **SITU JAJAN (Pesan Makanan)**:
    - Melihat daftar menu yang tersedia di kantin.
    - Menambah beberapa item ke dalam keranjang belanja.
    - Menghapus item dari keranjang.
    - Melakukan checkout dan pembayaran menggunakan saldo.
    - Mencetak **struk digital** setelah pembelian berhasil.
- 📊 **Riwayat Transaksi**: Melihat histori top up dan status pesanan makanan anak (apakah sudah diterima atau belum).

### Fitur Menu Admin Kantin

- 🧑‍🍳 **Login Admin**: Petugas kantin login menggunakan username dan password khusus.
- 📋 **Lihat Pesanan Masuk**: Menampilkan daftar semua pesanan yang berstatus 'DIPESAN', lengkap dengan detail nama anak, nama orang tua, total harga, dan rincian item.
- ✅ **Konfirmasi Pesanan**: Mengubah status pesanan menjadi 'DITERIMA' setelah makanan diserahkan kepada siswa.

---

## 👨‍💻 Tim Pengembang

Project **SITU JAJAN** disusun dan dikembangkan oleh mahasiswa Fakultas Teknik dan Teknologi, Tanri Abeng University:

- 👤 **Krisna Wibowo** – 06024010
- 👤 **Daffa Kuswardana** – 06024015
- 👤 **Peris Trisna Wati Nazara** – 06024011
- 👤 **Putri Wandayani** – 06024006

---

## 🏫 Institusi

🎓 **Fakultas Teknik dan Teknologi**  
🏛️ **Tanri Abeng University**  
📅 **Tahun 2025**
