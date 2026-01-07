import msvcrt
import os
import time
from database.db import get_connection

conn = get_connection()
cursor = conn.cursor()

def clear():
    os.system("cls" if os.name == "nt" else "clear")

def press_enter():
    input("\nTekan Enter untuk melanjutkan...")

# =====================
# TIMER PEMBAYARAN
# =====================
def countdown_timer(durasi_detik):
    end_time = time.time() + durasi_detik
    while True:
        sisa = int(end_time - time.time())
        if sisa <= 0:
            print("\nWAKTU HABIS")
            return False
        menit = sisa // 60
        detik = sisa % 60
        print(f"\rSisa waktu: {menit:02}:{detik:02d}", end="", flush=True)
        if msvcrt.kbhit() and msvcrt.getch() == b"\r":
            print("\nPembayaran dikonfirmasi")
            time.sleep(2)
            return True
        time.sleep(1)

# =====================
# LOGIN (AUTO ROLE)
# =====================
clear()
print("LOGIN SISTEM SITU JAJAN\n")

username = input("NIS Anak / Username Kantin: ").upper()
password = input("Password: ")

role = None
nis = None
id_ortu = None
id_kantin = None
nama_petugas = None

# LOGIN ORANG TUA
cursor.execute(
    """
    SELECT S.NIS, O.ID_Ortu
    FROM siswa S
    JOIN orang_tua O ON S.ID_Ortu = O.ID_Ortu
    WHERE S.NIS = %s AND O.Password = %s
    """,
    (username, password),
)
ortu = cursor.fetchone()

if ortu:
    role = "ORTU"
    nis = ortu[0]
    id_ortu = ortu[1]
else:
    # LOGIN ADMIN KANTIN
    cursor.execute(
        """
        SELECT ID_Kantin, Nama_Petugas
        FROM kantin
        WHERE Username = %s AND Password = %s
        """,
        (username.lower(), password),
    )
    admin = cursor.fetchone()
    if admin:
        role = "ADMIN"
        id_kantin = admin[0]
        nama_petugas = admin[1]

if not role:
    print("Login gagal. Username / Password salah.")
    exit()

# ============================================================
# ===================== MENU ORANG TUA =======================
# ============================================================
if role == "ORTU":
    while True:
        clear()
        print("MENU ORANG TUA")
        print("1. Cek Saldo")
        print("2. Top Up Saldo")
        print("3. SITU JAJAN (Multi Item)")
        print("4. History")
        print("5. Keluar")
        pilih = input("Pilih: ")

        # =====================
        # CEK SALDO
        # =====================
        if pilih == "1":
            cursor.execute(
                "SELECT IFNULL(Saldo,0) FROM saldo WHERE ID_Ortu=%s",
                (id_ortu,),
            )
            saldo = cursor.fetchone()[0]
            print(f"Saldo: Rp.{saldo}")
            press_enter()

        # =====================
        # TOP UP SALDO
        # =====================
        elif pilih == "2":
            clear()
            print("PILIH METODE TOP UP")
            print("1. Virtual Account")
            print("2. E-Wallet")
            metode = input("Pilih (1/2): ")

            jumlah = int(input("Masukkan jumlah Top Up: "))

            # ===== VIRTUAL ACCOUNT =====
            if metode == "1":
                nis_angka = nis.replace("S", "")
                va = "8800103" + nis_angka.zfill(4)

                print(f"\nSilahkan transfer ke Virtual Account:")
                print(f"VA Number : {va}")
                print(f"Nominal   : Rp.{jumlah}")
                print("\nTekan ENTER setelah transfer")

                if countdown_timer(5 * 60):
                    cursor.execute(
                        "UPDATE saldo SET Saldo=Saldo+%s WHERE ID_Ortu=%s",
                        (jumlah, id_ortu),
                    )
                    cursor.execute(
                        """
                        INSERT INTO riwayat_transaksi
                        (Jenis_Transaksi,Tanggal,Keterangan,Nominal,ID_Ortu)
                        VALUES ('TOP UP',NOW(),'Top Up via Virtual Account',%s,%s)
                        """,
                        (jumlah, id_ortu),
                    )
                    conn.commit()

            # ===== E-WALLET =====
            elif metode == "2":
                clear()
                print("PILIH E-WALLET")
                print("1. OVO")
                print("2. DANA")
                print("3. GoPay")
                ewallet = input("Pilih (1-3): ")

                if ewallet == "1":
                    nama = "OVO"
                elif ewallet == "2":
                    nama = "DANA"
                elif ewallet == "3":
                    nama = "GoPay"
                else:
                    print("Pilihan tidak valid")
                    press_enter()
                    continue

                print(f"\nSilahkan transfer ke {nama}")
                print("Nomor : 081234567890")
                print(f"Nominal : Rp.{jumlah}")
                print("\nTekan ENTER setelah transfer")

                if countdown_timer(5 * 60):
                    cursor.execute(
                        "UPDATE saldo SET Saldo=Saldo+%s WHERE ID_Ortu=%s",
                        (jumlah, id_ortu),
                    )
                    cursor.execute(
                        """
                        INSERT INTO riwayat_transaksi
                        (Jenis_Transaksi,Tanggal,Keterangan,Nominal,ID_Ortu)
                        VALUES ('TOP UP',NOW(),%s,%s,%s)
                        """,
                        (f"Top Up via {nama}", jumlah, id_ortu),
                    )
                    conn.commit()

            else:
                print("Metode tidak valid")

            press_enter()

        # =====================
        # SITU JAJAN (KERANJANG + MERGE + STRUK)
        # =====================
        elif pilih == "3":
            cursor.execute(
                "SELECT IFNULL(Saldo,0) FROM saldo WHERE ID_Ortu=%s",
                (id_ortu,),
            )
            saldo = cursor.fetchone()[0]

            cursor.execute(
                "SELECT ID_Menu,Nama_Menu,Harga,Stok FROM menu WHERE Stok>0"
            )
            menus = cursor.fetchall()

            keranjang = {}
            total = 0

            while True:
                clear()
                print("===== DAFTAR MENU =====")
                for m in menus:
                    print(f"{m[0]} | {m[1]} | Rp.{m[2]} | Stok {m[3]}")

                print("\n===== KERANJANG =====")
                if keranjang:
                    for i, k in enumerate(keranjang.values(), start=1):
                        print(f"{i}. {k['nama']} x{k['jumlah']} = Rp.{k['subtotal']}")
                    print(f"\nTOTAL : Rp.{total}")
                    print(f"SALDO : Rp.{saldo}")
                else:
                    print("- Keranjang kosong -")

                print("\n1. Tambah Menu")
                print("2. Hapus Item")
                print("3. Checkout")
                print("0. Batal")

                aksi = input("Pilih: ")

                # TAMBAH MENU
                if aksi == "1":
                    id_menu = input("ID Menu: ")
                    jumlah = int(input("Jumlah: "))

                    cursor.execute(
                        "SELECT Nama_Menu,Harga,Stok FROM menu WHERE ID_Menu=%s",
                        (id_menu,),
                    )
                    m = cursor.fetchone()

                    if not m or jumlah <= 0 or jumlah > m[2]:
                        continue

                    if id_menu in keranjang:
                        keranjang[id_menu]["jumlah"] += jumlah
                        keranjang[id_menu]["subtotal"] += m[1] * jumlah
                    else:
                        keranjang[id_menu] = {
                            "id_menu": id_menu,
                            "nama": m[0],
                            "harga": m[1],
                            "jumlah": jumlah,
                            "subtotal": m[1] * jumlah
                        }

                    total = sum(i["subtotal"] for i in keranjang.values())

                # HAPUS ITEM
                elif aksi == "2":
                    if not keranjang:
                        continue

                    for i, k in enumerate(keranjang.values(), start=1):
                        print(f"{i}. {k['nama']}")

                    idx = int(input("Nomor item: ")) - 1
                    if 0 <= idx < len(keranjang):
                        key = list(keranjang.keys())[idx]
                        del keranjang[key]
                        total = sum(i["subtotal"] for i in keranjang.values())

                # CHECKOUT
                elif aksi == "3":
                    if not keranjang:
                        print("Keranjang kosong")
                        press_enter()
                        continue

                    if total > saldo:
                        print("Saldo tidak mencukupi")
                        press_enter()
                        continue

                    cursor.execute(
                        """
                        INSERT INTO pesanan
                        (Total_Pesanan,Tanggal_Pesanan,NIS,Status)
                        VALUES (%s,NOW(),%s,'DIPESAN')
                        """,
                        (total, nis),
                    )
                    id_pesanan = cursor.lastrowid

                    for k in keranjang.values():
                        cursor.execute(
                            """
                            INSERT INTO detail_pesanan
                            (Jumlah,Harga_Satuan,Subtotal,ID_Menu,ID_Pesanan)
                            VALUES (%s,%s,%s,%s,%s)
                            """,
                            (k["jumlah"], k["harga"], k["subtotal"], k["id_menu"], id_pesanan),
                        )
                        cursor.execute(
                            "UPDATE menu SET Stok=Stok-%s WHERE ID_Menu=%s",
                            (k["jumlah"], k["id_menu"]),
                        )

                    cursor.execute(
                        "UPDATE saldo SET Saldo=Saldo-%s WHERE ID_Ortu=%s",
                        (total, id_ortu),
                    )
                    conn.commit()

                    # ===== CETAK STRUK =====
                    clear()
                    print("===== STRUK PEMBELIAN =====")
                    cursor.execute("SELECT Nama FROM siswa WHERE NIS=%s", (nis,))
                    nama_anak = cursor.fetchone()[0]

                    print(f"Nama Anak : {nama_anak}")
                    print(f"Tanggal   : {time.strftime('%Y-%m-%d %H:%M:%S')}")
                    print("----------------------------")
                    for k in keranjang.values():
                        print(f"{k['nama']} x{k['jumlah']}  Rp.{k['subtotal']}")
                    print("----------------------------")
                    print(f"TOTAL      : Rp.{total}")
                    print(f"Sisa Saldo : Rp.{saldo - total}")
                    print("============================")
                    press_enter()
                    break

                elif aksi == "0":
                    break


        # =====================
        # HISTORY
        # =====================
        elif pilih == "4":
            cursor.execute(
                """
                SELECT Jenis_Transaksi,Tanggal,Keterangan,Nominal
                FROM riwayat_transaksi
                WHERE ID_Ortu=%s
                ORDER BY Tanggal DESC
                """,
                (id_ortu,),
            )
            for r in cursor.fetchall():
                print(f"{r[1]} | {r[0]} | Rp.{r[3]} | {r[2]}")

            print("\nSTATUS PESANAN:")
            cursor.execute(
                """
                SELECT ID_Pesanan,Status,Tanggal_Pesanan
                FROM pesanan
                WHERE NIS=%s
                ORDER BY Tanggal_Pesanan DESC
                """,
                (nis,),
            )
            for p in cursor.fetchall():
                status = "Sudah diterima anak" if p[1] == "DITERIMA" else "Belum diterima"
                print(f"{p[2]} | Pesanan {p[0]} | {status}")

            press_enter()

        elif pilih == "5":
            break

# ============================================================
# ===================== MENU ADMIN KANTIN ====================
# ============================================================
elif role == "ADMIN":
    while True:
        clear()
        print("===================================")
        print(" SISTEM KANTIN - PETUGAS KANTIN ")
        print("===================================")
        print(f"Halo, {nama_petugas}\n")
        print("1. Lihat Pesanan Masuk")
        print("2. Konfirmasi Pesanan")
        print("3. Keluar")

        pilih = input("Pilih menu (1-3): ")

        if pilih == "1":
            clear()
            print("DAFTAR PESANAN MASUK\n")

            cursor.execute(
                """
                SELECT P.ID_Pesanan, S.Nama, O.Nama, P.Total_Pesanan, P.Tanggal_Pesanan
                FROM pesanan P
                JOIN siswa S ON P.NIS = S.NIS
                JOIN orang_tua O ON S.ID_Ortu = O.ID_Ortu
                WHERE P.Status = 'DIPESAN'
                ORDER BY P.Tanggal_Pesanan ASC
                """
            )

            pesanan = cursor.fetchall()

            if not pesanan:
                print("Belum ada pesanan.")
                press_enter()
                continue

            for i, p in enumerate(pesanan, start=1):
                print(f"{i}. Anak  : {p[1]}")
                print(f"   Ortu  : {p[2]}")
                print(f"   Waktu : {p[4]}")
                print(f"   Total : Rp.{p[3]}")
                print("   Menu  :")

                cursor.execute(
                    """
                    SELECT M.Nama_Menu, DP.Jumlah, DP.Harga_Satuan, DP.Subtotal
                    FROM detail_pesanan DP
                    JOIN menu M ON DP.ID_Menu = M.ID_Menu
                    WHERE DP.ID_Pesanan = %s
                    """,
                    (p[0],),
                )

                for d in cursor.fetchall():
                    print(f"     - {d[0]} x{d[1]} @Rp.{d[2]} = Rp.{d[3]}")
                print()

            press_enter()

        elif pilih == "2":
            clear()
            print("KONFIRMASI PESANAN\n")

            cursor.execute(
                """
                SELECT P.ID_Pesanan, S.Nama, O.Nama, P.Total_Pesanan
                FROM pesanan P
                JOIN siswa S ON P.NIS = S.NIS
                JOIN orang_tua O ON S.ID_Ortu = O.ID_Ortu
                WHERE P.Status = 'DIPESAN'
                ORDER BY P.Tanggal_Pesanan ASC
                """
            )

            pesanan = cursor.fetchall()

            if not pesanan:
                print("Tidak ada pesanan.")
                press_enter()
                continue

            for i, p in enumerate(pesanan, start=1):
                print(f"{i}. {p[1]} (Ortu: {p[2]}) - Rp.{p[3]}")

            pilih_nomor = input("\nPilih nomor pesanan yang sudah diterima (0 batal): ")

            try:
                pilih_nomor = int(pilih_nomor)
                if pilih_nomor == 0:
                    continue
                if pilih_nomor < 1 or pilih_nomor > len(pesanan):
                    raise ValueError
            except ValueError:
                print("Pilihan tidak valid")
                press_enter()
                continue

            id_pesanan = pesanan[pilih_nomor - 1][0]

            cursor.execute(
                "UPDATE pesanan SET Status='DITERIMA' WHERE ID_Pesanan=%s",
                (id_pesanan,),
            )
            conn.commit()

            print("Pesanan berhasil dikonfirmasi.")
            press_enter()

        elif pilih == "3":
            break
