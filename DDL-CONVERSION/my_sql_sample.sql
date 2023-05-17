CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);


CREATE TABLE OrderItems (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    address VARCHAR(200)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100)
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(200),
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

CREATE TABLE students (
  student_id INT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  age INT,
  grade VARCHAR(10),
  CHECK (age >= 18 AND grade IN ('A', 'B', 'C'))
);

CREATE TABLE products (
  product_id INT,
  product_name VARCHAR(100),
  category ENUM('Electronics', 'Clothing', 'Furniture'),
  price DECIMAL(10, 2),
  PRIMARY KEY (product_id),
  CHECK age >= 18
);

CREATE TABLE orders (
  order_id INT AUTO_INCREMENT,
  customer_id INT,
  product_id INT,
  quantity INT,
  PRIMARY KEY (order_id)
);




