CREATE TABLE Shoppers (
    shopperID INT,
    shopperName VARCHAR(40),
    address VARCHAR(60),
    joinDate DATE,
    status CHAR(1)
);
CREATE TABLE Products (
    productID INT,
    productName VARCHAR(40),
    manufacturer VARCHAR(40),
    regularPrice NUMERIC(5, 2)
);
CREATE TABLE Markets (
    marketID INT,
    address VARCHAR(60),
    managerID INT,
    numCheckStands INT
);
CREATE TABLE Employees (
    empID INT,
    empName VARCHAR(40),
    marketID INT,
    hireDate DATE,
    level CHAR(1),
    stillEmployed BOOLEAN
);
CREATE TABLE ShoppingTrips (
    shopperID INT,
    tripTimestamp TIMESTAMP,
    marketID INT,
    checkStand INT,
    checkerID INT,
    payType CHAR(1),
    paymentValid BOOLEAN
);
CREATE TABLE Purchases (
    shopperID INT,
    tripTimestamp TIMESTAMP,
    productID INT, 
    quantity INT,
    paidPrice NUMERIC(5, 2)
);