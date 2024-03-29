#Steps for DMS

Prepare Oracle Database for CDC
```
as admin user

exec rdsadmin.rdsadmin_util.set_configuration('archivelog retention hours',24);
exec rdsadmin.rdsadmin_util.alter_supplemental_logging('ADD');
exec rdsadmin.rdsadmin_util.alter_supplemental_logging('ADD','PRIMARY KEY');

as hr user

select 'ALTER TABLE '||table_name||' ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;' from all_tables where owner = 'HR';
```

In SCT,

1. add source and target 
2. Create Mapping
3. Select HR -> Right Click -> Convert schema -> It shoud populate HR in destination
4. Select Schema in destination -> Apply to database

Login to Aurora PostgreSQL and check metadata is loaded?

```
postgres=> \dt hr.*
             List of relations
 Schema |     Name      | Type  |  Owner
--------+---------------+-------+----------
 hr     | countries     | table | postgres
 hr     | departments   | table | postgres
 hr     | employees     | table | postgres
 hr     | identity_tst  | table | postgres
 hr     | job_history   | table | postgres
 hr     | jobs          | table | postgres
 hr     | locations     | table | postgres
 hr     | regions       | table | postgres
 hr     | system_events | table | postgres
(9 rows)

postgres=> set search_path=hr;
SET
postgres=> select * from hr.jobs;
 job_id | job_title | min_salary | max_salary
--------+-----------+------------+------------
(0 rows)

postgres=>
```

In DMS,

1. DMS -> Subnet groups -> Create -> Name: pg-replication-subnet-group
2. Replication instances -> Create -> Name: pg-replication, Instance Class -> t3.medium
3. Create source endpoint -> Most of the details are auto populated and Test endpoint connection
4. Create target endpoint -> SSL Socket layer mode -> Require;  Most of the details are auto populated and Test endpoint connection
5. Select Source -> Schemas -> Refresh to populate schemas
6. Create migration task -> Task identifier - ora2pg -> Migration type - Migrate existing data and replicate ongoing change
   
## Verify
```
Source

SQL> select * from jobs where JOB_ID='AD_PRES';

JOB_ID     JOB_TITLE                           MIN_SALARY MAX_SALARY
---------- ----------------------------------- ---------- ----------
AD_PRES    President                                20080      40000

SQL> update  jobs set MAX_SALARY=300 where JOB_ID='AD_PRES';

1 row updated.

SQL> commit;

Commit complete.

SQL> EXEC rdsadmin.rdsadmin_util.switch_logfile;

PL/SQL procedure successfully completed.


Destination

postgres=> select * from hr.jobs where JOB_ID='AD_PRES';
 job_id  | job_title | min_salary | max_salary
---------+-----------+------------+------------
 AD_PRES | President |      20080 |      40000
(1 row)

postgres=>
postgres=>
postgres=> select * from hr.jobs where JOB_ID='AD_PRES';
 job_id  | job_title | min_salary | max_salary
---------+-----------+------------+------------
 AD_PRES | President |      20080 |        300
(1 row)
```




