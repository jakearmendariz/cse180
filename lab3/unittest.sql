-- Unit tests are important for verifying that your constraints are working as you expect. We will require tests for
-- just a few common cases, but there are many more unit tests that are possible.
-- For each of the 3 foreign key constraints specified in section 2.3, write one unit test:
    -- o An INSERT command that violates the foreign key constraint (and elicits an error).
INSERT INTO Markets(marketID, managerID)
VALUES(-1, -1);

INSERT INTO Employees(empID, marketID)
VALUES(-1, -1);

-- To ensure that the shopper exists and we test the correct constraint
INSERT INTO ShoppingTrips(shopperID, tripTimeStamp, marketID)
VALUES(1003, TIMESTAMP '2021-02-22', -1);

-- Also, for each of the 3 general constraints, write 2 unit tests:

-- o An UPDATE command that meets the constraint.
UPDATE Products
SET regularPrice = 10
WHERE productID = 120;
-- o An UPDATE command that violates the constraint (and elicits an error).
UPDATE Products
SET regularPrice = -10
WHERE productID = 120;

-- o An UPDATE command that meets the constraint.
UPDATE ShoppingTrips
SET payType = 'N'
WHERE shopperID = 1012
  AND tripTimestamp = TIMESTAMP '2015-11-24 11:12:48';

-- o An UPDATE command that violates the constraint (and elicits an error).
UPDATE ShoppingTrips
SET payType = 'J'
WHERE shopperID = 1012
  AND tripTimestamp = TIMESTAMP '2015-11-24 11:12:48';

-- o An UPDATE command that meets the constraint.
UPDATE Shoppers
SET shopperName = NULL
WHERE joinDATE IS NULL;
-- o An UPDATE command that violates the constraint (and elicits an error).
UPDATE Shoppers
SET shopperName = NULL
WHERE joinDate IS NOT NULL;




-- NEED TO DO THE REST, BUT I AM UNSURE HOW TO PROCEED
-- Save these 3 + 6 = 9 unit tests, in the order given above, in the file unittests.sql