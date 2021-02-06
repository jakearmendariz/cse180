-- Find the shoppers who made shopping trips that have a timestamp that’s after October 28, 2019, 3:00pm,
-- to at least two different markets that are managed by an employee whose name is Emma Wang.
-- Your output should provide the shopper’s ID, name and address, but the attribute names in your result
-- should appear as sid, sname and saddress. No duplicates should appear in your result.

SELECT DISTINCT sh.shopperID as "sid", sh.shopperName as "sname", sh.address as "saddress"
FROM Shoppers sh, ShoppingTrips st
WHERE st.shopperID = sh.shopperID
  AND st.tripTimestamp > TIMESTAMP("2019-10-28", "15:00:00")
  AND st.checkerID = 'Emma Wang';
  