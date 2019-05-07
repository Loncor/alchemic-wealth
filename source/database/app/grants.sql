grant select, insert, delete on app.logs to prc;
grant select, insert, update, delete on app.jobs to prc;
grant select on app.session_seq to prc;
-- Grant to Unit Test user
grant select, delete on app.logs to tst;
grant select on app.jobs to tst;

grant EXECUTE on APP.NUMBER_VAR to PRC ;
grant EXECUTE on APP.NUMBER_VAR to TST ;

