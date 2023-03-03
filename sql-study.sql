-- Company Database
create database company;
use company;

-- Tables
create table employee (
	emp_id int primary key,
    first_name varchar(40),
    last_name varchar(40),
    birth_date date,
    sex char,
    salary double,
    super_id int,
    branch_id int
);

create table branch (
	branch_id int primary key,
    branch_name varchar(40),
    mgr_id int,
    mgr_start_date date,
    foreign key(mgr_id) references employee(emp_id) on delete set null
);

alter table employee add foreign key(super_id) references employee(emp_id) on delete set null;
alter table employee add foreign key(branch_id) references branch(branch_id) on delete set null;

create table `client` (
	client_id int primary key,
    client_name varchar(40),
    branch_id int,
    foreign key(branch_id) references branch(branch_id) on delete set null
);

create table works_with (
	emp_id int,
    client_id int,
    total_sales int,
    primary key(emp_id, client_id),
    foreign key(emp_id) references employee(emp_id) on delete cascade,
    foreign key(client_id) references `client`(client_id) on delete cascade
);

create table branch_supplier (
	branch_id int,
    supplier_name varchar(40),
    supply_type varchar(40),
    primary key(branch_id, supplier_name),
    foreign key(branch_id) references branch(branch_id) on delete cascade
);

-- Inserting branchs and managers
insert into employee values(100, "David", "Wallace", "1967-11-17", "M", 250, NULL, NULL);
insert into branch values(1, "Corporate", 100, "2006-02-09");

update employee set branch_id=1 where emp_id=100;

insert into employee values(101, "Jan", "Levinson", "1961-05-11", "F", 110, 100, 1);

insert into employee values(102, "Michael", "Scott", "1964-03-15", "M", 75000, 100, null);
insert into branch values(2, "Scranton", 102, "1992-04-06");

update employee set branch_id=2 where emp_id=102;

insert into employee values(106, "Josh", "Porter", "1969-09-05", "M", 78000, 100, null);
insert into branch values(3, "Stamford", 106, "1998-02-13");

update employee set branch_id=3 where emp_id=106;

select * from employee;
select * from branch;

-- Inserting other employees
insert into employee values
(101, "Jan", "Levinson", "1961-05-11", "F", 110, 100, 1),
(103, "Angela", "Martin", "1971-06-25", "F", 63000, 102, 2),
(104, "Kelly", "Kapoor", "1980-02-05", "F", 55000, 102, 2),
(105, "Stanley", "Hudson", "1958-02-19", "M", 69000, 102, 2),
(107, "Andy", "Bernard", "1973-07-22", "M", 65000, 106, 3),
(108, "Jim", "Halpert", "1978-10-01", "M", 71000, 106, 3);

-- Inserting clients
insert into `client` values(400, "Dunmore Highschool", 2),
(401, "Lackawana Country", 2),
(402, "FedEx", 3),
(403, "John Daly Law, LLC", 3),
(404, "Scranton Whitepages", 2),
(405, "Times Newspaper", 3),
(406, "FedEx", 2);

-- Inserting sales
insert into works_with values
(105, 400, 55000),
(102, 401, 267000),
(108, 402, 22500),
(107, 403, 5000),
(108, 403, 12000),
(105, 404, 33000),
(107, 405, 26000),
(102, 406, 15000),
(105, 406, 130000);

-- Inserting branch suppliers
insert into branch_supplier values
(2, "Hammer Mill", "Paper"),
(2, "Uni-ball", "Writing Utensils"),
(3, "Patriot Paper", "Paper"),
(2, "J.T. Forms & Labels", "Custom Forms"),
(3, "Uni-ball", "Writing Utensils"),
(3, "Hammer Mill", "Paper"),
(3, "Stamford Lables", "Custom Forms");

-- Finding forename and surenames
select first_name as forename, last_name as surename from employee;

-- Finding all different genders, brach ids
select distinct sex from employee;
select distinct branch_id from branch;

-- Outher functions
select count(emp_id) from employee; -- Count number of employees
select count(emp_id) from employee where sex="F" and birth_date>="1971-01-01"; -- The number of female employees born after 1970
select avg(salary) from employee; -- Find the average of all employee's salaries
select avg(salary) from employee where sex="M"; -- Find the average of all male employee's salaries
select sum(salary) from employee; -- Sum of salaries
select count(sex), sex from employee group by sex; -- How many males and females there are
select emp_id, sum(total_sales) from works_with group by emp_id; -- Total sales of each salesman
select client_id, sum(total_sales) from works_with group by client_id; -- How much each client spent

select * from `client` where client_name like "%LLC";
select * from branch_supplier where supplier_name like "%Label%";
select * from employee where birth_date like "____-10%"; -- All birth date in October
select first_name as `Names` from employee union select branch_name from branch union select client_name from `client`;

insert into branch values(4, "Buffalo", null, null);

-- Find all branches and the names of their managers
select branch.branch_id as "Branch ID", branch.branch_name as "Branch Name", employee.emp_id as "Manager ID", employee.first_name as "Manager First Name" from branch join employee on branch.mgr_id = employee.emp_id;

-- LEFT and RIGHT JOIN
select branch.branch_id as "Branch ID", branch.branch_name as "Branch Name", employee.emp_id as "Manager ID", employee.first_name as "Manager First Name" from branch left join employee on branch.mgr_id = employee.emp_id;
select branch.branch_id as "Branch ID", branch.branch_name as "Branch Name", employee.emp_id as "Manager ID", employee.first_name as "Manager First Name" from branch right join employee on branch.mgr_id = employee.emp_id;

select first_name, last_name from employee where emp_id in (
	select emp_id from works_with where total_sales>30000
);

select client_name from `client` where branch_id = (
	select branch_id from branch where mgr_id = 102 LIMIT 1
);
  
describe branch;