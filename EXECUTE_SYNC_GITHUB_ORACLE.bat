cls
@echo off

Rem -- Variables Enviroment
SET USER=snowflake
SET PASS=snowflake
SET SID=amidala
SET VPATH=D:\mgage-redpill-migration-inventory\
SET DATABASE=amidala

ECHO Carga Execução Mgage- Objetcs Database %DATABASE%

rem -- FOR %%db IN ( Database1, database2, database3, databasen ) DO ECHO %%db

sqlplus -s  %USER%/%PASS%@%SID% @SQLPLUS_Oracle_DATABASE.sql

rem -- Add %DATABASE%
git add "oracle_table_%DATABASE%.csv"
git add "oracle_partitions_table_%DATABASE%.csv"
git add "oracle_synonym_%DATABASE%.csv"
git add "oracle_procedure_%DATABASE%.csv"
git add "oracle_db_link_%DATABASE%.csv"
git add "oracle_sequence_%DATABASE%.csv"


rem -- Commit %DATABASE%
git commit -m "oracle_table_%DATABASE%.log"
git commit -m "oracle_partitions_table_%DATABASE%.log"
git commit -m "oracle_synonym_%DATABASE%.log"
git commit -m "oracle_procedure_%DATABASE%.log"
git commit -m "oracle_db_link_%DATABASE%.log"
git commit -m "oracle_sequence_%DATABASE%.log"


rem - Push GitHub
git push -u origin master

