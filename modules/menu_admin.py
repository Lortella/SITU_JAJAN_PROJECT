from database.db import get_connection
from utils import clear, press_enter, format_rupiah
import time

def show_dashboard(user_data):
    id_kantin = user_data['id_kantin']
    nama_petugas = user_data['nama']
    
    while True:
        clear()
        print(f"=== DASHBOARD ADMIN KANTIN ({nama_petugas}) ===")
        print("1. 🔥 Dapur (Pesanan Masuk)")
        print("2. 📦 Pengambilan (Siap Diserahkan)")
        print("3. 🍔 Manajemen Menu")
        print("4. 📊 Laporan Pendapatan Hari Ini")
        print("0. Logout")
        
        pilih = input("\nPilih Menu: ")

        if pilih == "1":
            page_dapur(id_kantin)
        elif pilih == "2":
            page_pengambilan(id_kantin)
        elif pilih == "3":
            page_manajemen_menu(id_kantin)
        elif pilih == "4":
            page_laporan(id_kantin)
        elif pilih == "0":
            break

# --- FITUR DAPUR ---
def page_dapur(id_kantin):
    conn = get_connection()
    cursor = conn.cursor()
    
    while True:
        clear()
        print("=== 🔥 DAPUR: PESANAN MASUK (MENUNGGU) ===")
        
        cursor.execute("""
            SELECT p.ID_Pesanan, s.Nama, dp.Jumlah, m.Nama_Menu, s.Kelas
            FROM detail_pesanan dp
            JOIN pesanan p ON dp.ID_Pesanan = p.ID_Pesanan
            JOIN menu m ON dp.ID_Menu = m.ID_Menu
            JOIN siswa s ON p.NIS = s.NIS
            WHERE m.ID_Kantin = %s AND dp.Status_Detail = 'MENUNGGU'
            ORDER BY p.Tanggal_Pesanan ASC
        """, (id_kantin,))
        data = cursor.fetchall()

        if not data:
            print("\n[ Tidak ada pesanan baru ]")
            conn.close()
            press_enter()
            break

        # Grouping Data per ID Pesanan
        grouped = {}
        for row in data:
            pid = row[0]
            if pid not in grouped:
                grouped[pid] = {"siswa": f"{row[1]} ({row[4]})", "items": []}
            grouped[pid]["items"].append(f"{row[2]}x {row[3]}")

        # Tampilkan
        print(f"{'ID':<5} | {'SISWA':<25} | {'MENU YANG HARUS DIMASAK'}")
        print("-" * 70)
        for pid, val in grouped.items():
            menu_str = ", ".join(val["items"])
            print(f"#{pid:<4} | {val['siswa']:<25} | {menu_str}")

        aksi = input("\n[Ketik ID Pesanan untuk MEMASAK / '0' kembali]: ")
        if aksi == "0": 
            conn.close()
            break
        
        if aksi.isdigit() and int(aksi) in grouped:
            update_status_batch(id_kantin, int(aksi), "DIPROSES")
            print(f"\n✅ Pesanan #{aksi} sedang disiapkan!")
            time.sleep(1.5)
        else:
            print("ID Tidak valid!")
            time.sleep(1)

# --- FITUR PENGAMBILAN ---
def page_pengambilan(id_kantin):
    conn = get_connection()
    cursor = conn.cursor()

    while True:
        clear()
        print("=== 📦 PENGAMBILAN (SIAP DISERAHKAN) ===")
        
        cursor.execute("""
            SELECT p.ID_Pesanan, s.Nama, dp.Jumlah, m.Nama_Menu
            FROM detail_pesanan dp
            JOIN pesanan p ON dp.ID_Pesanan = p.ID_Pesanan
            JOIN menu m ON dp.ID_Menu = m.ID_Menu
            JOIN siswa s ON p.NIS = s.NIS
            WHERE m.ID_Kantin = %s AND dp.Status_Detail = 'DIPROSES'
            ORDER BY p.Tanggal_Pesanan ASC
        """, (id_kantin,))
        data = cursor.fetchall()

        if not data:
            print("\n[ Tidak ada pesanan siap ambil ]")
            conn.close()
            press_enter()
            break

        grouped = {}
        for row in data:
            pid = row[0]
            if pid not in grouped:
                grouped[pid] = {"siswa": row[1], "items": []}
            grouped[pid]["items"].append(f"{row[2]}x {row[3]}")

        print(f"{'ID':<5} | {'SISWA':<20} | {'MENU SIAP SERAH'}")
        print("-" * 60)
        for pid, val in grouped.items():
            menu_str = ", ".join(val["items"])
            print(f"#{pid:<4} | {val['siswa']:<20} | {menu_str}")

        aksi = input("\n[Ketik ID Pesanan untuk SERAHKAN / '0' kembali]: ")
        if aksi == "0": 
            conn.close()
            break

        if aksi.isdigit() and int(aksi) in grouped:
            update_status_batch(id_kantin, int(aksi), "SELESAI")
            cek_global_status(int(aksi)) # Cek apakah order utama selesai
            print(f"\n✅ Pesanan #{aksi} berhasil diserahkan.")
            time.sleep(1.5)
        else:
            print("ID Tidak valid!")
            time.sleep(1)

# --- FITUR MANAJEMEN MENU ---
def page_manajemen_menu(id_kantin):
    conn = get_connection()
    cursor = conn.cursor()

    while True:
        clear()
        print("=== 🍔 MANAJEMEN MENU ===")
        cursor.execute("SELECT ID_Menu, Nama_Menu, Harga, Stok FROM menu WHERE ID_Kantin=%s", (id_kantin,))
        menus = cursor.fetchall()

        print(f"{'ID':<4} | {'NAMA MENU':<25} | {'HARGA':<12} | {'STOK'}")
        print("-" * 60)
        for m in menus:
            print(f"{m[0]:<4} | {m[1]:<25} | {format_rupiah(m[2]):<12} | {m[3]}")
        
        print("\n1. Tambah Menu Baru")
        print("2. Update Stok/Harga")
        print("3. Hapus Menu")
        print("0. Kembali")
        
        sub = input("Pilih: ")
        
        if sub == "0": 
            conn.close()
            break
        
        elif sub == "1":
            nama = input("Nama Menu : ")
            harga = input("Harga     : ")
            stok = input("Stok Awal : ")
            kat = input("Kategori  : ")
            cursor.execute("INSERT INTO menu (Nama_Menu, Harga, Stok, Kategori, ID_Kantin) VALUES (%s, %s, %s, %s, %s)", 
                           (nama, harga, stok, kat, id_kantin))
            conn.commit()
            print("✅ Menu tersimpan!")
            time.sleep(1)

        elif sub == "2":
            id_m = input("ID Menu yang diedit: ")
            stok_baru = input("Stok Baru: ")
            cursor.execute("UPDATE menu SET Stok = %s WHERE ID_Menu = %s AND ID_Kantin = %s", (stok_baru, id_m, id_kantin))
            conn.commit()
            print("✅ Stok terupdate!")
            time.sleep(1)

        elif sub == "3":
            id_m = input("ID Menu hapus: ")
            cursor.execute("DELETE FROM menu WHERE ID_Menu = %s AND ID_Kantin = %s", (id_m, id_kantin))
            conn.commit()
            print("✅ Menu dihapus!")
            time.sleep(1)

# --- FITUR LAPORAN ---
def page_laporan(id_kantin):
    conn = get_connection()
    cursor = conn.cursor()
    clear()
    print("=== 📊 LAPORAN PENDAPATAN HARI INI ===")
    
    # Hitung Total
    cursor.execute("""
        SELECT SUM(dp.Subtotal) 
        FROM detail_pesanan dp
        JOIN pesanan p ON dp.ID_Pesanan = p.ID_Pesanan
        JOIN menu m ON dp.ID_Menu = m.ID_Menu
        WHERE m.ID_Kantin = %s AND dp.Status_Detail = 'SELESAI'
        AND DATE(p.Tanggal_Pesanan) = CURDATE()
    """, (id_kantin,))
    
    total = cursor.fetchone()[0]
    print(f"\n💰 TOTAL PENDAPATAN: {format_rupiah(total)}\n")
    
    print("RINCIAN PENJUALAN:")
    print("-" * 60)
    cursor.execute("""
        SELECT p.Tanggal_Pesanan, s.Nama, m.Nama_Menu, dp.Jumlah, dp.Subtotal
        FROM detail_pesanan dp
        JOIN pesanan p ON dp.ID_Pesanan = p.ID_Pesanan
        JOIN menu m ON dp.ID_Menu = m.ID_Menu
        JOIN siswa s ON p.NIS = s.NIS
        WHERE m.ID_Kantin = %s AND dp.Status_Detail = 'SELESAI'
        AND DATE(p.Tanggal_Pesanan) = CURDATE()
        ORDER BY p.Tanggal_Pesanan DESC
    """, (id_kantin,))
    
    detil = cursor.fetchall()
    if not detil:
        print("- Belum ada penjualan selesai hari ini -")
    else:
        for row in detil:
            jam = row[0].strftime("%H:%M")
            print(f"[{jam}] {row[1]} beli {row[2]} (x{row[3]}) -> {format_rupiah(row[4])}")
    
    conn.close()
    press_enter()

# --- HELPER DATABASE ---
def update_status_batch(id_kantin, id_pesanan, status):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        UPDATE detail_pesanan dp 
        JOIN menu m ON dp.ID_Menu = m.ID_Menu 
        SET dp.Status_Detail = %s 
        WHERE dp.ID_Pesanan = %s AND m.ID_Kantin = %s
    """, (status, id_pesanan, id_kantin))
    conn.commit()
    conn.close()

def cek_global_status(id_pesanan):
    conn = get_connection()
    cursor = conn.cursor()
    # Cek apakah masih ada detail yang belum selesai
    cursor.execute("SELECT COUNT(*) FROM detail_pesanan WHERE ID_Pesanan=%s AND Status_Detail != 'SELESAI'", (id_pesanan,))
    sisa = cursor.fetchone()[0]
    
    if sisa == 0:
        cursor.execute("UPDATE pesanan SET Status='SELESAI' WHERE ID_Pesanan=%s", (id_pesanan,))
        conn.commit()
    conn.close()