USE ritesh
-- ================================
-- DATABASE CREATION
-- ================================
CREATE DATABASE RestaurantManagement;
USE RestaurantManagement;

-- ================================
-- TABLE: Restaurants
-- ================================
CREATE TABLE Restaurants (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25) NOT NULL,
    Address VARCHAR(35) NOT NULL,
    PhoneNumber VARCHAR(15),
    OpeningHours VARCHAR(50)
);

-- ================================
-- TABLE: Menu
-- ================================
CREATE TABLE Menu (
    MenuID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    Availability BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- ================================
-- TABLE: Customers
-- ================================
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15),
    Address TEXT
);

-- ================================
-- TABLE: Orders
-- ================================
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    MenuID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Subtotal DECIMAL(10,2),
    TotalAmount DECIMAL(10,2),
    OrderDateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending','Processing','Completed','Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
);

-- ================================
-- TABLE: Deliveries
-- ================================
CREATE TABLE Deliveries (
    DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    DeliveryAddress TEXT NOT NULL,
    AssignedDriver VARCHAR(100),
    Status ENUM('Pending','Out for Delivery','Delivered','Cancelled') DEFAULT 'Pending',
    DeliveryTime DATETIME,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- ================================
-- SAMPLE DATA INSERTION
-- ================================

-- Restaurants
INSERT INTO Restaurants (Name, Address, PhoneNumber, OpeningHours) VALUES
('KFC', 'KIIT BBSR', '9865732415', '9 AM - 11 PM'),
('Pizza Hut', 'Cuttack', '8510900127', '10 AM - 10 PM'),
('Modiki Tapori', 'Gujarat', '9865732415', '9 AM - 11 PM'),
('Pizza Hut', 'BBSR', '8510900127', '10 AM - 10 PM');

-- Menu
INSERT INTO Menu (RestaurantID, Name, Description, Price) VALUES
(1, 'Burger Deluxe', 'Juicy burger with fries', 140),
(1, 'Chicken Bucket', 'Crispy fried chicken', 299),
(2, 'Margherita Pizza', 'Classic cheese pizza', 249),
(2, 'Veg Supreme', 'Loaded veg pizza', 349),
(3, 'Gujarati Thali', 'Traditional full thali', 199);

-- Customers
INSERT INTO Customers (Name, Email, PhoneNumber, Address) VALUES
('XXX', 'xxx@gmail.com', '9999999999', 'BBSR'),
('YYY', 'yyy@gmail.com', '8888888888', 'Cuttack'),
('ZZZ', 'zzz@gmail.com', '7777777777', 'Delhi');

-- ================================
-- TRIGGER: AUTO CALCULATE SUBTOTAL
-- ================================
DELIMITER $$

CREATE TRIGGER trg_calculate_subtotal
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE item_price DECIMAL(10,2);
    SELECT Price INTO item_price FROM Menu WHERE MenuID = NEW.MenuID;
    SET NEW.Subtotal = item_price * NEW.Quantity;
    SET NEW.TotalAmount = NEW.Subtotal;
END $$

DELIMITER ;

-- ================================
-- ORDERS
-- ================================
INSERT INTO Orders (CustomerID, RestaurantID, MenuID, Quantity)
VALUES
(1, 1, 1, 2),
(2, 2, 3, 1),
(3, 3, 5, 1);

-- ================================
-- DELIVERIES
-- ================================
INSERT INTO Deliveries (OrderID, DeliveryAddress, AssignedDriver)
VALUES
(1, 'BBSR', 'Rahul Driver'),
(2, 'Cuttack', 'Amit Rider'),
(3, 'Delhi', 'Suresh Rider');

-- ================================
-- INDEXES
-- ================================
CREATE INDEX idx_customer ON Orders(CustomerID);
CREATE INDEX idx_restaurant ON Menu(RestaurantID);

-- ================================
-- VIEW: ORDER SUMMARY
-- ================================
CREATE VIEW OrderSummary AS
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    r.Name AS RestaurantName,
    m.Name AS ItemName,
    o.Quantity,
    o.TotalAmount,
    o.Status,
    o.OrderDateTime
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
JOIN Menu m ON o.MenuID = m.MenuID;

-- ================================
-- STORED PROCEDURE
-- ================================
DELIMITER $$

CREATE PROCEDURE GetOrdersByCustomer(IN cust_id INT)
BEGIN
    SELECT * FROM Orders WHERE CustomerID = cust_id;
END $$

DELIMITER ;

-- ================================
-- SAMPLE UPDATE & DELETE
-- ================================
UPDATE Orders SET Status = 'Completed' WHERE OrderID = 1;
UPDATE Deliveries SET Status = 'Delivered', DeliveryTime = NOW() WHERE DeliveryID = 1;

-- ================================
-- REPORT QUERIES
-- ================================

-- View all orders
SELECT * FROM Orders;

-- Order summary view
SELECT * FROM OrderSummary;

-- Total sales per restaurant
SELECT r.Name, SUM(o.TotalAmount) AS TotalSales
FROM Orders o
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
GROUP BY r.Name;

-- Customer order count
SELECT c.Name, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name;

-- Delivery status
SELECT * FROM Deliveries;



-- ================================
-- DATABASE CREATION
-- ================================
CREATE DATABASE RestaurantManagement;
USE RestaurantManagement;

-- ================================
-- TABLE: Restaurants
-- ================================
CREATE TABLE Restaurants (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25) NOT NULL,
    Address VARCHAR(35) NOT NULL,
    PhoneNumber VARCHAR(15),
    OpeningHours VARCHAR(50)
);

-- ================================
-- TABLE: Menu
-- ================================
CREATE TABLE Menu (
    MenuID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    Availability BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- ================================
-- TABLE: Customers
-- ================================
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15),
    Address TEXT
);

-- ================================
-- TABLE: Orders
-- ================================
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    MenuID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Subtotal DECIMAL(10,2),
    TotalAmount DECIMAL(10,2),
    OrderDateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending','Processing','Completed','Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
);

-- ================================
-- TABLE: Deliveries
-- ================================
CREATE TABLE Deliveries (
    DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    DeliveryAddress TEXT NOT NULL,
    AssignedDriver VARCHAR(100),
    Status ENUM('Pending','Out for Delivery','Delivered','Cancelled') DEFAULT 'Pending',
    DeliveryTime DATETIME,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- ================================
-- SAMPLE DATA INSERTION
-- ================================

-- Restaurants
INSERT INTO Restaurants (Name, Address, PhoneNumber, OpeningHours) VALUES
('KFC', 'KIIT BBSR', '9865732415', '9 AM - 11 PM'),
('Pizza Hut', 'Cuttack', '8510900127', '10 AM - 10 PM'),
('Modiki Tapori', 'Gujarat', '9865732415', '9 AM - 11 PM'),
('Pizza Hut', 'BBSR', '8510900127', '10 AM - 10 PM');

-- Menu
INSERT INTO Menu (RestaurantID, Name, Description, Price) VALUES
(1, 'Burger Deluxe', 'Juicy burger with fries', 140),
(1, 'Chicken Bucket', 'Crispy fried chicken', 299),
(2, 'Margherita Pizza', 'Classic cheese pizza', 249),
(2, 'Veg Supreme', 'Loaded veg pizza', 349),
(3, 'Gujarati Thali', 'Traditional full thali', 199);

-- Customers
INSERT INTO Customers (Name, Email, PhoneNumber, Address) VALUES
('XXX', 'xxx@gmail.com', '9999999999', 'BBSR'),
('YYY', 'yyy@gmail.com', '8888888888', 'Cuttack'),
('ZZZ', 'zzz@gmail.com', '7777777777', 'Delhi');

-- ================================
-- TRIGGER: AUTO CALCULATE SUBTOTAL
-- ================================
DELIMITER $$

CREATE TRIGGER trg_calculate_subtotal
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE item_price DECIMAL(10,2);
    SELECT Price INTO item_price FROM Menu WHERE MenuID = NEW.MenuID;
    SET NEW.Subtotal = item_price * NEW.Quantity;
    SET NEW.TotalAmount = NEW.Subtotal;
END $$

DELIMITER ;

-- ================================
-- ORDERS
-- ================================
INSERT INTO Orders (CustomerID, RestaurantID, MenuID, Quantity)
VALUES
(1, 1, 1, 2),
(2, 2, 3, 1),
(3, 3, 5, 1);

-- ================================
-- DELIVERIES
-- ================================
INSERT INTO Deliveries (OrderID, DeliveryAddress, AssignedDriver)
VALUES
(1, 'BBSR', 'Rahul Driver'),
(2, 'Cuttack', 'Amit Rider'),
(3, 'Delhi', 'Suresh Rider');

-- ================================
-- INDEXES
-- ================================
CREATE INDEX idx_customer ON Orders(CustomerID);
CREATE INDEX idx_restaurant ON Menu(RestaurantID);

-- ================================
-- VIEW: ORDER SUMMARY
-- ================================
CREATE VIEW OrderSummary AS
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    r.Name AS RestaurantName,
    m.Name AS ItemName,
    o.Quantity,
    o.TotalAmount,
    o.Status,
    o.OrderDateTime
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
JOIN Menu m ON o.MenuID = m.MenuID;

-- ================================
-- STORED PROCEDURE
-- ================================
DELIMITER $$

CREATE PROCEDURE GetOrdersByCustomer(IN cust_id INT)
BEGIN
    SELECT * FROM Orders WHERE CustomerID = cust_id;
END $$

DELIMITER ;

-- ================================
-- SAMPLE UPDATE & DELETE
-- ================================
UPDATE Orders SET Status = 'Completed' WHERE OrderID = 1;
UPDATE Deliveries SET Status = 'Delivered', DeliveryTime = NOW() WHERE DeliveryID = 1;

-- ================================
-- REPORT QUERIES
-- ================================

-- View all orders
SELECT * FROM Orders;

-- Order summary view
SELECT * FROM OrderSummary;

-- Total sales per restaurant
SELECT r.Name, SUM(o.TotalAmount) AS TotalSales
FROM Orders o
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
GROUP BY r.Name;

-- Customer order count
SELECT c.Name, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name;

-- Delivery status
SELECT * FROM Deliveries;
-- ================================
-- DATABASE CREATION
-- ================================
CREATE DATABASE RestaurantManagement;
USE RestaurantManagement;

-- ================================
-- TABLE: Restaurants
-- ================================
CREATE TABLE Restaurants (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(25) NOT NULL,
    Address VARCHAR(35) NOT NULL,
    PhoneNumber VARCHAR(15),
    OpeningHours VARCHAR(50)
);

-- ================================
-- TABLE: Menu
-- ================================
CREATE TABLE Menu (
    MenuID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    Availability BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- ================================
-- TABLE: Customers
-- ================================
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15),
    Address TEXT
);

-- ================================
-- TABLE: Orders
-- ================================
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    MenuID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Subtotal DECIMAL(10,2),
    TotalAmount DECIMAL(10,2),
    OrderDateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending','Processing','Completed','Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
);

-- ================================
-- TABLE: Deliveries
-- ================================
CREATE TABLE Deliveries (
    DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    DeliveryAddress TEXT NOT NULL,
    AssignedDriver VARCHAR(100),
    Status ENUM('Pending','Out for Delivery','Delivered','Cancelled') DEFAULT 'Pending',
    DeliveryTime DATETIME,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- ================================
-- SAMPLE DATA INSERTION
-- ================================

-- Restaurants
INSERT INTO Restaurants (Name, Address, PhoneNumber, OpeningHours) VALUES
('KFC', 'KIIT BBSR', '9865732415', '9 AM - 11 PM'),
('Pizza Hut', 'Cuttack', '8510900127', '10 AM - 10 PM'),
('Modiki Tapori', 'Gujarat', '9865732415', '9 AM - 11 PM'),
('Pizza Hut', 'BBSR', '8510900127', '10 AM - 10 PM');

-- Menu
INSERT INTO Menu (RestaurantID, Name, Description, Price) VALUES
(1, 'Burger Deluxe', 'Juicy burger with fries', 140),
(1, 'Chicken Bucket', 'Crispy fried chicken', 299),
(2, 'Margherita Pizza', 'Classic cheese pizza', 249),
(2, 'Veg Supreme', 'Loaded veg pizza', 349),
(3, 'Gujarati Thali', 'Traditional full thali', 199);

-- Customers
INSERT INTO Customers (Name, Email, PhoneNumber, Address) VALUES
('XXX', 'xxx@gmail.com', '9999999999', 'BBSR'),
('YYY', 'yyy@gmail.com', '8888888888', 'Cuttack'),
('ZZZ', 'zzz@gmail.com', '7777777777', 'Delhi');

-- ================================
-- TRIGGER: AUTO CALCULATE SUBTOTAL
-- ================================
DELIMITER $$

CREATE TRIGGER trg_calculate_subtotal
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE item_price DECIMAL(10,2);
    SELECT Price INTO item_price FROM Menu WHERE MenuID = NEW.MenuID;
    SET NEW.Subtotal = item_price * NEW.Quantity;
    SET NEW.TotalAmount = NEW.Subtotal;
END $$

DELIMITER ;

-- ================================
-- ORDERS
-- ================================
INSERT INTO Orders (CustomerID, RestaurantID, MenuID, Quantity)
VALUES
(1, 1, 1, 2),
(2, 2, 3, 1),
(3, 3, 5, 1);

-- ================================
-- DELIVERIES
-- ================================
INSERT INTO Deliveries (OrderID, DeliveryAddress, AssignedDriver)
VALUES
(1, 'BBSR', 'Rahul Driver'),
(2, 'Cuttack', 'Amit Rider'),
(3, 'Delhi', 'Suresh Rider');

-- ================================
-- INDEXES
-- ================================
CREATE INDEX idx_customer ON Orders(CustomerID);
CREATE INDEX idx_restaurant ON Menu(RestaurantID);

-- ================================
-- VIEW: ORDER SUMMARY
-- ================================
CREATE VIEW OrderSummary AS
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    r.Name AS RestaurantName,
    m.Name AS ItemName,
    o.Quantity,
    o.TotalAmount,
    o.Status,
    o.OrderDateTime
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
JOIN Menu m ON o.MenuID = m.MenuID;

-- ================================
-- STORED PROCEDURE
-- ================================
DELIMITER $$

CREATE PROCEDURE GetOrdersByCustomer(IN cust_id INT)
BEGIN
    SELECT * FROM Orders WHERE CustomerID = cust_id;
END $$

DELIMITER ;

-- ================================
-- SAMPLE UPDATE & DELETE
-- ================================
UPDATE Orders SET Status = 'Completed' WHERE OrderID = 1;
UPDATE Deliveries SET Status = 'Delivered', DeliveryTime = NOW() WHERE DeliveryID = 1;

-- ================================
-- REPORT QUERIES
-- ================================

-- View all orders
SELECT * FROM Orders;

-- Order summary view
SELECT * FROM OrderSummary;

-- Total sales per restaurant
SELECT r.Name, SUM(o.TotalAmount) AS TotalSales
FROM Orders o
JOIN Restaurants r ON o.RestaurantID = r.RestaurantID
GROUP BY r.Name;

-- Customer order count
SELECT c.Name, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name;

-- Delivery status
SELECT * FROM Deliveries;


SHOW TABLES;