drop table patient;
drop table cabin;
drop table nurse;
drop table doctor;


create table doctor(dct_id integer,
                    dct_name varchar(50),
                    degree varchar(50),
                    specialist varchar(50),
                    visiting_time varchar(50),
                    visit integer,
                    dct_contact integer,
                    pat_count integer,
                    account integer,
                    primary key (dct_id));
                    


create table nurse(id integer,
                   name varchar(50),
                   salary integer,
                   experience integer,
                   primary key(id));       
                                
                   

create table cabin(cabin_no integer,
                   floor integer, 
                   category varchar(50), 
                   vacancy varchar(50),
                   cost integer,
                   assigned_nurse integer,
                   primary key(cabin_no),
                   foreign key (assigned_nurse) references nurse(id));
                   
                   
                  
create table patient(id integer,
                     name varchar(50),
                     age integer,
                     cabin integer,
                     dct_id integer,
                     contact integer unique,
                     birthday date,
                     admission_date date,
                     releasing_date date ,
                     primary key (id),
                     foreign key (cabin) references cabin(cabin_no),
                     foreign key (dct_id) references doctor(dct_id));	

                   	                   
                     
