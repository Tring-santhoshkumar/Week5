create table department(
	dept_id serial primary key,
	dept_name varchar(20) unique not null
)

select * from department

CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	emp_name VARCHAR(20) NOT NULL,
	emp_email VARCHAR(30) UNIQUE,
	emp_salary REAL NOT NULL CHECK(emp_salary > 0),
	dept_id INT REFERENCES department(dept_id) 
);