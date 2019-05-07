-- Grants to PRC (Packages and Procedures) Schema
-- Grant Executes
grant execute on dbms_scheduler to prc;
grant execute on dbms_isched to prc;
grant execute on utl_file to prc;
grant execute on utl_http to prc;

-- Grant create any directory
grant create any directory to prc;

-- Grant Select
grant select on v_$reserved_words to prc;
