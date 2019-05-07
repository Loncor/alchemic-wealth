spool create_users.txt
set echo on
/************************************************************************
* Project      : Alchemic Wealth
* Description  : Create all table and package schemas. 
* Author(s)    : Stanley Wilson
* Copyright    : 2015, Stanley Wilson
* License      : MIT (https://opensource.org/licenses/MIT)
*/

set verify off
set feedback on
set escape on

--------------------------------------------------------------------------
-- "+++ Info: Start changes"
--------------------------------------------------------------------------
whenever SQLERROR EXIT SQL.SQLCODE

--------------------------------------
create user app
  identified by apppaw
  default tablespace users
  temporary tablespace temp
  profile default
  account unlock;

grant create type to app;
grant create view to app;
grant create table to app;
grant create session to app;
grant create trigger to app;
grant create sequence to app;
grant unlimited tablespace to app;
alter user app quota unlimited on users;

--------------------------------------
create user fin
  identified by finpaw
  default tablespace users
  temporary tablespace temp
  profile default
  account unlock;

grant create type to fin;
grant create view to fin;
grant create table to fin;
grant create session to fin;
grant create trigger to fin;
grant create sequence to fin;
grant unlimited tablespace to fin;
alter user fin quota unlimited on users;
--------------------------------------
create user prp
  identified by prppaw
  default tablespace users
  temporary tablespace temp
  profile default
  account unlock;

grant create view to prp;
grant create table to prp;
grant create session to prp;
grant create trigger to prp;
grant create sequence to prp;
alter user prp quota unlimited on users;

--------------------------------------
create user stk
  identified by stkpaw
  default tablespace users
  temporary tablespace temp
  profile default
  account unlock;

grant create type to stk;
grant create view to stk;
grant create table to stk;
grant create session to stk;
grant create trigger to stk;
grant create sequence to stk;
alter user stk quota unlimited on users;

--------------------------------------
create user prc
  identified by prcpaw
  default tablespace users
  temporary tablespace temp
  profile default
  account unlock;

grant create type to prc;
grant create view to prc;
grant create table to prc;
grant create session to prc;
grant create trigger to prc;
grant create sequence to prc;
grant create procedure to prc;
grant create public synonym to prc;
alter user prc quota unlimited on users;

--------------------------------------
create user jsn
  identified by jsnpaw
  default tablespace users
  temporary tablespace temp
  profile default
  account unlock;

grant create type to jsn;
grant create view to jsn;
grant create table to jsn;
grant create session to jsn;
grant create trigger to jsn;
grant create sequence to jsn;
grant create procedure to jsn;
grant create public synonym to jsn;
alter user jsn quota unlimited on users;

--------------------------------------
create user tst
  identified by tstpaw
  default tablespace users
  temporary tablespace temp
  profile default
  account unlock;

grant create type to tst;
grant create view to tst;
grant create table to tst;
grant create session to tst;
grant create trigger to tst;
grant create sequence to tst;
grant create procedure to tst;
grant create public synonym to tst;
alter user tst quota unlimited on users;

--------------------------------------------------------------------------
prompt Script Completed
--------------------------------------------------------------------------

set echo off
spool off
