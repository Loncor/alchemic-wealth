CREATE OR REPLACE PACKAGE prc.typ is
/**
This package contains types and subtypes to be used in packages and procedures across the system. 

<br>
Author: Stanley J A Wilson
*/
   -------------------------------------------------------------------------------------------------
   --||                       public package types                                              ||--
   -------------------------------------------------------------------------------------------------
   type generic_cur is ref cursor;

   -------------------------------------------------------------------------------------------------
   --||                       public package subtypes                                           ||--
   -------------------------------------------------------------------------------------------------
   -------------------------------------
   -- non-table types
   -------------------------------------
   subtype obj_name is varchar2( 30 );
   subtype proc_path is varchar2( 61 );
   -------------------------------------
end typ;
/
