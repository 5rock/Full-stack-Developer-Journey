-- ================================
-- DATABASE
-- ================================
CREATE DATABASE IF NOT EXISTS RestaurantManagement;
USE RestaurantManagement;

-- ================================
-- TABLE: Restaurants
-- ================================
CREATE TABLE Restaurants (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address TEXT NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE,
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
    FOREIGN KEY (RestaurantID) 
        REFERENCES Restaurants(RestaurantID)
        ON DELETE CASCADE
);

-- ================================
-- TABLE: Customers
-- ================================
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(15) UNIQUE,
    Address TEXT
);

-- ================================
-- TABLE: Orders
-- ================================
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending','Processing','Completed','Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) 
        REFERENCES Customers(CustomerID)
        ON DELETE CASCADE
);

-- ================================
-- TABLE: OrderItems (IMPORTANT FIX)
-- ================================
CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    MenuID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10,2),
    Subtotal DECIMAL(10,2),
    FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE,
    FOREIGN KEY (MenuID) 
        REFERENCES Menu(MenuID)
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
    FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE
);

-- ================================
-- TABLE: Payments
-- ================================
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    PaymentMethod VARCHAR(50),
    PaymentStatus VARCHAR(50),
    FOREIGN KEY (OrderID) 
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE
);

-- ================================
-- SAMPLE DATA
-- ================================
INSERT INTO Restaurants (Name, Address, PhoneNumber, OpeningHours) VALUES
('KFC', 'KIIT BBSR', '9865732415', '9 AM - 11 PM'),
('Pizza Hut', 'Cuttack', '8510900127', '10 AM - 10 PM');

INSERT INTO Menu (RestaurantID, Name, Description, Price) VALUES
(1, 'Burger Deluxe', 'Juicy burger with fries', 140),
(1, 'Chicken Bucket', 'Crispy fried chicken', 299),
(2, 'Margherita Pizza', 'Classic cheese pizza', 249);

INSERT INTO Customers (Name, Email, PhoneNumber, Address) VALUES
('Ritesh', 'ritesh@gmail.com', '9999999999', 'Bhubaneswar'),
('Amit', 'amit@gmail.com', '8888888888', 'Cuttack');

-- ================================
-- TRIGGER: Set Price & Subtotal
-- ================================
DROP TRIGGER IF EXISTS trg_orderitem_insert;
DELIMITER $$

CREATE TRIGGER trg_orderitem_insert
BEFORE INSERT ON OrderItems
FOR EACH ROW
BEGIN
    DECLARE item_price DECIMAL(10,2);

    SELECT Price INTO item_price 
    FROM Menu 
    WHERE MenuID = NEW.MenuID;

    SET NEW.Price = item_price;
    SET NEW.Subtotal = item_price * NEW.Quantity;
END $$

DELIMITER ;

-- ================================
-- SAMPLE ORDERS
-- ================================
INSERT INTO Orders (CustomerID) VALUES (1), (2);

INSERT INTO OrderItems (OrderID, MenuID, Quantity) VALUES
(1,1,2),
(1,2,1),
(2,3,1);

INSERT INTO Deliveries (OrderID, DeliveryAddress, AssignedDriver) VALUES
(1,'Bhubaneswar','Rahul'),
(2,'Cuttack','Amit');

INSERT INTO Payments (OrderID, PaymentMethod, PaymentStatus) VALUES
(1,'UPI','Completed'),
(2,'Cash','Pending');

-- ================================
-- VIEW: Order Summary
-- ================================
CREATE OR REPLACE VIEW OrderSummary AS
SELECT 
    o.OrderID,
    c.Name AS CustomerName,
    m.Name AS ItemName,
    oi.Quantity,
    oi.Subtotal,
    o.Status,
    o.OrderDateTime
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Menu m ON oi.MenuID = m.MenuID;

-- ================================
-- STORED PROCEDURE
-- ================================
DROP PROCEDURE IF EXISTS GetOrdersByCustomer;
DELIMITER $$

CREATE PROCEDURE GetOrdersByCustomer(IN cust_id INT)
BEGIN
    SELECT * FROM OrderSummary 
    WHERE CustomerName = (
        SELECT Name FROM Customers WHERE CustomerID = cust_id
    );
END $$

DELIMITER ;

-- ================================
-- INDEX (Performance)
-- ================================
CREATE INDEX idx_customer ON Orders(CustomerID);

-- ================================
-- CHECK TABLES
-- ================================
SHOW TABLES;