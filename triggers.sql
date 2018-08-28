SET SERVEROUTPUT ON

/* THIS TRIGGER SETS THE INITIAL EXPERIENCE AND SALARY
   OF A NURSE WHEN INSERTED*/

CREATE OR REPLACE TRIGGER in_nurse
BEFORE INSERT ON nurse 
FOR EACH ROW

BEGIN
    :new.experience:= 0;
    :new.salary:= 5000;

END;

/* THIS TRIGGER UPDATES THE SALARY OF A NURSE WHEN EXPERIENCE INCREASES*/

CREATE OR REPLACE TRIGGER up_nurse
BEFORE UPDATE OF experience ON nurse 
REFERENCING OLD AS o NEW AS n
FOR EACH ROW

BEGIN
    IF :n.experience > 0 and :n.experience <= 5
    THEN :n.salary:= :o.salary*1.50;
    ELSIF :n.experience >=5 AND :n.experience < 8
    THEN :n.salary:= :o.salary*1.70;
    ELSE
    :n.salary:= :o.salary*2;
    END IF;
END;

/* THIS TRIGGER ASSIGNS A NEW NURSE IN A CABIN
   WHEN PRE-ASSIGNED NURSE OF THE CABIN IS DELETED*/

CREATE OR REPLACE TRIGGER up_cabin
BEFORE DELETE ON nurse 
FOR EACH ROW

declare
    deleted_nurse_id NURSE.ID%type;
    
BEGIN

    deleted_nurse_id := :old.id;
    update cabin set assigned_nurse = 2001 where assigned_nurse = deleted_nurse_id;

END;


/* THIS TRIGGER UPDATES THE PATIENT COUNT OF A DOCTOR 
   WHEN A NEW PATIENT IS ADMITTED*/

CREATE OR REPLACE TRIGGER count_pat
BEFORE INSERT ON PATIENT
FOR EACH ROW
DECLARE
    d_id integer;
    p_count integer;

BEGIN
    d_id := :new.dct_id;

    select pat_count into p_count from doctor where dct_id = d_id;
    if p_count is null
    then update doctor set pat_count = 1 where dct_id = d_id;
    else
    p_count := p_count + 1;
    update doctor set pat_count = p_count where dct_id = d_id;
    end if;

END;

/*THIS TRIGGER UPDATE THE VACANCY AS "BOOKED" WHEN A PATIENT IS ADMITTED IN THE CABIN
  AND UPDATE AS "VACANT" WHEN THE PATIENT IS RELEASED*/

CREATE OR REPLACE TRIGGER cabin_up
AFTER INSERT OR UPDATE ON PATIENT
FOR EACH ROW

DECLARE
    cabinn CABIN.CABIN_NO%type;
BEGIN
    cabinn:= :new.cabin; 
    if :new.releasing_date is null
    then update cabin set vacancy = 'Booked' where cabin_no = cabinn;
    else update cabin set vacancy = 'Vacant' where cabin_no = cabinn;
    end if;
END;

/*THIS TRIGGER CALCULATE THE AGE OF A PATIENT AND UPDATES
  THE "AGE" COLOUMN*/

create or replace trigger age
before insert on patient 
for each row
declare
    day integer;
    adm date;
    birth date;
    year integer;
    p_id integer;
begin

       p_id:= :new.id; 
       adm:= :new.admission_date;
       birth:= :new.birthday;
       day:= adm - birth;
       year:= day/365;    
       :new.age:= year;
end;

/* THIS TRIGGER CALCULATE THE DOCTORS TOTAL VISIT FOR AN INDIVIDUAL
   PATIENT AND UPDATES THE DOCTOR'S ACCOUNT BALANCE*/

CREATE OR REPLACE TRIGGER d_acc
AFTER INSERT OR UPDATE OF releasing_date on patient
FOR EACH ROW

DECLARE
    adm date;
    rel date;
    day integer;
    d_visit integer;
    p_acc integer;
    n_acc integer;
    acc integer;
BEGIN

    rel:= :new.releasing_date;
    adm:= :new.admission_date;
    if rel is not null
    then 
            day := rel-adm;
            select d.visit,D.ACCOUNT into d_visit,p_acc from doctor d where dct_id = :new.dct_id;
            acc := d_visit*day;
            n_acc := p_acc + acc;
            update doctor set account = n_acc where dct_id = :new.dct_id;
    end if;
    
END; 


