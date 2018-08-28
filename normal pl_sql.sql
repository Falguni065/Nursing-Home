SET SERVEROUTPUT ON

DECLARE

    type p_name_array is varray(100) of patient.name%type;
    type p_contact_array is varray(100) of patient.contact%type; 

    p_name p_name_array;
    p_contact p_contact_array;
    p_count integer;
    
    type cabin_array is varray(100) of cabin.category%type;
    type cost_array is varray(100) of cabin.cost%type;
    
    cabin_type cabin_array;
    cabin_cost cost_array;
    c_count integer;
    
    type nurse_array is varray(100) of nurse.name%type;
    type salary_array is varray(100) of nurse.salary%type;
    type position_array is table of varchar(50);
    
    nurse_name nurse_array;
    nurse_salary salary_array;
    position position_array := position_array() ;
    
    n_count integer;
    
    

BEGIN

    select name, contact BULK COLLECT into p_name, p_contact from patient;
    p_count := p_name.count;
    for i in 1..p_count
    LOOP
        
        DBMS_OUTPUT.PUT_LINE ('PATIENT_NAME: '||p_name(i)||' PATIENT_CONTACT: '||p_contact(i));
        
    END LOOP;
    
    
    select category, cost BULK COLLECT into cabin_type, cabin_cost from cabin where vacancy = 'vacant';
    c_count:= cabin_type.count;
    
    for i in 1..c_count
    LOOP
        
        DBMS_OUTPUT.PUT_LINE ('CABIN_TYPE: '||cabin_type(i)||' COST: '||cabin_cost(i));
        
    END LOOP;
    
    
    select name, salary BULK COLLECT into nurse_name, nurse_salary from nurse;
    n_count:= nurse_name.count;
    position.extend(n_count);
    
    for i in 1..n_count
    LOOP
    
       if nurse_salary(i)>=8000 then position(i):='Intensive Care Unit';
        elsif nurse_salary(i)>5000 and nurse_salary(i)<8000 then position(i):='Emergency Unit';
        elsif nurse_salary(i)<=5000 then position(i):='Staff Nurse';
        
        end if;
        
        DBMS_OUTPUT.PUT_LINE ('NURSE_NAME: '||nurse_name(i)||' ASSIGNED IN: '||position(i));
        
    END LOOP;
     
END;


