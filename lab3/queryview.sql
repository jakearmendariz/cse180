

SELECT s.shopperName, c.tripTimeStamp, c.totalCost
FROM CheapShoppingTripCost c, Shoppers s, ShoppingTrips sh
WHERE c.shopperID = s.shopperID AND c.shopperID = sh.shopperID AND c.tripTimeStamp = sh.tripTimeStamp
  AND sh.paymentValid = FALSE AND s.joinDate IS NULL;

--   shoppername  |    triptimestamp    | totalcost 
-- ---------------+---------------------+-----------
--  David Barbara | 2019-05-07 12:01:02 |     33.00
-- (1 row)

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
