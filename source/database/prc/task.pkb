create or replace package body prc.task is
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
   --||                       private types, constants and variables.                           ||--
   -------------------------------------------------------------------------------------------------
   -- Types
   type pat_logs     is varray(100) of app.logs%rowtype;
   -- Constants
   psc_package_name   constant typ.obj_name := lower($$plsql_unit);
   psc_package_prefix constant typ.obj_name := psc_package_name||'.';
   -- Booleans
   issues_found               boolean := false;
   -- Variables
   pd_datesys                 date           := trunc(sysdate);
   pi_session_id              pls_integer;
   pi_message_seq             pls_integer    := 0;
   pi_log_level               pls_integer    := sev_report; 
   -- Recent Log Array 
   pa_recent_messages         pat_logs       := pat_logs();
   pi_array_size              pls_integer    := 100;
   pi_array_pos               pls_integer    := 1;
   
   -------------------------------------------------------------------------------------------------
   --||                       Procedures and Functions.                                         ||--
   -------------------------------------------------------------------------------------------------
   /************************************************************************************************
   * Return the session_id of the current session. 
   *
   * @return Session ID.
   */
   function get_session_id return app.logs.session_id%type
   is
   begin
      return pi_session_id;
   end get_session_id;

   /************************************************************************************************
   * Return the level of logging of the current session. 
   *
   * @return Logging level (aka message severity level) - e.g. sev_report.
   */
   function get_log_level return app.logs.severity%type
   is
   begin
      return pi_log_level;
   end get_log_level;

   /***********************************************************************************************************
   * Clear all recent messages from the "Recent Message" array and set the Array Position to standard position.
   */
   procedure clear_recent_messages is
   begin
      pa_recent_messages.delete;
      pa_recent_messages.extend(pi_array_size);
      pi_array_pos := 1;
   end clear_recent_messages;  
         
   /************************************************************************************************************
   * Store message in the "recent message" array. This array is only a specific size and so when new message is 
   * added the oldest message is overwritten by it. Then the array pointer is moved to next cell which will now 
   * be oldest message.
   *
   * @param ir_glg (in) the app.logs record type
   */   
   procedure store_recent_message( ir_glg      in          app.logs%rowtype ) 
   is
   begin
      pa_recent_messages(pi_array_pos) := ir_glg;

      -- Shift the array location to the next record (which will be the oldest in the record set)  
      if pi_array_pos < pi_array_size then
         pi_array_pos := pi_array_pos + 1;
      else
         pi_array_pos := 1;
      end if;      
   end store_recent_message;  

   /************************************************************************************************************
   * Insert all the recent messages into the log table. Essentially this is to log possibly important debug or 
   * trace app.logs when a fatal error happens.
   */
   procedure insert_recent_messages is
   begin
      if pi_array_pos between pa_recent_messages.first and pa_recent_messages.last then
         -- Pass 1 - Oldest record to end of array
         for li_record_no in pi_array_pos..pa_recent_messages.last loop
            if pa_recent_messages(li_record_no).session_id is not null then
               insert into app.logs values pa_recent_messages(li_record_no);
            end if;
         end loop;

         -- Pass 2 - Start of Array to newest record
         for li_record_no in pa_recent_messages.first..pi_array_pos - 1 loop
            if pa_recent_messages(li_record_no).session_id is not null then
               insert into app.logs values pa_recent_messages(li_record_no);
            end if;
         end loop;
      end if;
      
      -- Call Clear Recent Messages
      clear_recent_messages;
   end insert_recent_messages;  

   /**********************************************************************************************************
   * Writes a message log table. Requires a procedure or function name. Suggest using script name if it is
   * an anonymous block. Note: the program name is always converted to lower case.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table  
   * @param ii_severity      (in) Message severity level
   */
   procedure ins_log(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type, 
      ii_severity             in   app.logs.severity%type)
   is
      pragma autonomous_transaction;
      --
      fr_alg        app.logs%rowtype;
   begin
      -- Contract Fulfillment - checks
      -- Return if any of the input fields are null 
      if ii_severity is null 
      or is_func_name is null
      or is_message is null then
         return;
      end if;

      -- Set up data
      pi_message_seq := pi_message_seq + 1;
      -- Set up record
      fr_alg.timestamp_dt   := sysdate;
      fr_alg.user_name      := user;
      fr_alg.session_id     := pi_session_id;
      fr_alg.message_seq    := pi_message_seq;
      fr_alg.severity       := ii_severity;
      fr_alg.func_name  := substr(lower(is_func_name),1,100);
      fr_alg.message        := substr(is_message,1,4000);
      fr_alg.datesys        := pd_datesys;
      
      -- Log section : adds message to log table.
      if ii_severity <= pi_log_level then
         -- If fatal or disaster then insert recent unlogged messages
         if ii_severity in ( sev_fatal, sev_abort ) then      
            insert_recent_messages;      
         end if;

         insert into app.logs values fr_alg;      
      else
         store_recent_message( fr_alg );
      end if;
      --
      commit;
   end ins_log;   

   /************************************************************************************************
   * Alters the level of logging for the current session.  The lower the number the more 
   * important it is - see "Message severity levels" in the package specification.
   *
   * @param ii_log_level (in) Logging level (aka message severity level) - default sev_report.
   */
   procedure set_log_level(
      ii_log_level       in   app.logs.severity%type := sev_report)
   is
      fsc_func_name  constant typ.obj_name := 'set_log_level';
   begin
      if ii_log_level = pi_log_level then
         ins_log(psc_package_prefix||fsc_func_name,'Logging level of '||pi_log_level||' was retained', sev_forced);
      elsif ii_log_level > sev_forced then
         ins_log(psc_package_prefix||fsc_func_name,'Logging level changing from '||pi_log_level||' to '||ii_log_level, sev_forced);
         pi_log_level := ii_log_level;
      else
         ins_log(psc_package_prefix||fsc_func_name,'Attempt to change current log level '||pi_log_level||' to '||ii_log_level||' has been rejected! '||
                          'Messages with log level less or equal to '||sev_forced||' must always be logged.', sev_forced);
      end if;
   end set_log_level;

   /**********************************************************************************************
   * Call this routine if this message must be logged at the highest severity without raising 
   * and error. This will always be added logs table regardless of the log level set.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.  
   */
   procedure log_forced(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type ) is
   begin
      ins_log( is_func_name, is_message, sev_forced );
   end log_forced;

   /**********************************************************************************************
   * Call this routine if an error needs to be raised. The message and Stack trace will be 
   * saved to the report table and on the log table. 
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.  
   */
   procedure log_abort(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type ) is
   begin
      ins_log(is_func_name, dbms_utility.format_error_stack()||'::'||dbms_utility.format_error_backtrace()||'::'||dbms_utility.format_call_stack||'::'||is_message, sev_abort);
      raise_application_error( -20929, is_message );
   end log_abort;

   /**************************************************************************************
   * Fatal, this message will be always be saved to the report table and on the log table.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.  
   */
   procedure log_fatal(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type) is
   begin      
      ins_log(is_func_name, is_message, sev_fatal);
      raise_application_error( -20928, is_message );
   end log_fatal;

   /**************************************************************************************
   * Issue, this message will be always be saved to the report table and on the log table.
   * The issue indicator will be set checking later if the task.completed procedure is
   * called.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.  
   */
   procedure log_issue(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type) is
   begin
      -- Set issues indicator
      issues_found := true;
      ins_log(is_func_name, is_message, sev_issue);
   end log_issue;

   /**************************************************************************************
   * Report, this message will be always be saved to the report table. It will be saved on the 
   * log table if the correct log_level is set.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.    
   */
   procedure log_report(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type)
   is
   begin
      ins_log(is_func_name, is_message, sev_report);                                    
   end log_report;

   /**************************************************************************************
   * Trace, this message should be used for debugging. It will be saved on the log table if the 
   * correct log_level is set.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.    
   */
   procedure log_trace(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type ) is
   begin
      ins_log( is_func_name, is_message, sev_trace );
   end log_trace;

   /**************************************************************************************
   * Debug, this message should be used for debugging. It will be saved on the log table if the 
   * correct log_level is set.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.    
   */
   procedure log_debug(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type ) is
   begin
      ins_log( is_func_name, is_message, sev_debug );
   end log_debug;

   /**************************************************************************************
   * Set job to a READY status. Can only be set when the job is new or the run_status is
   * either FAILED or ISSUES. If job does not already exist it will be created.
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_description   (in) Description of job. Restricted to maximum varchar2 length on table.    
   */
   procedure set_to_ready(
      is_program_name            in   app.jobs.program_name%type,
      is_description             in   app.jobs.description%type := null) is
      -- Constants
      fsc_func_name  constant typ.proc_path := psc_package_prefix||'set_to_ready';
      -- Variables
      fs_description    	   app.jobs.description%type;
      fs_run_status            app.jobs.run_status%type;
   begin
      <<check_run_status>>
      begin
         select run_status, description 
         into fs_run_status, fs_description
           from app.jobs
          where program_name = is_program_name;
      exception
         when no_data_found then 
            insert into app.jobs ( program_name, run_status, description, session_id ) 
            values ( is_program_name, 'READY', nvl(is_description, 'None'), pi_session_id );
            return;
      end check_run_status;
      
      if fs_run_status in ('LOCKED', 'FAILED', 'ISSUES') then
         update app.jobs 
            set run_status = 'READY',
                description = nvl(is_description, fs_description),
                session_id = pi_session_id
          where program_name = is_program_name;
      else
         log_fatal(fsc_func_name, 'The run_status can only be set to READY from LOCKED, FAILED or ISSUES not '||fs_run_status);
      end if;
   end set_to_ready;

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
      is_message              in   app.logs.message%type := null ) is
      --
      fs_message         app.logs.message%type := 'Started';
      fs_program_name    typ.obj_name;
      fs_run_status      app.jobs.run_status%type;
      fd_start_dt        app.jobs.start_dt%type;
      fd_end_dt          app.jobs.end_dt%type;
      fs_called_dt       date := sysdate;
   begin
      if is_message is not null then
         fs_message := fs_message||':'||is_message;
      end if;
      --
      ins_log( is_func_name, fs_message, sev_report );
      --
      if is_program_name is null then
         log_fatal(is_func_name, 'Input parameter is_program_name in job.started must not be null.');
      else
         fs_program_name := lower(is_program_name);
      end if;       
      --
      <<get_job_info>>
      begin
         select start_dt, end_dt, run_status into fd_start_dt, fd_end_dt, fs_run_status
           from app.jobs
          where program_name = fs_program_name;
      exception
         when no_data_found then
            log_fatal(is_func_name, 'A record was expected to be on app.jobs where program_name = "'||fs_program_name
                  ||'" create record before a re-run is attempted.');
         when too_many_rows then
            log_fatal(is_func_name, 'Only one row was expected on app.jobs where program_name = "'||fs_program_name
                  ||'" check why there is more than one record.');
      end get_job_info;

      --
      if fs_run_status = 'STARTED' then
         log_fatal(is_func_name, 'It looks like program named '||fs_program_name
                  ||' was started but has not finished because the run_status='||fs_run_status 
                  ||'. Please check the job is not running then repair record on app.jobs where program_name='
                  ||fs_program_name||'.');
      elsif ( fd_start_dt is not null and fd_end_dt is null ) then
         log_fatal(is_func_name, 'It looks like program named '||fs_program_name
                  ||' was started but has not finished because the start_dt is set and the end_dt is not set.'
                  ||' Please check the job is not running then repair record on app.jobs where program_name='
                  ||fs_program_name||'.');
      elsif fs_run_status in ('LOCKED','ISSUES','FAILED') then 
         log_fatal(is_func_name, 'This program named '||fs_program_name
                  ||' cannot be started because the run_status='||fs_run_status 
                  ||'. Please find out why the job did not complete successfully. When fixed set the run_status on this record to READY or COMPLETED before starting this job where program_name='
                  ||fs_program_name||'.');
      end if; 

      --
      update app.jobs
         set start_dt = fs_called_dt, 
             end_dt = null, 
             session_id = pi_session_id,
             run_status = 'STARTED'
       where program_name = fs_program_name;
      --
      if sql%rowcount > 1 then
         log_fatal(is_func_name, 'Only one row was expected to updated on app.jobs where program_name = "'||fs_program_name
                  ||'" check why there is more than one record.');
      elsif sql%rowcount = 0 then
         log_fatal(is_func_name, 'A record was expected to updated on app.jobs where program_name = "'||fs_program_name
                  ||'" create record before a re-run is attempted.');
      end if;   
      -- Reset issues indicator
      issues_found := false;
   end started;

   /**************************************************************************************
   * Job completed, the jobs table is updated to completed. If the job was not started an
   * error will be raised. A job completed message is also logged. 
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.    
   */
   procedure completed(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type := null ) is
      --
      fs_message         app.logs.message%type := 'Completed';
      fs_run_status      app.jobs.run_status%type := 'COMPLETED';
      fs_called_dt       date := sysdate;
   begin
      if is_message is not null then
         fs_message := fs_message||':'||is_message;
      end if;
      --
      if issues_found then
         fs_run_status := 'ISSUES';
         ins_log( is_func_name, fs_message, sev_issue );
      else
         ins_log( is_func_name, fs_message, sev_report );
      end if;
      --
      update app.jobs
         set end_dt = fs_called_dt,
             run_status = fs_run_status
       where session_id = pi_session_id;
      --
      if sql%rowcount > 1 then
         log_fatal(is_func_name, 'Only one row was expected to updated on app.jobs where session_id = '||pi_session_id
                  ||' check why there is more than one record.');
      end if;   
   end completed;

   /**************************************************************************************
   * Job failed, the jobs table is updated to failed. If the job was not started an
   * error will be raised. A job completed message is also logged. 
   *
   * @param is_func_name     (in) Use the procedure name and prefix with the package name
   * @param is_message       (in) Logging message. Restricted to maximum varchar2 length on table.    
   */
   procedure failed(
      is_func_name            in   app.logs.func_name%type,
      is_message              in   app.logs.message%type := null ) is
      --
      fs_message         app.logs.message%type := 'Failed';
      fs_called_dt       date := sysdate;
   begin
      if is_message is not null then
         fs_message := fs_message||':'||is_message;
      end if;
      --
      ins_log( is_func_name, fs_message, sev_fatal );
      --
      update app.jobs
         set end_dt = fs_called_dt,
             run_status = 'FAILED'
       where session_id = pi_session_id;
      --
      if sql%rowcount > 1 then
         log_fatal(is_func_name, 'Only one row was expected to updated on app.jobs where session_id = '||pi_session_id
                  ||' check why there is more than one record.');
      end if;   
   end failed;

   /**********************************************************************************************
   * Set the application date. This is similar to sysdate but it can be changed. It is used primarily 
   * for "back testing". The application date is normally set to the sysdate unless it is set here.
   * The application date is always stored on the log and report tables.
   *
   * @param id_datesys (in) Application date
   */
   procedure set_datesys( id_datesys        in date ) is
   begin
      pd_datesys := id_datesys;
   end set_datesys;

   /**********************************************************************************************
   * Get the application date. This is similar to sysdate but it can be changed. It is used primarily 
   * for "back testing".
   *
   * @return Application date
   */
   function get_datesys
   return date is
   begin
      return pd_datesys;
   end get_datesys;
begin
   /*****************************************/
   /* Initialise data and collections.      */
   /*****************************************/
   -- Get new session 
   select app.session_seq.nextval into pi_session_id from dual;

   -- Call Clear Recent Messages
   clear_recent_messages;

   set_log_level;  
end task;
/

