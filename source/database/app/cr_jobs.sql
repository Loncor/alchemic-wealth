DROP TABLE app.jobs;

CREATE TABLE app.jobs 
(
  PROGRAM_NAME VARCHAR2(30) NOT NULL, 
  SESSION_ID INTEGER,
  START_DT DATE, 
  END_DT DATE,
  RUN_STATUS  VARCHAR2(20) NOT NULL, 
  DESCRIPTION VARCHAR2(4000), 
  CONSTRAINT AJB_PK PRIMARY KEY (PROGRAM_NAME) 
);

COMMENT ON COLUMN app.jobs.program_name IS 'Symbolic program name assigned to this job. Should match the program name on the dba_scheduler_programs table if used otherwise any unique name shold be used.';
COMMENT ON COLUMN app.jobs.session_id IS 'Session ID set from within the app.job package unique to the oracle session.';
COMMENT ON COLUMN app.jobs.start_dt IS 'Time and Date when the app.job.started was called.';
COMMENT ON COLUMN app.jobs.end_dt IS 'Time and Date when the app.job.completed, .fatal or .abort was called.';
COMMENT ON COLUMN app.jobs.run_status IS 'Most recent status of the job, normally set within the app.job package.';
COMMENT ON COLUMN app.jobs.description IS 'Job description for this program name if required.';
  
ALTER TABLE app.jobs
ADD CONSTRAINT ajb_program_name_ck
  CHECK (program_name = upper(program_name));

ALTER TABLE app.jobs
ADD CONSTRAINT ajb_run_status_ck
  CHECK (run_status IN ('LOCKED','READY','STARTED','ISSUES','FAILED','COMPLETED'));
