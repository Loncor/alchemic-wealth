create or replace package ut_task as
  -- %suite(Task Package Suite)

  --%beforeall
  --%rollback(manual)
  procedure beforeall;

  -- %test(Test log_issue)
  procedure log_issue;

  -- %test(Test each non-abort severity)
  procedure non_exception_severities;

  -- %test(Test log_abort)
  procedure log_abort;

  -- %test(Test log_fatal)
  procedure log_fatal;

  -- %test(Test set_to_ready)
  procedure set_to_ready;
   
  -- %test(Test started)
  procedure started;

  --%afterall
  --%rollback(manual)
  procedure afterall;

end ut_task;
/
