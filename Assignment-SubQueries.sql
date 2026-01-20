create database Sub;
use sub;
create table employee
(emp_id int primary key,
name varchar(50),
department_id varchar(50),
salary int);
insert into employee values
(101,"Abhishek","D01",62000),
(102,"Shubham","D01",58000),
(103,"Priya","D02",67000),
(104,"Rohit","D02",64000),
(105,"Neha","D03",72000),
(106,"Aman","D03",55000),
(107,"Ravi","D04",60000),
(108,"Sneha","D04",75000),
(109,"Kiran","D05",70000),
(110,"Tanuja","D05",65000);
Select * from employee ;
create table Department 
(department_id varchar(50),
department_name varchar(50),
location varchar(50));
insert into Department values
("D01", "Sales","Mumbai"),
("D02","Marketing","Delhi"),
("D03","Finance","Pune"),
("D04","HR","Bengaluru"),
("D05","IT","Hyderabad");
select * from Department;
create table Sales
(sale_id int,
emp_id int,
sale_amount int,
sale_date date);
insert into Sales values
(201,101,4500,"2025-01-05"),
(202,102,7800,"2025-01-10"),
(203,103,6700,"2025-01-14"),
(204,104,12000,"2025-01-20"),
(205,105,9800,"2025-02-02"),
(206,106,10500,"2025-02-05"),
(207,107,3200,"2025-02-09"),
(208,108,5100,"2025-02-15"),
(209,109,3900,"2025-02-20"),
(210,110,7200,"2025-03-01");
select * from Sales;
#Basic Level
#1.Retrieve the names of employees who earn more than the average salary of all employees
select avg(salary) avg_salary from employee ;
select name,salary from employee where salary >(select avg(salary) avg_salary from employee );

#2.Find the employees who belong to the department with the highest average salary.
select e.name,e.salary ,e.department_id from employee e 
where e.department_id=
(select department_id from employee
group by department_id
order by avg(salary) desc
limit 1);
#3.List all employees who have made at least one sale.
 select e.name,e.emp_id
 from employee e
 where exists
 (select 1 from sales s
 where e.emp_id=s.emp_id);
 
 #4.Find the employee with the highest sale amount.
 
 select e.name,s.sale_amount from employee e
 inner join sales S
 on e.emp_id=s.emp_id
 order by s.sale_amount desc;
 
 #5.Retrieve the names of employees whose salaries are higher than Shubham’s salary
 select name from employee where salary>(Select salary from employee where name="Shubham");
 
 
 #Intermediate Level
 
 #1.Find employees who work in the same department as Abhishek.
 
 select name from employee where department_id in
 (select department_id from employee 
 where name= "Abhishek");
 
 #excluding Abhishek
 select name from employee where department_id in
 (select department_id from employee 
 where name= "Abhishek")
 and name <> "Abhishek" ;
 
 # using joins
 
 select e2.name
 from employee e1
 join employee e2
 on e1.department_id=e2.department_id
 where e1.name="Abhishek"
 and e2.name <> "Abhishek";
 
 #2.List departments that have at least one employee earning more than ₹60,000.
 select distinct department_id from employee  where salary> 60000;
 #using group by
 select department_id from employee
 group by department_id 
 having max(salary) > 60000;
 
 #3.Find the department name of the employee who made the highest sale
 select d.department_name ,s.sale_amount
 from sales s
 join employee e
 on s.emp_id=e.emp_id
  join department d
  on e.department_id = d.department_id
  where s.sale_amount = (SELECT MAX(sale_amount) FROM sales);
 
#4.Retrieve employees who have made sales greater than the average sale amount.
select distinct e.emp_id,e.name from employee e
join sales s
on e.emp_id =s.emp_id
where s.sale_amount >(select avg(sale_amount) from sales);

#5.Find the total sales made by employees who earn more than the average salary.

select sum(s.sale_amount)  total_sales from sales s
join employee e
on s.emp_id=e.emp_id
where e.salary >
(select avg(salary) from employee e);

#Advanced Level

#1.Find employees who have not made any sales
Select e.emp_id, e.name
from employee e
left join sales s 
on e.emp_id = s.emp_id
where s.emp_id is null;
# using not exists

select e.emp_id, e.name
from employee e
where not exists (
    select 1
    from sales s
    where s.emp_id = e.emp_id
);

#2.List departments where the average salary is above ₹55,000.

select d.department_name
from  employee e
join department d 
on e.department_id = d.department_id
group by d.department_name
having avg(e.salary) > 55000;

#3.Retrieve department names where the total sales exceed ₹10,000

select d.department_name
from sales s
join employee e 
on s.emp_id = e.emp_id
join department d 
on e.department_id = d.department_id
group by d.department_name
having sum(s.sale_amount) > 10000;

#4.Find the employee who has made the second-highest sale.

Select e.emp_id, e.name, s.sale_amount
from sales s
join employee e
on s.emp_id = e.emp_id
order by s.sale_amount desc
limit 1 
offset 1;

#5.Retrieve the names of employees whose salary is greater than the highest sale amount recorded.
select name
from employee
where salary > (
    select max(sale_amount)
    from sales
);