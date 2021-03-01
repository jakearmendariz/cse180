-- Jake Armendariz

-- Foreign.sql#1
INSERT INTO Markets(marketID, managerID)
VALUES(-1, -1);
-- Foreign.sql#2
INSERT INTO Employees(empID, marketID)
VALUES(-1, -1);
-- Foreign.sql#3
INSERT INTO ShoppingTrips(shopperID, tripTimeStamp, marketID)
VALUES(1003, TIMESTAMP '2021-02-22 11:12:48', -1);

-- Also, for each of the 3 general constraints, write 2 unit tests:
-- general.sql#1 correct
UPDATE Products
SET regularPrice = 10
WHERE productID = 120;
-- general.sql#1 violates
UPDATE Products
SET regularPrice = -10
WHERE productID = 120;

-- general.sql#2 correct
UPDATE ShoppingTrips
SET payType = 'N'
WHERE shopperID = 1012
  AND tripTimestamp = TIMESTAMP '2015-11-24 11:12:48';

-- general.sql#2 violates
UPDATE ShoppingTrips
SET payType = 'J'
WHERE shopperID = 1012
  AND tripTimestamp = TIMESTAMP '2015-11-24 11:12:48';

-- general.sql#3 correct
UPDATE Shoppers
SET shopperName = NULL
WHERE joinDATE IS NULL;
-- general.sql#3 violates
UPDATE Shoppers
SET shopperName = NULL
WHERE joinDate IS NOT NULL;
