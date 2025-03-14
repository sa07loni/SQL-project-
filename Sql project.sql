-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
USE OnlineBookstore;
show databases;

-- Create Tables
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price DECIMAL(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10, 2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

-- Import Data into Books Table
LOAD DATA LOCAL INFILE 'C://Users//DELL//Downloads//Books.csv'
INTO TABLE Books
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Book_ID, Title, Author, Genre, Published_Year, Price, Stock);

-- Import Data into Customers Table
LOAD DATA LOCAL INFILE "C:\Users\DELL\Downloads\Customers.csv"
INTO TABLE Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Customer_ID, Name, Email, Phone, City, Country);

-- Import Data into Orders Table
LOAD DATA LOCAL INFILE "C:\Users\DELL\Downloads\Orders.csv"
INTO TABLE Orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount);
select *from onlinebookstore.books;
select * from onlinebookstore.customers;
select * from onlinebookstore.orders;



-- Retrieve all books in the "Fiction" genre
select * from books where genre="Fiction";

-- Find books published after the year 1950
SELECT * FROM Books WHERE Published_Year > 1950;

-- List all customers from Canada
SELECT * FROM Customers WHERE Country='Canada';

-- Show orders placed in November 2023
SELECT * FROM Orders WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock FROM Books;

-- Find the details of the most expensive book
SELECT * FROM Books ORDER BY Price DESC LIMIT 1;

-- Show all customers who ordered more than 1 quantity of a book
SELECT * FROM Orders WHERE Quantity > 1;

-- Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders WHERE Total_Amount > 20;

-- List all genres available in the Books table
SELECT DISTINCT Genre FROM Books;

-- Find the book with the lowest stock
SELECT * FROM Books ORDER BY Stock LIMIT 1;

-- Calculate the total revenue generated from all orders
SELECT SUM(Total_Amount) AS Revenue FROM Orders;

-- Advanced Queries

-- Retrieve the total number of books sold for each genre
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre;

-- Find the average price of books in the "Fantasy" genre
SELECT AVG(Price) AS Average_Price FROM Books WHERE Genre = 'Fantasy';

-- List customers who have placed at least 2 orders
SELECT o.Customer_ID, c.Name, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;

-- Find the most frequently ordered book
SELECT o.Book_ID, b.Title, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY o.Book_ID, b.Title
ORDER BY Order_Count DESC LIMIT 1;

-- Show the top 3 most expensive books of 'Fantasy' Genre
SELECT * FROM Books WHERE Genre = 'Fantasy' ORDER BY Price DESC LIMIT 3;

-- Retrieve the total quantity of books sold by each author
SELECT b.Author, SUM(o.Quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Author;

-- List the cities where customers who spent over $30 are located
SELECT DISTINCT c.City 
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.Total_Amount > 30;

-- Find the customer who spent the most on orders
SELECT c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC LIMIT 1;

-- Calculate the stock remaining after fulfilling all orders
SELECT b.Book_ID, b.Title, b.Stock, COALESCE(SUM(o.Quantity), 0) AS Order_Quantity,  
       (b.Stock - COALESCE(SUM(o.Quantity), 0)) AS Remaining_Quantity
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock;
