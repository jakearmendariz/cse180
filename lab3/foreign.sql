-- Important: Before running Sections 2.3, 2.4 and 2.5, recreate the Lab3 schema using the lab3_create.sql
-- script, and load the data using the script lab3_data_loading.sql. That way, any database changes that you’ve
-- done for Combine won’t propagate to these other parts of Lab3.

-- Here’s a description of the Foreign Keys that you need to add for this assignment. (Foreign Key Constraints are
-- also referred to as Referential Integrity constraints. The lab3_create.sql file that we’ve provided for Lab3
-- includes the same Referential Integrity constraints that were in the Lab2 solution, but you’re asked to use
-- ALTER to add additional constraints to the Supermarket schema.

-- The load data that you’re provided with should not cause any errors when you add these constraint. Just add the
-- constraints listed below, exactly as described, even if you think that additional Referential Integrity constraints
-- should exist. Note that (for example) when we say that every manager (managerID) in the Markets table must
-- appear in the Employees table, that means that the managerID attribute of the Markets table is a Foreign Key
-- referring to the Primary Key of the Employees table.

    -- Each manager (managerID) in the Markets table must appear in the Employees table as an empID.
    -- (Explanation of what that means appear in the above paragraph.) If an Employees tuple is deleted and
    -- there is a Markets that refers to that employee, then the deletion should be rejected. Also, if the
    -- Primary Key of an Employees tuple is updated, and there is a market whose manager corresponds to
    -- that person, then the update should also be rejected.

ALTER TABLE Markets
ADD FOREIGN KEY (managerID) REFERENCES Employees (empID)
ON DELETE RESTRICT;

    
    -- Each market (marketID) that’s in the Employees table must appear in the Markets table as a marketID.
    -- If a tuple in the Markets table is deleted, then all Employees in which that market (marketID) appears
    -- should also be deleted. If the Primary Key (marketID) of a Markets tuple is updated, then all
    -- Employees tuples who have that marketID should also be updated, getting the same new value for their
    -- marketID.
ALTER TABLE Employees
ADD FOREIGN KEY (marketID) REFERENCES Markets (marketID)
ON DELETE CASCADE
ON UPDATE CASCADE ;

    -- Each market (marketID) that’s in the ShoppingTrips table must either be NULL or appear in the
    -- Markets table as a marketID. If a tuple in the Markets table is deleted, then the marketID for all tuples
    -- in the ShoppingTrips table which match that marketID should be set to NULL. If the Primary Key
    -- (marketID) of a Markets tuple is updated, then all ShoppingTrips tuples that have the corresponding
    -- marketID should also be updated, getting the same new value for their marketID.

ALTER TABLE ShoppingTrips
ADD FOREIGN KEY (marketID) REFERENCES Markets (marketID)
ON UPDATE CASCADE
ON DELETE SET NULL;
