import mysql.connector  # Import the MySQL connector library to interact with MySQL databases.

def db_connection():
    """
    Establishes a buffered connection to the MySQL database.
    This function creates and returns a connection object that can be used to interact with the database.
    The connection is buffered, meaning that all rows are fetched from the server immediately after query execution, which helps manage multiple result sets and avoid errors like 'Unread result found'.
    """
    return mysql.connector.connect(
        host="localhost",  # Specifies the host server where the MySQL database is running, 'localhost' indicates the database is on the same machine.
        user="root",       # Specifies the username to log into the MySQL database, 'root' is the default superuser with all privileges.
        password="",       # Specifies the password for logging into the MySQL database, empty here for simplicity.
        database="electromart_databaseproject",  # Specifies the specific database name to connect to within the MySQL server.
        buffered=True      # Ensures that query results are immediately transferred from the server to avoid the 'Unread result found' error.
    )


"""
Check your mysql is running up on your machine
( you can install different way accordinig to your machine
- I used: brew install mysql
)


1. Navigate to the SQL File Directory
cd /Users/tungno/Desktop/database_project/db
(you will get this file: <database_project/db> after downloading the Giblab repo)

2. Log in to MySQL
mysql -u root -p

3. Create a New Database
CREATE DATABASE electromart_databaseproject;

4. Exit MySQL Command Line
EXIT;

5. Import SQL File
mysql -u root -p electromart_databaseproject < electromart_databaseproject.sql


6. Verify the Import
mysql -u root -p

Check if your tables and data are present:
USE electromart_databaseproject;

SHOW TABLES;

Connecting and Updating Your SQL File
mysqldump -u root -p electromart_databaseproject > electromart_databaseproject_updated.sql

"""