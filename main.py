import msvcrt  # Microsoft Visual C Runtime buat deteksi keypress di timer
import os  # Operating System
import time  # Time Module buat timer pas bayar
from database.db import get_connection  # Database Connection dari file db.py

# Clear screen (Windows / Linux / Mac). FYI bisa cuman os.system("clear") di Linux / Mac dan os.system("cls") di Windows
os.system("cls" if os.name == "nt" else "clear")

# Database connection
conn = get_connection()
cursor = conn.cursor()

# Timer bayar VA / QRIS
def countdown_timer(durasi_detik):
    end_time = time.time() + durasi_detik

    while True:
        sisa = int(end_time - time.time())

        if sisa <= 0:
            print("\rWAKTU HABIS!")
            return False 

        menit = sisa // 60
        detik = sisa % 60

        print(f"\rSisa waktu pembayaran: {menit:02}:{detik:02d}", end="", flush=True)

        # Cek apakah ada keypress
        if msvcrt.kbhit():          # Jika ada keypress kbhit = keyboard hit
            key = msvcrt.getch()    # Ambil karakter yang ditekan dengan getch = get character

            # Jika ENTER ditekan
            if key == b"\r":        # b"\r" adalah representasi byte untuk karakter ENTER kalo buat karakter lain tinggal ganti aja contoh a jadi b"a"
                print("\n\nPembayaran dikonfirmasi oleh pengguna.")
                print("Sedang memproses Top Up saldo...")
                time.sleep(3) 
                print("Top Up saldo berhasil!")
                return True
        time.sleep(1)


# =====================
# LOGIN SECTION
# =====================
belum_login = True

while belum_login:
    os.system("cls" if os.name == "nt" else "clear")

    print("SELAMAT DATANG DI APLIKASI BUDI MULIA")
    nis = input("Silahkan masukkan NIS: ").upper()      # .upper() biar NIS yang dimasukin user jadi kapital semua s001 jadi S001
    password = input("Silahkan masukkan Password: ")

    cursor.execute(
        """ 
        SELECT S.NIS, S.Nama, O.Nama, O.Password
        FROM siswa S
        JOIN orang_tua O ON S.ID_Ortu = O.ID_Ortu
        WHERE S.NIS = %s AND O.Password = %s
        """,
        (nis, password),
    )

    row = cursor.fetchone()

    if row:
        print(f"Selamat datang, {row[1]}!")         #type: ignore
        print(f"Orang tua Anda adalah {row[2]}.")   #type: ignore
        input("Tekan Enter untuk melanjutkan...")
        belum_login = False
    else:
        print("NIS atau Password salah.")
        input("Tekan Enter untuk mencoba lagi...")


# =====================
# MENU UTAMA
# =====================
menu_utama = True

while menu_utama:
    os.system("cls" if os.name == "nt" else "clear")

    print("Silahkan Pilih Menu:")
    print("1. Cek Saldo")
    print("2. Top Up Saldo")
    print("3. SITU JAJAN")
    print("4. Keluar")

    pilih = input("Masukkan pilihan Anda (1-4): ")

    # =====================
    # CEK SALDO
    # =====================
    if pilih == "1":
        cursor.execute(
            """
            SELECT O.ID_Ortu
            FROM orang_tua O
            JOIN siswa S ON O.ID_Ortu = S.ID_Ortu
            WHERE S.NIS = %s
            """,
            (nis,), #type: ignore
        )

        row = cursor.fetchone()

        if not row:
            print("Data orang tua tidak ditemukan, silahkan hubungi admin.")
            input("Tekan Enter untuk kembali ke menu...")
            continue

        id_ortu = row[0] #type: ignore

        cursor.execute("SELECT Saldo FROM saldo WHERE ID_Ortu = %s", (id_ortu,)) #type: ignore

        row = cursor.fetchone()

        if not row:
            print("Saldo kosong. Silahkan Top Up.")
            input("Tekan Enter untuk kembali ke menu...")
            continue

        saldo = row[0] #type: ignore
        print(f"Saldo Anda: Rp.{saldo}")

    # =====================
    # TOP UP SALDO
    # =====================
    elif pilih == "2":
        cursor.execute(
            """
            SELECT O.ID_Ortu
            FROM orang_tua O
            JOIN siswa S ON O.ID_Ortu = S.ID_Ortu
            WHERE S.NIS = %s
            """,
            (nis,), #type: ignore
        )

        row = cursor.fetchone()

        if not row:
            print("Data orang tua tidak ditemukan, silahkan hubungi admin.")
            input("Tekan Enter untuk kembali ke menu...")
            continue

        id_ortu = row[0] #type: ignore

        print("Pilih metode Top Up:")
        print("1. Virtual Account")
        print("2. QRIS")

        metode = input("Masukkan pilihan Anda (1-2): ")
        if metode not in ["1", "2"]:
            print("Metode Top Up tidak valid, masukkan pilihan 1 atau 2.")
            input("Tekan Enter untuk kembali ke menu...")
            continue
        
        jumlah = input("Masukkan jumlah Top Up (dalam Rupiah): ")
        try:
            jumlah_int = int(jumlah)
            if jumlah_int <= 0:
                raise ValueError # kalo jumlahnya negatif atau nol langsung raise ValueError biar masuk ke except di bawah
        except ValueError:
            print("Jumlah Top Up tidak valid.")
            input("Tekan Enter untuk kembali ke menu...")
            continue

        # Virtual Account
        if metode == "1":
            nis_angka = nis.replace("S", "") #type: ignore # Hapus 'S' dari NIS biar yang diambil cuma angkanya S001 jadi 001
            va = "8800103" + nis_angka.zfill(4) # zfill(4) biar misal angkanya cuma 1 digit jadi 4 digit dengan nol di depan 1 jadi 0001

            print(f"\nSilahkan transfer Rp.{jumlah} ke Virtual Account {va}.")
            print("Top Up akan diproses setelah pembayaran terkonfirmasi.")

            hasil = countdown_timer(30 * 60)
            if hasil:
                cursor.execute(
                    "UPDATE saldo SET Saldo = Saldo + %s WHERE ID_Ortu = %s",
                    (jumlah_int, id_ortu), #type: ignore
                )
                conn.commit()
            else:
                print("Top Up dibatalkan karena waktu habis.")


        # QRIS
        elif metode == "2":
            print(f"\nSilahkan scan QRIS berikut untuk Top Up sebesar Rp.{jumlah}.")
            print("[GAMBAR QRIS DI SINI]")
            print("Top Up akan diproses setelah pembayaran terkonfirmasi.")

            countdown_timer(5 * 60)

            cursor.execute(
                "UPDATE saldo SET Saldo = Saldo + %s WHERE ID_Ortu = %s",
                (jumlah_int, id_ortu), #type: ignore
            )
            conn.commit()
            
    # =====================
    # SITU JAJAN
    # =====================
    elif pilih == "3":
        print("Fitur SITU JAJAN belum tersedia.")
        input("Tekan Enter untuk kembali ke menu...")
        
    # =====================
    # KELUAR
    # =====================
    elif pilih == "4":
        print("\nTerima kasih telah menggunakan aplikasi BUDI MULIA.")
        input("Tekan Enter untuk keluar...")
        menu_utama = False

    if menu_utama:
        input("Tekan Enter untuk melanjutkan...")
