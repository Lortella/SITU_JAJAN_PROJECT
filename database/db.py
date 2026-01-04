import mysql.connector

def get_connection():
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="db_situ_jajan",
        port=3306
    )
    return connection
