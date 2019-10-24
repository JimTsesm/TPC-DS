setlocal enableextensions enabledelayedexpansion
@echo off

REM export a password for use with the system (no quotes)
SET PGHOST=localhost
SET PGDATABASE=TPCDS_DB_OLD_ENCODING
SET PGUSER=postgres
SET PGPASSWORD=

REM define a counter
SET /a counter = 0

REM execute psql by file, even though echo is off, errors will still show
for /f %%f in ('dir /b C:\Users\Alex\Desktop\TPC-DS\data\queries_to_execute\') do (
SET /a counter += 1
psql -X --variable=ON_ERROR_STOP= -1 -w -c \timing -f queries_to_execute/%%f >> outputs/out_%%f.txt)


REM psql -X --variable=ON_ERROR_STOP= -1 -w -f query_2 >> out_query_2.txt
pause
timeout 5