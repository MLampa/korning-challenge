-- DEFINE YOUR DATABASE SCHEMA HERE
	-- SCHEMA
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS frequency;
DROP TABLE IF EXISTS invoice;

	CREATE TABLE employee (
		id SERIAL PRIMARY KEY,
		employee VARCHAR(100)
	);

	CREATE TABLE customers (
		id SERIAL PRIMARY KEY,
    customer_and_account_no TEXT
	);

	CREATE TABLE products (
		id SERIAL PRIMARY KEY,
		product_name VARCHAR(100),
		sale_date VARCHAR(100),
		sale_amount VARCHAR(100),
		units_sold VARCHAR(100)
	);

	CREATE TABLE frequency (
		id SERIAL PRIMARY KEY,
		invoice_frequency VARCHAR(200)
	);

	CREATE TABLE invoice (
		id SERIAL PRIMARY KEY,
		invoice_no VARCHAR(100)
	);

	CREATE TABLE sales (
		id SERIAL PRIMARY KEY,
		-- employee,customer_and_account_no,product_name,sale_date,sale_amount,units_sold,invoice_no,invoice_frequency
		employee_id INTEGER REFERENCES employee(id),
		customer_id INTEGER REFERENCES customers(id),
		products_id INTEGER REFERENCES products(id),
		frequency_id INTEGER REFERENCES frequency(id),
		invoice_id INTEGER REFERENCES invoice(id)
	);



	-- CREATE TABLE sales (
	--   id SERIAL PRIMARY KEY,
	--   recipe_id INTEGER,
	--   user_name VARCHAR(100),
	--   body TEXT
	-- );
