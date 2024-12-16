---library management system project 2
---- creating baranch table

create table branch(branch_id varchar(10) primary key,manager_id varchar(15),
branch_address varchar(15),contact_no varchar(15))
select * from branch;

----create table employees
 create table employees(emp_id varchar(10) primary key,emp_name varchar(20), 
 position varchar(20),
 salary float,	
 branch_id varchar(20))---FK


select * from employees;


---create table books----
create table books (isbn varchar(20) primary key,book_title varchar(100), category varchar(100),	
rental_price float,status varchar(10), author varchar(50),
publisher varchar(100));
select * from books;

---create table members----
create table members (member_id varchar(10) primary key,
member_name	varchar(50),
member_address varchar(75),	reg_date date);

---create table issue_status---
create table issued_status(issued_id varchar(10) primary key,--FK
issued_member_id varchar(20),issued_book_name varchar(70),
issued_date date,
issued_book_isbn varchar(30),---FK
issued_emp_id  varchar(10)); ----fk
alter table issue_stauts rename to issued_status;
select * from issued_status;
---return_status---
create table return_status(return_id  varchar(20) primary key,issued_id varchar(30),
return_book_name varchar(75),return_date date,return_book_isbn varchar(20)
);

---- foreign key----
alter table issued_status
add constraint fk_members
foreign key(issued_member_id)
references members(member_id);

alter table issued_status 
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn);

alter table issued_status
add constraint fk_employees
foreign key (issued_emp_id)
references employees(emp_id);

alter table employees
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);

alter table return_status
add constraint fk_issued_status
foreign key(issued_id)
references issued_status(issued_id);

copy books from 'C:\Program Files\PostgreSQL\16\books.csv'
delimiter ',' csv header;

copy employees from 'C:\Program Files\PostgreSQL\16\employees.csv'
delimiter ',' csv header;


copy branch from 'C:\Program Files\PostgreSQL\16\branch.csv'
delimiter ',' csv header;

copy issued_status from 'C:\Program Files\PostgreSQL\16\issued_status.csv'
delimiter ',' csv header;

copy members from 'C:\Program Files\PostgreSQL\16\members.csv'
delimiter ',' csv header;

copy return_status from 'C:\Program Files\PostgreSQL\16\return_status.csv'
delimiter ',' csv header;

-------------------------------------------------------------------
----show all tables data----------
select  * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;
-------------------------------------------
-----project task------------
--task 1. create a new book record-- "978-1-60129-456-2',
---'to kill a mockingbird','classic',6.00,'yes','harperlee',
----'j.b. lippincott &co.')" 
insert into books(isbn,book_title,category,rental_price,
status,author,publisher)
values
('978-1-60129-456-2',
'to kill a mockingbird','classic',6.00,
'yes','harperlee','j.b. lippincott &co');
 select * from books;
---------------------------------
--task2: update an existing members address
update members 
set member_address = '125 main st'
where member_id = 'C101';
select * from members;
--------------------------------
---task:3 delete a record from the issued status table 
--objective:delet the record with issued_id = 'IS140' from the 
--issued_status table.
 delete from  issued_status
 where issued_id = 'IS140';
select * from issued_status;
--------------------------------------------------------
--task4: retrieve all books issued by a specific employee
--objective: select all book issued by the employee with emp_id ='E101'
select * from issued_status 
where issued_emp_id = 'E101';
-------------------------------------------------------------
--task5: list members who have issued more than one book
--objective:use group by who have issued more than one book
select 
issued_emp_id,
count(issued_id) as total_book_issued
from issued_status
group by issued_emp_id
having count(issued_id)>1;
-------------------------------------------------------------
--CTAS
--task6: create summary table: used CTAS to generate new table 
--based on query result - each book and total book_issued_count**
create table book_counts
as
select isbn, book_title,count(issued_id)
from
books join issued_status on
books.isbn = issued_status.issued_book_isbn
group by isbn, book_title;
-----------------------------------------------------------------
select * from book_counts;
---------------------------------------------------------------
--task7: reatrieve all  ooks in a specific category;
select * from books
where category = 'classic'
-------------------------------------
 --task8: find total rental income by category;
 select * from books;
 select  sum(rental_price)  , category from books 
 group by category;----(this query will not give you accurate result)
                    ---(because one book can be issued multiple time
select sum(b.rental_price),
b.category,
count(*)
 from books as b join issued_status as ist
 on b.isbn = ist.issued_book_isbn 
 group by 2;
 -------------------------------------------------------
 --task9: list members who registered in the last 180 days;
select * from members
where reg_date>=current_date -interval '180 days';

----------------------------------------------------------
--list employee with their branch manager's name and their branch details
select e1.*,br.manager_id,
e2.emp_name as manager_name
 from branch as br
join employees as e1 
on br.branch_id = e1.branch_id
join
employees as e2
on br.manager_id = e2.emp_id;
---------------------------------------------------------------
--task11:create a book table with rental price above a certain threshold 7usd:
create  table book_price_greater_than_seven
as
select * from books
where rental_price>7;
--------------------------------------------------------------------
 select * from book_price_greater_than_seven;
 -----------------------------------------------------------------------
--task12: retrieve the books that are not returned yet;
select ist.issued_book_name from
issued_status as ist left join
return_status as rs on
ist.issued_id = rs.issued_id
where return_id is null ;
------------------------------------------------------------------
--part = 2---
select * from issued_status;
insert into issued_status(issued_id, issued_member_id , issued_book_name,
issued_date, issued_book_isbn,issued_emp_id)
values
('IS151','C118','The Catcher in the Rye',current_date - interval '24 days',
'978-0-553-29698-2','E108'),
('IS152','C119','The Catcher in the Rye',current_date - interval '13 days',
'978-0-553-29698-2','E109'),
('IS153','C106','pride and prejudice',current_date - interval '7 days',
'978-0-14-143951-8','E107'),
('IS154','C105','The Road',current_date - interval '32 days',
'978-0-375-50167-0','E101');

alter table return_status 
add column book_quality varchar(15) default('Good');

update return_status 
set book_quality = 'Damaged'
where issued_id 
in ('IS112','IS117','IS118');
select * from return_status;
---------------------------------------------------------
------library_project_2 part - 2 (Advence queries)----------

select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;
---------------------------------------
/*task-13- identify members with overdue books . write a query to 
to identify members who have overdue books(assume a 30 day 
return period)display the members_id ,members_name ,
book title, issue date,and days overdue.*/

-- issued_status == members == books == return_status
-- filter books which is return 
--overdue >30
 select ist.issued_member_id , m.member_name,bk.book_title,ist.issued_date,
/*rs.return_date,*/ current_date - ist.issued_date as over_dues_days
 from issued_status ist join members  as m
on m.member_id = ist.issued_member_id
join books as bk on bk.isbn = ist.issued_book_isbn
 left join return_status as rs on rs.issued_id = ist.issued_id
 where rs.return_date is null and  current_date - ist.issued_date>30
 order by 1;
 -------------------------------------------------------
 /*task-14:update book status on return 
 write a query to update the status of book in the books table to 
 'yes' when they are returned(based on entries in the return_status
 teble).*/


 select * from issued_status
 where issued_book_isbn='978-0-451-52994-2';
 select * from books
 where isbn = '978-0-451-52994-2';

 update books
 set status = 'no'
 where isbn = '978-0-451-52994-2';
 select * from return_status
 where issued_id = 'IS130';

 -----------------------------------------
 insert into return_status(return_id, issued_id, return_date,
 book_quality) values
 ('RS125','IS130',current_date,'Good');

 select * from return_status
 where issued_id = 'IS130';
 
 update books
 set status = 'yes'
 where isbn = '978-0-451-52994-2';
 
 -----------store procedure------
 Create or Replace  Procedure add_return_records(p_return_id varchar(20),p_issued_id varchar(30),
 p_book_quality varchar(15))
 Language plpgsql
 as $$
 declare
     v_isbn varchar(30); 
	 v_book_name varchar(70);
 begin
    -----all your logic and code
    ----inserting into return based on  user input
    insert into return_status(return_id,issued_id,return_date,book_quality)
    values
    (p_return_id,p_issued_id,current_date,p_book_quality);
	
	select 
	    issued_book_isbn,
		issued_book_name
		into
		v_isbn,
		v_book_name
	from issued_status
	where issued_id = p_issued_id;

	update books
	set status  = 'yes'
	where isbn = v_isbn;

	raise notice 'thank you for returning the book:%',v_book_name;
 End;
 $$

-------Testing the function add_return_records.-----
issued_id = IS135
ISBN =  where isbn = '978-0-307-58837-1'

select * from books 
where isbn ='978-0-307-58837-1';

select * from issued_status 
where issued_book_isbn ='978-0-307-58837-1';

delete from return_status
where issued_id = 'IS135';
------calling a function--------
call add_return_records('RS138','IS135','Good');
---------------checking whether it is updated or not-------
select * from return_status
where issued_id = 'IS135' ;
select * from books 
where isbn ='978-0-307-58837-1';
------another testing----------
select * from books;
select * from issued_status
where issued_book_isbn = '978-0-7432-7357-1';
select * from  return_status 
where issued_id = 'IS136';

------calling function-----
call add_return_records('RS139','IS136','Good')
-----checking whether its updated or not----
select * from books 
where isbn = '978-0-7432-7357-1';
select * from return_status 
where issued_id  = 'IS136';
------------------------------------------------------------------------
/*Task 15: Branch Performance Report :Create a query that 
generates a performance report for each branch,showing 
the number of books issued, the number of books returned,
and the total revenue generated from book rentals.*/
create table branch_reports
as
select 
    b.branch_id,
	b.manager_id,
	count(ist.issued_id) as number_of_book_issued,
	sum(bk.rental_price) as total_revenue
from issued_status as ist
join employees as e 
on ist.issued_emp_id = e.emp_id 
join branch as b 
on b.branch_id = e.branch_id
left join return_status as rs
on rs.issued_id = ist.issued_id
join books as bk 
on bk.isbn = ist.issued_book_isbn
group by b.branch_id, b.manager_id;

select * from branch_reports;

/*Task 16: CTAS: Create a Table of Active Members:
Use the CREATE TABLE AS (CTAS) statement to create 
a new table active_members containing members who have
issued atleast one book in the last 8 months.*/
 select * from issued_status
 where issued_date >= current_date - interval '8 month';
 
 create table  active_members
 as
 select * from members
 where member_id in( select 
                         distinct issued_member_id
                     from issued_status
                     where 
			              issued_date >= current_date - interval '8 month');

select * from active_members;
------------------------------------------------------------
/*Task 17: Find Employees with the Most Book Issues Processed:
Write a query to find the top 3 employees who have processed 
the most book issues. Display the employee name,number of books
processed, and their branch.*/

select e.emp_name,
       b.*,
       count(ist.issued_id) as no_book_issued
from issued_status as ist
join employees as e
on e.emp_id = ist.issued_emp_id
join branch as b 
on b.branch_id = e.branch_id
group by 1,2 
order by no_book_issued desc limit 3;

--------------------------------------------------------------
/*Task 19: Stored Procedure Objective: Create a stored procedure 
to manage the status of books in a library system. Description:
Write a stored procedure that updates the status of a book in the
library based on its issuance. The procedure should function as 
follows: The stored procedure should take the book_id as an input
parameter. The procedure should first check if the book is available
(status = 'yes').
If the book is available, it should be issued,===
and the status in the books table should be updated to 'no'. If the
book is not available (status = 'no'), the procedure should return
an error message indicating that the book is currently not available.*/

select * from books;
select * from issued_status;

create or replace procedure issue_book(p_issued_id varchar(10),
     p_issued_member_id varchar(20),p_issued_book_isbn varchar(30),
	 p_issued_emp_id varchar(10))
language plpgsql
as $$

declare
----all variable----
    v_status varchar(10);
begin
----all the code----
---checking if book is available 'yes';
      select 
	      status
		  into v_status
	  from books
      where isbn = p_issued_book_isbn;
	  
  if v_status = 'yes' then 
	  
     insert into issued_status(issued_id,issued_member_id,issued_date,
	               issued_book_isbn,issued_emp_id)
	  values
	  (p_issued_id,p_issued_member_id,current_date,
	   p_issued_book_isbn, p_issued_emp_id); 

	   update books 
	         set status  = 'No'
	   where isbn = p_issued_book_isbn;		 

				
	 raise notice 'Book record added succesfully for 
				      isbn:%', p_issued_id;
				   
  else
    raise notice 'sorry to informed you that the book you have 
	           requested is unavailable book_isbn:%', p_issued_id;
  end if;			   
			   
end;
$$
--------------------------------------------
----calling function-------
select * from books;
---"978-0-330-25864-8"-----'yes'
-----"978-0-525-47535-5"----'No'
select * from issued_status
where issued_book_isbn = '978-0-330-25864-8';

call issue_book('IS155','C106','978-0-330-25864-8','E105');
call issue_book('IS156','C108','978-0-525-47535-5','E106');


select * from books
where isbn ='978-0-330-25864-8';
-------------------------------------------------------------------------
------------------END PROJECT-------------------------
