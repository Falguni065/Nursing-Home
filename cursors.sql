SET SERVEROUTPUT ON

/*THIS CURSOR PRINTS INFORMATIONS OF ALL "NEURO SURGEON"*/

DECLARE
    d_name DOCTOR.DCT_NAME%type;
    d_special DOCTOR.SPECIALIST%type;
    d_visit DOCTOR.VISITING_TIME%type;
    d_cont DOCTOR.DCT_CONTACT%type;
    
cursor cur_doct is (select dct_name,specialist,visiting_time,dct_contact from doctor where specialist = 'Neuro Surgeon' );
    
BEGIN
    if not cur_doct%isopen
    then open cur_doct;
    end if;
    
    LOOP
        fetch cur_doct into d_name,d_special,d_visit,d_cont;
        exit when cur_doct%notfound;
        DBMS_OUTPUT.PUT_LINE('DOCTOR NAME: '||d_name||'  SPECIALIST: '||d_special||'  VISITING TIME: '||d_visit||'  CONTACT: '||d_cont);
    END LOOP;
    
    close cur_doct;
    
    
    
END;   

/* THIS CURSOR PRINTS PATIENT'S NAME, ASSIGNED DOCTOR'S NAME AND ASSIGNED NURSE'S NAME*/ 


DECLARE
    p_name PATIENT.NAME%type;
    d_name DOCTOR.DCT_NAME%type;
    n_name NURSE.NAME%type;
    
cursor cur_pat is 
(select p.name,d.dct_name, n.name from patient p natural join doctor d inner join cabin c
 on p.cabin = c.cabin_no inner join nurse n on c.assigned_nurse = n.id);
    
BEGIN
    if not cur_pat%isopen
    then open cur_pat;
    end if;
    
    LOOP
        fetch cur_pat into p_name,d_name,n_name;
        exit when cur_pat%notfound;
        DBMS_OUTPUT.PUT_LINE('PATIENT NAME: '|| p_name||'  DOCTOR NAME: '||d_name||'  NURSE NAME: '||n_name);
    END LOOP;
    
    close cur_pat;
    
    
    
END;    

/* THIS CURSOR PRINTS THE INFORMATIONS OF THE DOCTOR'S OF EVERY 
   INDIVIDUAL DEPARTMENTS WHOSE PATIENT COUNT IS MAXIMUM*/

DECLARE
    special DOCTOR.SPECIALIST%type;
    p_count DOCTOR.PAT_COUNT%type;
    cursor cur_pc is 
    (select specialist, max(pat_count) from doctor group by specialist);
    
BEGIN
    if not cur_pc%isopen
    then open cur_pc;
    end if;
    
    LOOP
        fetch cur_pc into special,p_count;
        exit when cur_pc%notfound;
         
        DECLARE
        
                d_name DOCTOR.DCT_NAME%type;
                d_visit DOCTOR.VISITING_TIME%type;
                d_cont DOCTOR.DCT_CONTACT%type;
                cursor doc_cur is
                (select dct_name,visiting_time,dct_contact from doctor where specialist = special and pat_count = p_count);
        BEGIN
                if not doc_cur%isopen
                then open doc_cur;
                end if;
                
                LOOP
                    fetch doc_cur into d_name,d_visit,d_cont;
                    exit when doc_cur%notfound;
                    DBMS_OUTPUT.PUT_LINE(special||': Doctor:'||d_name||', Visiting time:'||d_visit||', Contact:'||d_cont);
                END LOOP;
                    close doc_cur;
                END;

    END LOOP;
    
    close cur_pc;

END;    

/* THIS CURSOR PRINTS THE CABIN BILL, DOCTOR'S BILL AND TOTAL COST FOR EACH PATIENT*/

DECLARE
    p_id PATIENT.ID%type;
    p_rel PATIENT.RELEASING_DATE%type;
    
cursor cur_bill is 
(select id,releasing_date from patient);
    
BEGIN
    if not cur_bill%isopen
    then open cur_bill;
    end if;
    
    LOOP
        fetch cur_bill into p_id,p_rel;
        exit when cur_bill%notfound;
        if(p_rel is not null)
        then payment(p_id);
        end if;
        
    END LOOP;
    
    close cur_bill;
    
    
    
END;    

