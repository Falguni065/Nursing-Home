SET SERVEROUTPUT ON;
DECLARE
   X integer;
BEGIN
   X := getPatientCharge;
   DBMS_OUTPUT.PUT_LINE(X || ' ENTRIES '); 
END;