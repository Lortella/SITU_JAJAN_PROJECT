from database.db import get_connection
from utils import clear, press_enter, format_rupiah, countdown_timer
import time

def show_dashboard(user_data):
    nis = user_data['nis']
    id_ortu = user_data['id_ortu']
    
    while True:
        clear()
        print(f"=== HALO, {user_data['nama_siswa']} / {user_data['nama_ortu']} ===")
        print("1. 💰 Cek Saldo & Keuangan")
        print("2. 🏧 Top Up Saldo")
        print("3. 🛒 Mulai Jajan (Pesan Makan)")
        print("4. 📜 History & Status Pesanan")
        print("0. Logout")
        
        pilih = input("\nPilih Menu: ")

        if pilih == "1":
            cek_saldo(id_ortu)
        elif pilih == "2":
            top_up(id_ortu, nis)
        elif pilih == "3":
            belanja(id_ortu, nis)
        elif pilih == "4":
            history(id_ortu, nis)
        elif pilih == "0":
            break

def cek_saldo(id_ortu):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT IFNULL(Saldo,0) FROM saldo WHERE ID_Ortu=%s", (id_ortu,))
    saldo = cursor.fetchone()[0]
    conn.close()
    
    print(f"\n💰 Saldo Aktif: {format_rupiah(saldo)}")
    press_enter()

def top_up(id_ortu, nis):
    clear()
    print("=== TOP UP SALDO ===")
    nominal = input("Masukkan Nominal: Rp ")
    if not nominal.isdigit() or int(nominal) <= 0: 
        print("Nominal tidak valid!")
        time.sleep(1)
        return
    nominal = int(nominal)
    
    print("\nPilih Kategori Pembayaran:")
    print("1. Virtual Account (Bank)")
    print("2. E-Wallet")
    print("0. Batal")
    kategori = input("Pilih: ")
    
    provider_name = ""
    nomor_bayar = ""
    
    # ----------------------------------------
    # PILIHAN VIRTUAL ACCOUNT
    # ----------------------------------------
    if kategori == "1":
        print("\nPilih Bank:")
        print("1. BCA Virtual Account")
        print("2. Mandiri Virtual Account")
        print("3. BRI Virtual Account")
        print("4. BNI Virtual Account")
        pilih_bank = input("Pilih Bank: ")
        
        # Logic Prefix Nomor VA
        clean_nis = nis.replace("S", "").replace("s", "").zfill(4)
        
        if pilih_bank == "1":
            provider_name = "BCA Virtual Account"
            nomor_bayar = "88000" + clean_nis
        elif pilih_bank == "2":
            provider_name = "Mandiri Virtual Account"
            nomor_bayar = "89000" + clean_nis
        elif pilih_bank == "3":
            provider_name = "BRI Virtual Account"
            nomor_bayar = "88880" + clean_nis
        elif pilih_bank == "4":
            provider_name = "BNI Virtual Account"
            nomor_bayar = "988" + clean_nis
        else:
            print("Pilihan tidak valid")
            time.sleep(1)
            return

    # ----------------------------------------
    # PILIHAN E-WALLET
    # ----------------------------------------
    elif kategori == "2":
        print("\nPilih E-Wallet:")
        print("1. GoPay")
        print("2. OVO")
        print("3. DANA")
        print("4. ShopeePay")
        pilih_ewallet = input("Pilih E-Wallet: ")
        
        clean_nis = nis.replace("S", "").replace("s", "").zfill(4)
        base_number = "0812-9999-" + clean_nis # Simulasi nomor HP
        
        if pilih_ewallet == "1":
            provider_name = "GoPay"
            nomor_bayar = base_number
        elif pilih_ewallet == "2":
            provider_name = "OVO"
            nomor_bayar = base_number
        elif pilih_ewallet == "3":
            provider_name = "DANA"
            nomor_bayar = base_number
        elif pilih_ewallet == "4":
            provider_name = "ShopeePay"
            nomor_bayar = base_number
        else:
            print("Pilihan tidak valid")
            time.sleep(1)
            return
            
    elif kategori == "0":
        return
    else:
        print("Pilihan tidak valid")
        return

    # ----------------------------------------
    # KONFIRMASI PEMBAYARAN
    # ----------------------------------------
    clear()
    print(f"=== KONFIRMASI TOP UP ===")
    print(f"Metode   : {provider_name}")
    print(f"No Bayar : {nomor_bayar}")
    print(f"Nominal  : {format_rupiah(nominal)}")
    print(f"Admin    : Rp 0")
    print(f"Total    : {format_rupiah(nominal)}")
    print("-" * 30)
    
    # Panggil Timer Pembayaran
    if countdown_timer(60): # 60 detik simulasi waktu bayar
        conn = get_connection()
        cursor = conn.cursor()
        
        # 1. Update Saldo
        cursor.execute("UPDATE saldo SET Saldo = Saldo + %s WHERE ID_Ortu = %s", (nominal, id_ortu))
        
        # 2. Catat Riwayat
        keterangan = f"TopUp via {provider_name}"
        cursor.execute("INSERT INTO riwayat_transaksi (Jenis_Transaksi, Tanggal, Keterangan, Nominal, ID_Ortu) VALUES ('TOPUP', NOW(), %s, %s, %s)",
                       (keterangan, nominal, id_ortu))
        
        conn.commit()
        conn.close()
        print(f"\n✅ Saldo {format_rupiah(nominal)} berhasil masuk!")
        press_enter()

def belanja(id_ortu, nis):
    conn = get_connection()
    cursor = conn.cursor()
    keranjang = {} # Dictionary untuk simpan item

    while True:
        clear()
        print("=== 🛒 MENU JAJANAN KANTIN ===")
        cursor.execute("SELECT ID_Menu, Nama_Menu, Harga, Stok FROM menu WHERE Stok > 0")
        menus = cursor.fetchall()
        
        for m in menus:
            print(f"[{m[0]}] {m[1]:<20} | {format_rupiah(m[2]):<12} | Stok: {m[3]}")
            
        print("\n--- ISI KERANJANG ---")
        total_bayar = 0
        if not keranjang:
            print("(Kosong)")
        else:
            for k_id, item in keranjang.items():
                subtotal = item['harga'] * item['qty']
                total_bayar += subtotal
                print(f"- {item['nama']} x{item['qty']} = {format_rupiah(subtotal)}")
            print(f"TOTAL: {format_rupiah(total_bayar)}")
            
        print("\n[Ketik ID Menu untuk beli] | 'C' Checkout | 'R' Reset | '0' Kembali")
        aksi = input(">> ").upper()
        
        if aksi == "0": break
        elif aksi == "R": keranjang.clear()
        elif aksi == "C":
            if not keranjang:
                print("Keranjang kosong!")
                time.sleep(1)
                continue
            
            # PROSES CHECKOUT
            cursor.execute("SELECT IFNULL(Saldo,0) FROM saldo WHERE ID_Ortu=%s", (id_ortu,))
            saldo_user = cursor.fetchone()[0]
            
            if saldo_user < total_bayar:
                print(f"\n❌ Saldo tidak cukup! (Sisa: {format_rupiah(saldo_user)})")
                press_enter()
                continue
            
            # 1. Buat Pesanan
            cursor.execute("INSERT INTO pesanan (Total_Pesanan, Tanggal_Pesanan, NIS, Status) VALUES (%s, NOW(), %s, 'MENUNGGU')", (total_bayar, nis))
            id_pesanan = cursor.lastrowid
            
            # 2. Insert Detail & Potong Stok
            for k_id, item in keranjang.items():
                cursor.execute("INSERT INTO detail_pesanan (Jumlah, Harga_Satuan, Subtotal, ID_Menu, ID_Pesanan, Status_Detail) VALUES (%s, %s, %s, %s, %s, 'MENUNGGU')",
                               (item['qty'], item['harga'], item['harga']*item['qty'], k_id, id_pesanan))
                cursor.execute("UPDATE menu SET Stok = Stok - %s WHERE ID_Menu = %s", (item['qty'], k_id))
            
            # 3. Potong Saldo & Catat Log
            cursor.execute("UPDATE saldo SET Saldo = Saldo - %s WHERE ID_Ortu = %s", (total_bayar, id_ortu))
            cursor.execute("INSERT INTO riwayat_transaksi (Jenis_Transaksi, Tanggal, Keterangan, Nominal, ID_Ortu) VALUES ('PEMBAYARAN', NOW(), %s, %s, %s)",
                           (f"Jajan Order #{id_pesanan}", total_bayar, id_ortu))
            
            conn.commit()
            print("\n✅ Pembayaran Berhasil! Pesanan dikirim ke dapur.")
            press_enter()
            break
            
        elif aksi.isdigit():
            # Logic Tambah ke Keranjang
            selected = next((m for m in menus if str(m[0]) == aksi), None)
            if selected:
                qty = input(f"Beli berapa {selected[1]}? : ")
                if qty.isdigit() and int(qty) > 0 and int(qty) <= selected[3]:
                    if int(aksi) in keranjang:
                        keranjang[int(aksi)]['qty'] += int(qty)
                    else:
                        keranjang[int(aksi)] = {'nama': selected[1], 'harga': selected[2], 'qty': int(qty)}
                else:
                    print("Jumlah tidak valid / Stok kurang.")
                    time.sleep(1)
    
    conn.close()

def history(id_ortu, nis):
    conn = get_connection()
    cursor = conn.cursor()
    clear()
    print("=== 📜 RIWAYAT TRANSAKSI ===")
    
    cursor.execute("SELECT Tanggal, Jenis_Transaksi, Nominal, Keterangan FROM riwayat_transaksi WHERE ID_Ortu=%s ORDER BY Tanggal DESC LIMIT 5", (id_ortu,))
    for row in cursor.fetchall():
        print(f"[{row[0].strftime('%d/%m %H:%M')}] {row[1]} : {format_rupiah(row[2])} ({row[3]})")
        
    print("\n=== STATUS PESANAN AKTIF ===")
    cursor.execute("SELECT ID_Pesanan, Tanggal_Pesanan, Status FROM pesanan WHERE NIS=%s ORDER BY ID_Pesanan DESC LIMIT 5", (nis,))
    for row in cursor.fetchall():
        status = row[2]
        icon = "✅" if status == 'SELESAI' else "⏳" if status == 'MENUNGGU' else "🍳"
        print(f"#{row[0]} | {row[1].strftime('%H:%M')} | {icon} {status}")
        
    conn.close()
    press_enter()