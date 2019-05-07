CREATE OR REPLACE PACKAGE prc.task is
/**
This package allows the logging of specified messages to the app.logs table. It requires the <strong>function/procedure name</strong> 
and the <strong>message severity</strong>. It is primarily used for batch or background jobs. The following features are include:-
<ul>
<li>If a fatal (or higher severity) message is issued the oracle stack trace and SQL error message are logged</li> 
<li>The logged message is added to the <strong>report</strong> table if the severity level is <em>report</em>, <em>fatal</em> or <em>disaster</em></li>
<li>In the even of an exception recent debug and trace messages are add to the app.logs table</li>
</ul>

Author: Stanley J A Wilson
*/
   -------------------------------------------------------------------------------------------------
   --||                       public constants                                                  ||--
   -------------------------------------------------------------------------------------------------
   -- Message severity levels
   sev_forced         constant app.logs.severity%type        := 0;  -- Used to force a message onto the logs table.
   sev_abort          constant app.logs.severity%type        := 1;  -- Used to raise exception adds stack trace and related information, optionally log message, normally used in the when others exception (for batch processing)
   sev_fatal          constant app.logs.severity%type        := 2;  -- Used to log message and raise exception,
   sev_issue          constant app.logs.severity%type        := 3;  -- Used to log and issue that needs attention but does not abort the process.
   sev_report         constant app.logs.severity%type        := 4;  -- Used to report on the log the job progress.
   sev_trace          constant app.logs.severity%type        := 6;  -- Used for tracing only ends up on the logs table when set_log_level is set to this severity.
   sev_debug          constant app.logs.severity%type        := 7;  -- Used for debugging only ends up on the logs table when set_log_level is set to this severity.

   -------------------------------------------------------------------------------------------------
   --||                       public procedures and function                                    ||--
   -------------------------------------------------------------------------------------------------
   /************************************************************************************************
   * Return the session_id of the current session. 
   *
   * @return Session ID.
   */
   function get_session_id return app.logs.session_id%type;
      
   /**************************************************************************************
   * Return the level of logging of the current session. 
   *
   * @return Logging level (aka message severity level) - e.g. sev_report.
   */
   function get_log_level return app.logs.severity%type;
   
   /****************************************************************************************************
   * Alters the level of logging for the current session.  The lower the number the more 
   * important it is - see "Message severity levels" in the package specification.
   *
   * @param ii_log_level     (in) Logging level (aka message severity level) - default sev_report.
   */
   procedure set_log_level(
      ii_log_level            in   app.logs.severity%type := sev_report);

   /***********************************************************************************************************
   * Clear all recent messages from the "Recent Message" array and set the Array Position to standard position.
   */
   procedure clear_recent_messages;

   /**********************************************************************************************
   * Call this routine if this message must be logged at the highest severity without raising 
   * and error. This will always be added logs table regardless of the log level set.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.  
   */
   procedure log_forced(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type );
   
   /**********************************************************************************************
   * Call this routine if an error needs to be raised (thrown). The message and Stack trace will be 
   * saved to the report table and on the log table. Normally use in the 'when others' exception handler.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Resrticted to maximum varchar2 length on table.  
   */
   procedure log_abort(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type );

   /**************************************************************************************
   * Fatal, this message will be always be saved to the report table and on the log table.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Resrticted to maximum varchar2 length on table.  
   */
   procedure log_fatal(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type);

   /**************************************************************************************
   * Issue, this message will be always be saved to the report table and on the log table.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Resrticted to maximum varchar2 length on table.  
   */
   procedure log_issue(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type);

   /**************************************************************************************
   * Report, this message will be always be saved to the report table. It will be saved on the 
   * log table if the correct log_level is set.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Resrticted to maximum varchar2 length on table.    
   */
   procedure log_report(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type);

   /**************************************************************************************
   * Trace, this message should be used for tracing. It will be saved on the log table if the 
   * correct log_level is set.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Resrticted to maximum varchar2 length on table.    
   */
   procedure log_trace(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type );

   /**************************************************************************************
   * Debug, this message should be used for debugging. It will be saved on the log table if the 
   * correct log_level is set.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Resrticted to maximum varchar2 length on table.    
   */
   procedure log_debug(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type );

   /**************************************************************************************
   * Set job to a READY status. Can only be set when the job is new or the run_status is
   * either FAILED or ISSUES. If job does not already exist it will be created.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_description   (in) Description of job. Restricted to maximum varchar2 length on table.    
   */
   procedure set_to_ready(
      is_program_name            in   app.jobs.program_name%type,
      is_description             in   app.jobs.description%type := null);

   /**************************************************************************************
   * Job started, the jobs table is updated if the job has not started or not finished. 
   * A job started message is also logged. 
   *
   * @param is_program_name  (in) A symbolic name. This should match the dba_scheduler_programs.program_name if used.
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.    
   */
   procedure started(
      is_program_name         in   typ.obj_name := null,
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type := null );

   /**************************************************************************************
   * Job completed, the jobs table is updated to completed. If the job was not started an
   * error will be raised. A job completed message is also logged. 
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.    
   */
   procedure completed(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type := null );

   /**************************************************************************************
   * Job failed, the jobs table is updated to failed. If the job was not started an
   * error will be raised. A job completed message is also logged. 
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.    
   */
   procedure failed(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type := null );

   /**********************************************************************************************
   * Set the application date. This is similar to sysdate but it can be changed. It is used primarily 
   * for "back testing". The application date is normally set to the sysdate unless it is set here.
   * The application date is always stored on the log and report tables.
   *
   * @param id_datesys (in) Application date
   */
   procedure set_datesys( id_datesys        in date );

   /**********************************************************************************************
   * Get the application date. This is similar to sysdate but it can be changed. It is used primarily 
   * for "back testing".
   *
   * @return Application date
   */
   function get_datesys 
   return date;
end task;
/
