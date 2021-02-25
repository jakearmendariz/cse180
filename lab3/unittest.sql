-- Unit tests are important for verifying that your constraints are working as you expect. We will require tests for
-- just a few common cases, but there are many more unit tests that are possible.
-- For each of the 3 foreign key constraints specified in section 2.3, write one unit test:
    -- o An INSERT command that violates the foreign key constraint (and elicits an error).
INSERT INTO Markets(marketID, managerID),
VALUES(0, 0);

INSERT INTO Employees(empID),
VALUES(-1);

INSERT INTO ShoppingTrips(shopperID, tripTimeStamp, marketID),
VALUES(0, TIMESTAMP '2021-02-22', -2);

-- Also, for each of the 3 general constraints, write 2 unit tests:
    -- o An UPDATE command that meets the constraint.
UPDATE Markets
SET managerID = e.empID
FROM Employees e
LIMIT 1;
    -- o An UPDATE command that violates the constraint (and elicits an error).
UPDATE Markets
SET managerID = -1
LIMIT 1; 

-- NEED TO DO THE REST, BUT I AM UNSURE HOW TO PROCEED
-- Save these 3 + 6 = 9 unit tests, in the order given above, in the file unittests.sql