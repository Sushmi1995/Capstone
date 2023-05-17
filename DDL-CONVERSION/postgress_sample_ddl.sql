CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    address VARCHAR(200)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10, 2),
    description TEXT,
    category VARCHAR(50)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount NUMERIC(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    hire_date DATE,
    department VARCHAR(50)
);

CREATE TABLE inventory (
    product_id INT,
    quantity INT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE sales (
    transaction_id SERIAL PRIMARY KEY,
    product_id INT,
    customer_id INT,
    transaction_date DATE,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE salaries (
    employee_id INT,
    salary_amount NUMERIC(10, 2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    grade VARCHAR(10)
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100),
    contact_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    address VARCHAR(200)
);

CREATE TABLE website_visitors (
    visitor_id SERIAL PRIMARY KEY,
    visitor_ip VARCHAR(20),
    visit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    page_visited VARCHAR(100)
);

--complex
CREATE TABLE orders (
    order_id SERIAL,
    customer_id INT,
    order_date DATE,
    total_amount NUMERIC(10, 2),
    PRIMARY KEY (order_id, customer_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE documents (
    document_id SERIAL PRIMARY KEY,
    document_data JSONB,
	document_data_1 JSON
);

CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    location_name VARCHAR(100),
    location_point GEOMETRY(Point, 4326)
);


CREATE TABLE surveys (
    survey_id SERIAL PRIMARY KEY,
    participant_ids INT[],
    survey_responses JSONB[]
);

CREATE TABLE documents (
    document_id SERIAL PRIMARY KEY,
    document_text TEXT
);
