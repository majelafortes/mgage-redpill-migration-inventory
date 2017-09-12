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

clear break
clear comp
clear col

set newpage 0; 
set echo off; 
set feedback off; 
set heading off; 
set wrap on;
set pagesize 0;
set linesize 600
set trimspool on;
set colsep ,


alter session set nls_date_format='yyyy/mm/dd'


/*  -- Tables and Parttion Tables---------------------*/

spool %VPATH%oracle_table_%DATABASE%.csv

  SELECT 
       substr(Trim(c.global_name),1,40) global_name,
       a.owner, 
       a.table_name,
       a.last_analyzed,
       Round(SUM (b.bytes) / 1048576,1) size_mb,
       a.num_rows,
       b.segment_type
  FROM dba_tables a, dba_segments b  , global_name c
  WHERE     a.table_name = b.segment_name
       AND a.owner = b.owner
       AND a.owner NOT IN ('SYS', 'SYSTEM')
       AND b.segment_type = 'TABLE' or  b.segment_type = 'TABLE PARTITION'
  GROUP BY a.owner,
           a.table_name,
           a.num_rows,
           a.last_analyzed,
           b.segment_type,
           substr(Trim(c.global_name),1,40)
  Order by 1,2;

spool off

/* ---End Tables---------------------------------------*/


/*  -- Synonym ------------------------------------------*/

spool %VPATH%oracle_synonym_%DATABASE%.csv

  select 
     substr(Trim(c.global_name),1,40) global_name,
     a.owner,
     a.synonym_name,
     a.table_owner,
     a.table_name,
     a.db_link,
     b.object_type
  from dba_synonyms a , dba_objects b, , global_name c
  where a.owner = b.owner and 
        a.synonym_name = b.object_name and
        a.owner NOT IN ('SYS', 'SYSTEM') and
        a.table_owner != 'SYS'
  Order by 1,2;

spool off

/* ---End Synonyn---------------------------------------*/


/*  -- Procedures ------------------------------------------*/
spool %VPATH%oracle_procedure_%DATABASE%.csv

   SELECT
      substr(Trim(c.global_name),1,40) global_name,
       a.owner,
       b.object_name,
       a.last_ddl_time,
       a.status,
       a.object_type
   FROM dba_objects a, dba_procedures b, global_name c
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

 select 
     substr(Trim(c.global_name),1,40) global_name,
     a.owner,
     a.db_link,
     a.username,
     a.host,
     a.created,
     b.object_type    
 from dba_db_links a, dba_objects b, global_name c
 where a.owner = b.owner and 
       a.db_link = b.object_name and  
       a.owner not in ('SYS','SYSTEM');
spool off
/* ---End DB_LINK---------------------------------------*/




exit