/*
   --------------------------------------------------------------------------
   Project  : mGage
   Company  : Red Pill
   Module   : Database ORCL- Tables and Partitions tables
   --------------------------------------------------------------------------
   Goal        : Extraction Objects from the database amidala
   Author      : Majela Fortes - majela.fortes@redpillanalytics.com
   Mob Brazil  : +55 1 61 99879 9000
   Date        : 06/09/2017
   --------------------------------------------------------------------------
   History of changes

   person      Date      Comments
   ---------   ------    ----------------------------------------------------

   spool E:\git\mgage-redpill-migration-inventory\bos\oracle_table_amidala.csv 

*/



/* -----------------------------------------------------
   --  %DATABASE%  --
*/ -----------------------------------------------------

/* Enviroment */


SET PAGESIZE 50000
SET LINESIZE 900
SET NUMWIDTH 30
SET FEEDBACK OFF
set echo off
set heading on
set headsep off
set wrap off
set colsep ,


alter session set nls_date_format='yyyy/mm/dd'

*  -- Tables ------------------------------------------*/
Column server_name         format a14
column owner               format a20
column table_name          format a40
column date_ast_analyzed   format a40
column size_mb             format 999999999
column rows_count          format 999999999
column Object_type         format a30
spool %VPATH%oracle_table_%DATABASE%.csv
rem @Query_Oracle_table_%DATABASE%.sql 


  SELECT (SELECT * FROM global_name) server_name,
       a.owner,
       a.table_name,
       a.last_analyzed,
       SUM (b.bytes) / 1048576 size_mb,
       a.num_rows,
       b.segment_type
  FROM dba_tables a, dba_segments b
  WHERE     a.table_name = b.segment_name
       AND a.owner = b.owner
       AND a.owner NOT IN ('SYS', 'SYSTEM')
       AND b.segment_type = 'TABLE'
  GROUP BY a.owner,
           a.table_name,
           a.num_rows,
           a.last_analyzed,
           b.segment_type
  Order by 1,2;


spool off

/* ---End Tables---------------------------------------*/



/*  -- Partitions Tables ------------------------------------------*/
Column server_name         format a14
column owner               format a20
column table_name          format a40
column date_ast_analyzed   format a40
column size_mb             format 999999999
column rows_count          format 999999999
column Object_type         format a30
spool %VPATH%oracle_partitions_table_%DATABASE%.csv
rem @Query_Oracle_paritions_table_%DATABASE%.sql 

SELECT (SELECT * FROM global_name) server_name,
       a.owner,
       a.table_name,
       a.last_analyzed,
       SUM (b.bytes) / 1048576 size_mb,
       a.num_rows,
       b.segment_type 
  FROM dba_tables a, dba_segments b
 WHERE     a.table_name = b.segment_name
       AND a.owner = b.owner
       AND a.owner NOT IN ('SYS', 'SYSTEM')
       AND b.segment_type = 'TABLE PARTITION'
GROUP BY a.owner,
         a.table_name,
         a.num_rows,
         a.last_analyzed,
         b.segment_type
ORDER BY 1,2;

spool off

/* ---End Partitions Tables---------------------------------------*/



/*  -- Synonym ------------------------------------------*/
Column server_name  format a14
column owner        format a15
Column synonym_name format a30
Column table_owner  format a15
Column table_name   format a30
Column db_link      format a15
column Object_type  format a30
spool %VPATH%oracle_synonym_%DATABASE%.csv
rem @Query_Oracle_synonym_%DATABASE%.sql

  select 
     (SELECT * FROM GLOBAL_NAME) server_name,
     a.owner,
     a.synonym_name,
     a.table_owner,
     a.table_name,
     a.db_link,
     b.object_type
  from dba_synonyms a , dba_objects b
  where a.owner = b.owner and 
        a.synonym_name = b.object_name and
        a.owner NOT IN ('SYS', 'SYSTEM') and
        a.table_owner != 'SYS'
  Order by 1,2;
    

spool off

/* ---End Synonyn---------------------------------------*/



/*  -- Procedures ------------------------------------------*/
Column server_name         format a14
column owner               format a20
Column object_name         format a50
column last_ddl_time       format a35
column status              format a10
column Object_type         format a30
spool %VPATH%oracle_procedure_%DATABASE%.csv
rem @Query_Oracle_procedure_%DATABASE%.sql

   SELECT
      (SELECT * FROM GLOBAL_NAME) server_name,
       a.owner,
       b.object_name,
       a.last_ddl_time,
       a.status,
       a.object_type
   FROM dba_objects a, dba_procedures b
   WHERE     a.owner = b.owner
       AND a.object_id = b.object_id
       AND a.object_type = 'PROCEDURE'
       AND a.owner NOT IN ('SYS', 'SYSTEM')
   order by
        a.owner;

spool off

/* ---End Procedures---------------------------------------*/



/*  -- DB_LINK ------------------------------------------*/

spool %VPATH%oracle_db_link_%DATABASE%.csv
rem @Query_Oracle_db_link_%DATABASE%.sql
column servername       format a30
column owner            format a20
Column db_link          format a50
column username         format a20
column host             format a600
column created          format a40  
column Object_type      format a30
 select 
     (SELECT * FROM GLOBAL_NAME) server_name,
     a.owner,
     a.db_link,
     a.username,
     a.host,
     a.created,
     b.object_type    
 from dba_db_links a, dba_objects b
 where a.owner = b.owner and 
       a.db_link = b.object_name and  
       a.owner not in ('SYS','SYSTEM');

spool off

/* ---End DB_LINK---------------------------------------*/



/*  -- SEQUENCES ------------------------------------------*/
column servername       format a30
column owner            format a20
Column object_name      format a50
column last_ddl_time    format a40
column status           format a10
column Object_type      format a30
spool %VPATH%oracle_sequence_%DATABASE%.csv
rem @Query_Oracle_sequence_%DATABASE%.sql

   SELECT 
       (SELECT * FROM GLOBAL_NAME) server_name,
       a.owner,
       a.object_name,
       a.last_ddl_time,
       a.status,
       a.object_type
    FROM dba_objects a
    WHERE a.object_type = 'SEQUENCE'
    AND   a.owner NOT IN ('SYS', 'SYSTEM');

spool off

/* ---End SEQUENCES---------------------------------------*/


/*  -- VIEWS ------------------------------------------*/
column servername       format a30
column owner            format a20
Column view_name        format a50
column text             format a500
column Object_type      format a30
spool %VPATH%oracle_views_%DATABASE%.csv
select 
     (SELECT * FROM GLOBAL_NAME) server_name,
     a.owner,
     a.view_name,
     a.text_length,
     a.text,
     b.object_type
from 
    DBA_VIEWS a, dba_objects b
Where a.owner = b.owner and 
      a.view_name = b.object_name and 
      a.owner not in ( 'SYS' , 'SYSTEM' ) ;

spool off

/* ---END VIEWS---------------------------------------*/

exit