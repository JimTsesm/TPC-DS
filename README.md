# TPC-DS

Query translation to PostgreSQL:
Modify the following template:
77, 23, 49, 30, 14, 2, 86, 70, 36, 98, 95, 94, 92, 82, 80, 40, 37, 32, 21, 20, 16, 12, 5

Data Qualification:

Data Population:
1)Create csv files using ...
2)Remove the last "|" from every csv files using "\|$" expression (Search Mode: Regular expression) and [Replace All in All Opened Documents] command in Notepad++
3)Give right permission to the directory that contains the csv files, in order to be accessible by pgAdmin
4)Run [insert_dataset_to_db.sql] script in order to insert data from csv into the database. Here the Copy function of Postgresql is used.
