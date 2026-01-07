from database.db import get_connection
from utils import clear

def login():
    conn = get_connection()
    cursor = conn.cursor()

    while True:
        clear()
        print("===================================")
        print("      LOGIN SISTEM SITU JAJAN      ")
        print("===================================")
        
        username = input("Username / NIS : ").strip()
        password = input("Password       : ").strip()

        # 1. Cek Login Orang Tua / Siswa
        cursor.execute("""
            SELECT S.NIS, O.ID_Ortu, S.Nama, O.Nama 
            FROM siswa S 
            JOIN orang_tua O ON S.ID_Ortu = O.ID_Ortu 
            WHERE S.NIS = %s AND O.Password = %s
        """, (username, password))
        ortu = cursor.fetchone()

        if ortu:
            conn.close()
            return {
                "role": "ORTU",
                "nis": ortu[0],
                "id_ortu": ortu[1],
                "nama_siswa": ortu[2],
                "nama_ortu": ortu[3]
            }

        # 2. Cek Login Admin Kantin
        cursor.execute("""
            SELECT ID_Kantin, Nama_Petugas 
            FROM kantin 
            WHERE Username = %s AND Password = %s
        """, (username, password))
        admin = cursor.fetchone()

        if admin:
            conn.close()
            return {
                "role": "ADMIN",
                "id_kantin": admin[0],
                "nama": admin[1]
            }

        print("\n❌ Username atau Password salah!")
        input("Tekan Enter untuk coba lagi...")