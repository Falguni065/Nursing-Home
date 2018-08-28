CREATE OR REPLACE FUNCTION read RETURN NUMBER AS

        TOTAL_COUNT NUMBER;
        F UTL_FILE.FILE_TYPE;
        LINE VARCHAR(10000);      
        NID NURSE.ID%TYPE;
        NAME NURSE.NAME%TYPE;

    BEGIN
        TOTAL_COUNT := 0;
        F := UTL_FILE.FOPEN('DATA', 'Nurse.csv', 'R');
        IF(UTL_FILE.IS_OPEN(F)) THEN
        
            DBMS_OUTPUT.PUT_LINE('NURSE FILE OPENED');
            UTL_FILE.GET_LINE(F, LINE, 10000);
            
            LOOP
                BEGIN
                    UTL_FILE.GET_LINE(F, LINE, 10000);
                    
                    NID := REGEXP_SUBSTR(LINE, '[^,]+', 1, 1);
                    NAME := REGEXP_SUBSTR(LINE, '[^,]+', 1, 2);
                    
                    INSERT INTO NURSE(ID, NAME) VALUES(NID, NAME);
                        
                    TOTAL_COUNT := TOTAL_COUNT + 1;
                    
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN EXIT;
                END;
                
            END LOOP;
        END IF;
        
        UTL_FILE.FCLOSE(F);
        COMMIT;
        
        RETURN TOTAL_COUNT;
    END;
    
SHOW ERRORS;