set serveroutput on;
create or replace function getPatientCharge
return integer
    as
    f utl_file.file_type;
    cursor p_record is select id, name from patient where releasing_date is not null;
        
    pid patient.id%type;
    pname patient.name%type;
    totalCharge integer;
    totalEntries integer;
    cab_cost integer;
    dct_cost integer;
    total integer;
    
    
    begin 
        totalEntries := 0;
        f := utl_file.fopen('DATA', 'PatientHistory.csv', 'W');
        if utl_file.is_open(f) then
            dbms_output.put_line('PatientHistory file opened for writing');
            utl_file.put(f, 'Id' || ',' || 'Name' || ',' || 'Cabin Cost' || ',' || 'Doctor Bill' || ',' || 'Total Bill');
            utl_file.new_line(f);
            open p_record;
            loop
                fetch p_record into pid, pname;
                    exit when p_record%notfound;
                    
                allPayment(pid,cab_cost,dct_cost,total);
                utl_file.put(f, pid || ',' || pname || ',' || cab_cost || ','|| dct_cost|| ',' || total);
                utl_file.new_line(f);
                totalEntries := totalEntries + 1;
            end loop;
            
        end if;
        utl_file.fclose(f);
        close p_record;
        dbms_output.put_line('patientHistory file successfully closed after writing');
        return totalEntries;
    end;
    show errors;