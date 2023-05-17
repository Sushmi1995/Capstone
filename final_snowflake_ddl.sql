CREATE OR REPLACE TABLE Users (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100)
);

CREATE OR REPLACE TABLE Orders (
    order_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    order_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE OR REPLACE TABLE Products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);


CREATE OR REPLACE TABLE OrderItems (
    item_id NUMBER PRIMARY KEY,
    order_id NUMBER,
    product_id NUMBER,
    quantity NUMBER,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE OR REPLACE TABLE Categories (
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE OR REPLACE TABLE Products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    category_id NUMBER,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE OR REPLACE TABLE Customers (
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR(100),
    address VARCHAR(200)
);

CREATE OR REPLACE TABLE Orders (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    product_id NUMBER,
    quantity NUMBER,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE OR REPLACE TABLE Authors (
    author_id NUMBER PRIMARY KEY,
    author_name VARCHAR(100)
);

CREATE OR REPLACE TABLE Books (
    book_id NUMBER PRIMARY KEY,
    book_title VARCHAR(200),
    author_id NUMBER,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);




CREATE OR REPLACE TABLE orders (
  order_id NUMBER AUTOINCREMENT,
  customer_id NUMBER,
  product_id NUMBER,
  quantity NUMBER,
  PRIMARY KEY (order_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);


CREATE OR REPLACE TABLE employees (
  employee_id NUMBER,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  hire_date DATE,
  PRIMARY KEY (employee_id)
);


CREATE OR REPLACE TABLE students (
  student_id NUMBER,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age NUMBER,
  grade VARCHAR(10),
   FOREIGN KEY (product_id) REFERENCES products(product_id)
);

 grade VARCHAR(10)
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE OR REPLACE TABLE products (
  product_id NUMBER,
  product_name VARCHAR(100),
  category ENUM('Electronics', 'Clothing', 'Furniture'),
  price DECIMAL(10, 2),
  PRIMARY KEY (product_id),
  CHECK age >= 18
);

CREATE OR REPLACE TABLE orders (
  order_id NUMBER AUTOINCREMENT,
  customer_id NUMBER,
  product_id NUMBER,
  quantity NUMBER,
  PRIMARY KEY (order_id),
  UNIQUE KEY (customer_id, product_id),
  CHECK (gcgcgcg575#^#U)
);




