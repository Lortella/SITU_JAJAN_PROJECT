from modules import auth, menu_ortu, menu_admin
from utils import clear

def main():
    while True:
        # 1. Jalankan Login
        user_session = auth.login()
        
        # 2. Arahkan sesuai Role
        if user_session['role'] == "ORTU":
            menu_ortu.show_dashboard(user_session)
        
        elif user_session['role'] == "ADMIN":
            menu_admin.show_dashboard(user_session)
            
        # Jika logout, loop akan kembali ke login

if __name__ == "__main__":
    main()