prompt Build complete Loncor Eye System
prompt ================================
set define on
define dbase=&1

--pause Partial re-build of the &&dbase database?

prompt DataBase &&dbase chosen
prompt Connect SYS
prompt ==============
set define on
connect sys/syspaw@&&dbase as sysdba
@@check_user sys

--@@sys/create_users.sql
@@sys/grants.sql

-- app ----------------------------------------------------------------
set define on
connect app/apppaw@&&dbase
@@check_user app

@@app/grants.sql
--@@app/cr_sequences.sql
--@@app/cr_jobs.sql
--@@app/cr_logs.sql

whenever SQLERROR continue

spool off
-- fin ----------------------------------------------------------------
set define on
connect fin/finpaw@&&dbase
@@check_user fin

whenever SQLERROR continue

spool off
-- stk ----------------------------------------------------------------
set define on
connect stk/stkpaw@&&dbase
@@check_user stk

--@@stk/misc/grants_and_synonyms.sql

-- prp ----------------------------------------------------------------
connect prp/prppaw@&&dbase
@@check_user prp

--@@prp

-- prc ----------------------------------------------------------------
set define on
connect prc/prcpaw@&&dbase
@@check_user prc

set define off

prompt +++ Info : Compiling std package spec
prompt +++++++++++++++++++++++++++++++++++++++++++++++++
@@prc/typ.pks
@@prc/std.pks

prompt +++ Info : Compiling functions and procedures
prompt +++++++++++++++++++++++++++++++++++++++++++++++++

--@@prc/pipe_dates.fnc
--@@prc/get_graph_data_via_id.prc
show errors

prompt +++ Info : Compiling package specs
prompt +++++++++++++++++++++++++++++++++++++++++++++++++

--@@prc/assert.pks
--@@prc/util.pks
show errors
@@prc/task.pks
show errors
--@@prc/uweb.pks
--@@prc/account.pks
show errors

--@@prc/categorise_transactions.pks
--@@prc/fin_html.pks
show errors
--@@prc/stock.pks
show errors
--@@prc/ut_stock.pks
show errors
--@@prc/web_site_builder.pks
--@@prc/json_util.pks
--@@prc/web_site_data_builder.pks
show errors

--@@prc/web_graph.pks
show errors

prompt +++ Info : Compiling package bodies
prompt +++++++++++++++++++++++++++++++++++++++++++++++++

--@@prc/assert.pkb
@@prc/task.pkb
show errors
--@@prc/util.pkb
--@@prc/uweb.pkb
show errors
--@@prc/account.pkb
show errors
--@@prc/categorise_transactions.pkb
show errors
--@@prc/fin_html.pkb
show errors
--@@prc/stock.pkb
show errors

--@@prc/ut_stock.pkb
show errors
--@@prc/web_site_builder.pkb
show errors
--@@prc/json_util.pkb
--@@prc/web_site_data_builder.pkb
show errors

--@@prc/web_graph.pkb
show errors

--@@prc/get_json_data_via_id.prc
show errors


-- jsn ----------------------------------------------------------------
set define on
connect jsn/jsnpaw@&&dbase
@@check_user jsn


-- tst ----------------------------------------------------------------
set define on
connect tst/tstpaw@&&dbase
@@check_user tst

prompt Build ut_task.pks
@@tst/ut_task.pks
show errors

prompt Build ut_task.pkb
@@tst/ut_task.pkb
show errors

pause Hit any key

quit
