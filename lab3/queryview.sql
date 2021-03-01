-- For this part of Lab3, you’ll write a script called queryview.sql that contains a query that uses
-- CheapShoppingTripCost (and possibly some tables). In addition to that query, you’ll must also include some
-- comments in the queryview.sql script; we’ll describe those necessary comments below.
-- Write and run a SQL query over the CheapShoppingTripCost view to answer the following “Bad Shopping
-- Trip” question. You may want to use some tables to write this query, but be sure to use the view.
-- For some of the cheap shopping trips that appear in the CheapShoppingTripCost view, paymentValid is
-- FALSE and the joinDate for the shopper is NULL. We’ll say that this is a “Bad Shopping Trip”. (Yeah,
-- it’s not just cheap, it’s also bad.)

-- Write a query that finds all the Bad Shopping Trips. The output of your “Bad Shopping Trip” query
-- should be the name of the shopper, and both the tripTimestamp and the totalCost of the bad shopping trip.
-- No duplicates should appear in your result.

SELECT s.shopperName, c.tripTimeStamp, c.totalCost
FROM CheapShoppingTripCost c, Shoppers s, ShoppingTrips sh
WHERE c.shopperID = s.shopperID AND c.shopperID = sh.shopperID AND c.tripTimeStamp = sh.tripTimeStamp
  AND sh.paymentValid = FALSE AND s.joinDate IS NULL;

--   shoppername  |    triptimestamp    | totalcost 
-- ---------------+---------------------+-----------
--  David Barbara | 2019-05-07 12:01:02 |     33.00
-- (1 row)

-- Important: Before running this query, recreate the Lab3 schema once again using the lab3_create.sql script,
-- and load the data using the script lab3_data_loading.sql. That way, any changes that you’ve done for previous
-- parts of Lab3 (e.g., Unit Test) won’t affect the results of this query. Then write the results of the “Bad
-- Shopping Trip” query in a comment. The format of that comment is not important; it just has to have all the
-- right information in it.

-- Next, write commands that delete just the tuples that have the following Primary Keys from the Purchases table:
--     • The tuple whose Primary Key is (1576, 2019-08-27 16:30:53, 197)
--     • The tuple whose Primary Key is (1012, 2015-11-24 11:12:48, 171)
DELETE FROM Purchases
WHERE shopperID = 1576
  AND tripTimestamp = TIMESTAMP '2019-08-27 16:30:53'
  AND productID = 197;

DELETE FROM Purchases
WHERE shopperID = 1012
  AND tripTimestamp = TIMESTAMP '2015-11-24 11:12:48'
  AND productID = 171;

SELECT s.shopperName, c.tripTimeStamp, c.totalCost
FROM CheapShoppingTripCost c, Shoppers s, ShoppingTrips sh
WHERE c.shopperID = s.shopperID AND c.shopperID = sh.shopperID AND c.tripTimeStamp = sh.tripTimeStamp
  AND sh.paymentValid = FALSE AND s.joinDate IS NULL;

--    shoppername   |    triptimestamp    | totalcost 
-- -----------------+---------------------+-----------
--  Elijah Tau      | 2015-11-24 11:12:48 |     23.50
--  Robert Jennifer | 2019-08-27 16:30:53 |     46.00
--  David Barbara   | 2019-05-07 12:01:02 |     33.00
-- (3 rows)
--     Run the “Bad Shopping Trip” query once again after those deletions. Write the output of the query in a second
--     comment. Do you get a different answer?
--     You need to submit a script named queryview.sql containing your query on the views. In that file you must also
--     include:
--     • the comment with the output of the query on the provided data before the deletions,
--     • the SQL statements that delete the tuples indicated above,
--     • and a second comment with the second output of the same query after the deletions.
--     You do not need to replicate the query twice in the queryview.sql file (but you won’t be penalized if you do).
--     Aren’t you glad that you had the CheapShoppingTripCost view? It probably was easier to write this query
--     using that view than it would have been if you hadn’t had that view.
