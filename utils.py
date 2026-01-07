import os
import time
import msvcrt

def clear():
    os.system("cls" if os.name == "nt" else "clear")

def press_enter():
    input("\nTekan [Enter] untuk kembali...")

def format_rupiah(angka):
    if angka is None: angka = 0
    return f"Rp {int(angka):,.0f}".replace(",", ".")

def countdown_timer(durasi_detik):
    """Timer hitung mundur untuk pembayaran"""
    end_time = time.time() + durasi_detik
    print("\nMenunggu Pembayaran... (Tekan ENTER untuk Konfirmasi Simulasi)")
    
    while True:
        sisa = int(end_time - time.time())
        if sisa <= 0:
            print("\n❌ WAKTU HABIS! Transaksi Dibatalkan.")
            return False
        
        menit = sisa // 60
        detik = sisa % 60
        print(f"\rSisa waktu: {menit:02}:{detik:02d} ", end="", flush=True)
        
        # Simulasi konfirmasi pembayaran dengan Enter
        if msvcrt.kbhit():
            key = msvcrt.getch()
            if key == b"\r": # Enter Key
                print("\n✅ Pembayaran Terdeteksi!")
                time.sleep(1)
                return True
        
        time.sleep(0.1)