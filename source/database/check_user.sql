set echo off
/************************************************************************
* Project      : Alchemic Wealth
* Description  : Ensure user is same as first input parameter. 
* Author(s)    : Stanley Wilson
* Copyright    : 2015, Stanley Wilson
* License      : MIT (https://opensource.org/licenses/MIT)
*/

set verify off
set feedback on
set escape on

--------------------------------------------
prompt "+++ Check for correct schema &1"
--------------------------------------------
whenever SQLERROR EXIT SQL.SQLCODE

begin
   if user != upper('&1') then
      raise_application_error( -20987, '!!! User '||user||' cannot run this script. User &1 was expected.' );
   end if;
end;
/

prompt You are connected to &1

whenever SQLERROR CONTINUE

--------------------------------------------
prompt Script check_user.sql Completed
--------------------------------------------
