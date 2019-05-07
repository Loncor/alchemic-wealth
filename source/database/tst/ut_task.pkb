create or replace package body ut_task as

   -- Constants
   psc_package_name   constant typ.obj_name := lower($$plsql_unit);
   psc_package_prefix constant typ.proc_path := psc_package_name||'.';

   -------------------------------------------------------------------------------------------------
   --||                       Procedures and Functions.                                         ||--
   -------------------------------------------------------------------------------------------------
   procedure beforeall is
      fsc_func_name  constant typ.proc_path := psc_package_prefix||'beforeall';
   begin
      -- Set Up
      dbms_output.put_line(fsc_func_name||' Setup');
      delete from app.logs where user_name = 'TST';
      dbms_output.put_line(fsc_func_name||' SessionID='||to_char(task.get_session_id)||' delete count='||sql%rowcount);
      commit;
   end beforeall;

   procedure non_exception_severities is
      fsc_func_name  constant typ.proc_path := psc_package_prefix||'non_exception_severities';
      --
      fc_actual               sys_refcursor;  
      fc_expected             sys_refcursor;
      fa_data                 app.number_var := app.number_var( task.sev_forced, task.sev_issue, task.sev_report, task.sev_trace, task.sev_debug );
      fs_message_prefix       app.logs.message%type := 'test severity=';    
      --
      cursor fc_non_exception_severities is
         select column_value severity
           from TABLE( cast( fa_data as app.number_var ) ) sev 
          order by severity;      
   begin
     -- Main Test
     task.set_log_level(task.sev_debug);
     for r_sev in fc_non_exception_severities loop
        case r_sev.severity
           when task.sev_forced then 
              task.log_forced(fsc_func_name,fs_message_prefix||r_sev.severity);
           when task.sev_issue then 
              task.log_issue(fsc_func_name,fs_message_prefix||r_sev.severity);
           when task.sev_report then 
              task.log_report(fsc_func_name,fs_message_prefix||r_sev.severity);
           when task.sev_trace then 
              task.log_trace(fsc_func_name,fs_message_prefix||r_sev.severity);
           when task.sev_debug then 
              task.log_debug(fsc_func_name,fs_message_prefix||r_sev.severity);
        end case;
     end loop;

     -- Validation of data on logs table
     open fc_actual for select session_id, 
                               severity, 
                               func_name, 
                               message, 
                               user_name 
                          from app.logs 
                         where session_id = task.get_session_id
                           and func_name = fsc_func_name
       order by severity;
     
     open fc_expected 
        for select task.get_session_id session_id,
                   column_value severity,	
                   fsc_func_name func_name,	
                   fs_message_prefix||column_value message, 
                   user user_name
       from TABLE( cast( fa_data as app.number_var ) ) sev 
      order by severity; 
   
     ut.expect(fc_actual).to_equal(fc_expected); 
   end non_exception_severities;

   procedure log_issue is
      fsc_func_name  constant typ.proc_path := psc_package_prefix||'log_issue';
      --
      fs_error_text           app.logs.message%type := 'Error text for issue';
      fc_expected             sys_refcursor;
      fc_actual               sys_refcursor;      
   begin
     -- Main Test
     task.log_issue(fsc_func_name, fs_error_text);

     -- Validation of data on logs table
     open fc_actual for select session_id, severity, func_name, message, user_name 
        from app.logs 
       where session_id = task.get_session_id
         and func_name = fsc_func_name;
         
     open fc_expected for select task.get_session_id session_id, 
                                 task.sev_issue severity,	
                                 fsc_func_name func_name,	
                                 fs_error_text message, user user_name 
        from dual;
   
     ut.expect(fc_actual).to_equal(fc_expected); 
   end log_issue;

   procedure log_abort is
      fsc_func_name  constant typ.proc_path := psc_package_prefix||'log_abort';
      --
      fs_error_text           app.logs.message%type := 'Error text for abort';
      fc_expected             sys_refcursor;
      fc_actual               sys_refcursor;      
   begin
     -- Main Test
     <<do_abort>>
     begin
        task.log_abort(fsc_func_name, fs_error_text);
        ut.fail('An error should have been raised and caught.');
     exception
        when std.task_abort then
           -- Validation of data on logs table
           open fc_actual for select session_id, severity, func_name, user_name 
                                from app.logs 
                               where session_id = task.get_session_id
                                 and func_name = fsc_func_name
                                 and message like '%PL/SQL Call Stack%'||fs_error_text;
         
           open fc_expected for select task.get_session_id session_id, 
                                       task.sev_abort severity,	
                                       fsc_func_name func_name,	
                                       user user_name 
                                  from dual;
   
           ut.expect(fc_actual).to_equal(fc_expected);
      end do_abort; 
   end log_abort;

   procedure log_fatal is
      fsc_func_name  constant typ.proc_path := psc_package_prefix||'log_fatal';
      --
      fs_error_text           app.logs.message%type := 'Error text for fatal';
      fc_expected             sys_refcursor;
      fc_actual               sys_refcursor;      
   begin
     -- Main Test
     <<do_fatal>>
     begin
        task.log_fatal(fsc_func_name, fs_error_text);
        ut.fail('An error should have been raised and caught.');
     exception
        when std.task_fatal then
           -- Validation of data on logs table
           open fc_actual for select session_id, severity, func_name, message, user_name 
                                from app.logs where session_id = task.get_session_id
                                 and func_name = fsc_func_name;
         
           open fc_expected for select task.get_session_id session_id, 
                                       task.sev_fatal severity,	
                                       fsc_func_name func_name,	
                                       fs_error_text message, 
                                       user user_name 
                                  from dual;
   
           ut.expect(fc_actual).to_equal(fc_expected);
      end do_fatal; 
   end log_fatal;

   procedure set_to_ready is
      fsc_func_name  constant typ.proc_path := psc_package_prefix||'set_to_ready';
      --
      fsc_program_name constant typ.proc_path := 'test_set_to_ready';
      --      
      fc_expected             sys_refcursor;
      fc_actual               sys_refcursor;      
   begin
     -- Set up jobs record
     task.set_to_ready(fsc_program_name);

     -- Validation of data on jobs table
     open fc_actual for select program_name, 
                               session_id,
                               to_char(start_dt,'dd mm yyyy hh24') start_dt_char,
                               to_char(end_dt,'dd mm yyyy hh24') end_dt_char,
                               run_status,
                               description
        from app.jobs 
       where session_id = task.get_session_id
         and program_name = fsc_program_name;
         
     open fc_expected for select fsc_program_name 	program_name,
                                 task.get_session_id session_id, 
                                 --to_char(sysdate,'dd mm yyyy hh24') start_dt_char,
                                 null start_dt_char,
                                 null end_dt_char,
                                 'READY' run_status,
                                 'None' description 
        from dual;

     ut.expect(fc_actual).to_equal(fc_expected); 
   end set_to_ready;

   procedure started is
      fsc_func_name  constant typ.proc_path := psc_package_prefix||'started';
      --
      fsc_program_name constant typ.proc_path := 'test_started';
      --      
      fs_log_message          app.logs.message%type := 'Started';
      fc_expected             sys_refcursor;
      fc_actual               sys_refcursor;      
   begin
     -- Set up jobs record
     task.set_to_ready(fsc_program_name);

     -- Main Test
     task.started(fsc_program_name, fsc_func_name);

     -- Validation of data on logs table
     open fc_actual for select session_id, severity, func_name, message, user_name 
        from app.logs 
       where session_id = task.get_session_id
         and func_name = fsc_func_name;
         
     open fc_expected for select task.get_session_id session_id, 
                                 task.sev_report severity,	
                                 fsc_func_name func_name,	
                                 fs_log_message message, 
                                 user user_name 
        from dual;

     ut.expect(fc_actual).to_equal(fc_expected); 
   
   end started;

   procedure afterall is
      fsc_func_name  constant typ.proc_path := psc_package_prefix||'afterall';
   begin
      -- Tear Down
      --delete from app.logs where session_id = task.get_session_id;
      --dbms_output.put_line(fsc_func_name||' SessionID='||to_char(task.get_session_id)||' delete count='||sql%rowcount);
      commit;
   end afterall;
end ut_task;
/
