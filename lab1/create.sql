/*
Jake Armendariz

create.sql
SQL script to build 6 interlinked and dependent tables
*/
CREATE TABLE Shoppers (
    shopperID INT PRIMARY KEY,
    shopperName VARCHAR(40),
    address VARCHAR(60),
    joinDate DATE,
    status CHAR(1)
);
CREATE TABLE Products (
    productID INT PRIMARY KEY,
    productName VARCHAR(40),
    manufacturer VARCHAR(40),
    regularPrice NUMERIC(5, 2)
);
CREATE TABLE Markets (
    marketID INT PRIMARY KEY,
    address VARCHAR(60),
    managerID INT,
    numCheckStands INT
);
CREATE TABLE Employees (
    empID INT PRIMARY KEY,
    empName VARCHAR(40),
    marketID INT,
    hireDate DATE,
    level CHAR(1),
    stillEmployed BOOLEAN,
    FOREIGN KEY (marketID) REFERENCES Markets(marketID)
);
CREATE TABLE ShoppingTrips (
    shopperID INT,
    tripTimestamp TIMESTAMP,
    marketID INT,
    checkStand INT,
    checkerID INT,
    payType CHAR(1),
    paymentValid BOOLEAN,
    PRIMARY KEY(shopperID, tripTimestamp),
    FOREIGN KEY (shopperID) REFERENCES Shoppers(shopperID),
    FOREIGN KEY (marketID) REFERENCES Markets(marketID),
    FOREIGN KEY (checkerID) REFERENCES Employees(empID)
);
CREATE TABLE Purchases (
    shopperID INT,
    tripTimestamp TIMESTAMP,
    productID INT, 
    quantity INT,
    paidPrice NUMERIC(5, 2),
    PRIMARY KEY(shopperID, tripTimestamp, productID),
    FOREIGN KEY (shopperID, tripTimestamp) REFERENCES ShoppingTrips(shopperID, tripTimestamp)
    FOREIGN KEY (productID) REFERENCES Products(productID)
);

