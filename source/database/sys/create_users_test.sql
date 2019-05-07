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

--------------------------------------------

@../check_user.sql SYS

--------------------------------------------------------------------------
-- "+++ Info: Start changes"
--------------------------------------------------------------------------
whenever SQLERROR EXIT SQL.SQLCODE

--------------------------------------------------------------------------
prompt Script create_users.sql Completed
--------------------------------------------------------------------------

set echo off
spool off
