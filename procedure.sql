create or replace procedure allPayment (p_id in integer, pcost out integer, dcost out integer, tcost out integer) is

    day integer;
    pay integer; 
    adm date;
    rel date;
    c_cost integer;
    d_visit integer;
    total integer;
    d_cost integer;
    p_name patient.name%type;
begin
    
       select name,admission_date, releasing_date into p_name,adm,rel from patient where id = p_id;
       select c.cost into c_cost from cabin c where cabin_no in(select cabin from patient where id = p_id); 
       day:= rel-adm;
       pay:= day*c_cost;
       select visit into d_visit from doctor where dct_id in (select dct_id from patient where id = p_id);
       d_cost:= day*d_visit;
       total:= pay + d_cost;
       
       pcost := pay;
       dcost := d_cost;
       tcost := total;
       
       DBMS_OUTPUT.PUT_LINE('Patient Name: '||p_name||', Cabin Bill: '||pay||', Doctor Bill: '||d_cost||', Total Cost: '||total);
    
  
end allPayment;
show errors;