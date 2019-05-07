drop table app.logs;

create table app.logs
(
  session_id integer not null enable, 
  message_seq integer not null enable, 
  timestamp_dt date not null enable, 
  datesys date not null enable,   
  severity integer not null enable, 
  func_name varchar2(200 byte) not null enable, 
  message varchar2(4000 byte) not null enable, 
  user_name varchar2(30 byte) default user not null enable,
  CONSTRAINT ALG_PK PRIMARY KEY (SESSION_ID, MESSAGE_SEQ)
)
tablespace users;
  
COMMENT ON COLUMN app.logs.session_id IS 'Unique sequential number assigned to each new oracle session where the job package is called.';
COMMENT ON COLUMN app.logs.message_seq IS 'Sequential number starting at 1 for each log message within each oracle session. Note: not all logged messages appear on the log table as some are ignored.';
COMMENT ON COLUMN app.logs.timestamp_dt IS 'Date and time the message was logged.';
COMMENT ON COLUMN app.logs.datesys IS 'Alternative system date that can be changed via the job package. It is initally set to the oracle system date (excluding the time element)';
COMMENT ON COLUMN app.logs.severity IS 'Severity level for the log message.';
COMMENT ON COLUMN app.logs.func_name IS 'Function or procedure name assigned to message.';
COMMENT ON COLUMN app.logs.message IS 'Message to be logged.';
COMMENT ON COLUMN app.logs.user_name IS 'Name of database user that logged the message.';

