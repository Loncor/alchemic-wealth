CREATE OR REPLACE PACKAGE prc.std is
/**
This package contains standard constants to be used in packages and procedures across the system.

<br>
Author: Stanley J A Wilson
*/
   -------------------------------------------------------------------------------------------------
   --||                       public constants                                                  ||--
   -------------------------------------------------------------------------------------------------
   date_fmt           constant varchar2( 30 ) := 'DD-MON-YYYY';
   time_fmt           constant varchar2( 30 ) := 'HH24:MI:SS';
   date_time_fmt      constant varchar2( 30 ) := date_fmt||' '||time_fmt;
   high_date          constant date           := to_date( '31-DEC-4712 23:59:59', 'DD-MON-YYYY HH24:MI:SS' );
   one_second         constant number         := 1 /( 24 * 60 * 60 );                 -- 1 second (as fraction of a day)
   ----------------------------
   -- Exceptions
   ----------------------------
   task_fatal exception; pragma exception_init(task_fatal, -20928);          
   task_abort exception; pragma exception_init(task_abort, -20929);          
   ----------------------------
end std;
/
