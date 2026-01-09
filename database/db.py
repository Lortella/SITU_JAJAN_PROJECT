import mysql.connector

def get_connection():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",         
            database="db_situ_jajan",
            port=3306
        )
        return connection
    except mysql.connector.Error as err:
        print(f"Error Database: {err}")
        exit()