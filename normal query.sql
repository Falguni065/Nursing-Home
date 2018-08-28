describe doctor;
describe nurse;
describe cabin;
describe patient;

select * from doctor;
select * from nurse;
select * from cabin;
select * from patient;


select name from nurse where id in (select assigned_nurse from cabin where cabin_no in (select cabin from patient where id = 3001 ));

select * from cabin where category = 'Standard Bed' and vacancy = 'vacant';

select dct_name, degree, visiting_time from doctor where specialist = 'Gynae';


select p.name,n.name from patient p,nurse n where n.id in 
(select assigned_nurse from cabin where cabin_no in (select cabin from patient where id = 3001 )) and p.id =3001;



select p.name,d.dct_name from patient p, doctor d where p.doctor = d.dct_id;
select p.name,d.dct_name from patient p join doctor d on p.doctor = d.dct_id;
select p.name,d.dct_name from patient p natural join doctor d;


select specialist, max(salary) from doctor group by specialist;

select dct_name from doctor where visiting_time = 'Sat-Thus: 7.00pm -9.00pm';

select specialist, sum(salary) from doctor group by specialist having sum(salary)>50000 ;


select cabin_no, category from cabin where vacancy='vacant';

select cabin_no, category from cabin where vacancy='Booked';

select name from patient where releasing_date is null;

select distinct specialist from doctor;

select name as patient_name from patient;

select dct_name, specialist from doctor where specialist like '%Sur%';

select * from nurse order by salary ;
select * from nurse order by salary desc;

select p.name, c.cabin_no from patient p, cabin c where p.cabin = c.cabin_no and releasing_date is null;

select p.name, c.cabin_no, n.name from patient p, cabin c, nurse n where p.cabin = c.cabin_no and c.assigned_nurse = n.id;

select p.name, c.cabin_no, n.name from patient p, cabin c, nurse n where p.cabin = c.cabin_no and c.assigned_nurse = n.id and releasing_date is null;

select p.name as patient_name, c.cabin_no, n.name as nurse_name from patient p, cabin c, nurse n where p.cabin = c.cabin_no and c.assigned_nurse = n.id and releasing_date is null;


select specialist, max(pat_count) from doctor group by specialist;
select specialist,count(*) from doctor group by specialist;


----JOIN OPERATIONS----


select p.name,d.dct_name from patient p join doctor d on p.dct_id = d.dct_id;

select p.name,d.dct_name from patient p natural join doctor d;

select p.name as patient_name, c.cabin_no, n.name as nurse_name from patient p inner join cabin c on p.cabin = c.cabin_no inner join nurse n on c.assigned_nurse = n.id and releasing_date is null;

select p.name as patient_name, d.dct_name as doctor_name from patient p left outer join doctor d on p.dct_id = d.dct_id;

select p.name as patient_name, c.cabin_no, n.name as nurse_name from patient p right outer join cabin c on p.cabin = c.cabin_no  right outer join nurse n on c.assigned_nurse = n.id ;

select c.cabin_no, n.name from cabin c full outer join nurse n on c.assigned_nurse = n.id;

select p.name,n.name,d.dct_name from patient p join cabin c on c.cabin_no = p.cabin join nurse n on c.assigned_nurse = n.id 
natural join doctor d;


commit;