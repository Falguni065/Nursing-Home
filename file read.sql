SET SERVEROUTPUT ON;
DECLARE
   X NUMBER;
BEGIN
   X := READ;
   DBMS_OUTPUT.PUT_LINE(X || ' ENTRIES '); 
END;