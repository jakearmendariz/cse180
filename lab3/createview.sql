-- createview.sql

CREATE VIEW CheapShoppingTripCost AS
SELECT st.shopperID, st.tripTimeStamp, SUM(p.quantity * p.paidPrice) as totalCost
FROM ShoppingTrips st, Purchases p
WHERE p.shopperID = st.shopperID
  AND p.tripTimeStamp = st.tripTimeStamp
  AND 3 > (SELECT MAX(p2.quantity) FROM Purchases p2 WHERE p2.tripTimeStamp = st.tripTimeStamp AND p2.shopperID = st.shopperID)
GROUP BY st.shopperID, st.tripTimestamp
HAVING SUM(p.quantity * p.paidPrice) < 100;
