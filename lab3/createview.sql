-- 2.6.1 Create a View
-- quantity and paidPrice are attributes in the Purchases table, providing information about the purchase of
-- a product by a shopper. paidPrice is the price paid for each individual item of the product.
-- We’ll say that the “full purchase cost” of a purchased product (which is not an attribute of the Purchases
-- table) equals quantity * paidPrice. For example, if a purchase of a product has quantity 7 and paidPrice 4,
-- then the “full purchase cost” for that product is 7*4 = 28.

-- We can also compute the total cost of a shopping trip by adding up the “full purchase cost” for all the
-- products that were purchased in that shopping trips.

-- Create a view called CheapShoppingTripCost that has three attributes, shopperID, tripTimestamp and totalCost.
-- This view should have a tuple for each (shopperID, tripTimestamp) in the ShoppingTrips table that gives the
-- total cost for that shopping trip. Your view should have no duplicates in it.

-- As you’ve probably already deduced, you’ll need to use a GROUP BY in your view. But there’s an additional
-- requirement: Don’t include a shopping trip in your view unless both a) the total cost of the shopping trip is
-- under 100, and b) quantity for every purchase in that shopping trip is less than 3.

-- CREATE VIEW CheapShoppingTripCost AS
-- SELECT st.shopperID, st.tripTimeStamp, totalCost
-- FROM ShoppingTrips st
-- WHERE 100 > (SELECT SUM(quantity * paidPrice) as totalCost
--             FROM Purchases p
--             WHERE quantity < 3
--               AND p.shopperID = shopperID
--               AND p.tripTimeStamp = tripTimeStamp);


CREATE VIEW CheapShoppingTripCost AS
SELECT st.shopperID, st.tripTimeStamp, SUM(p.quantity * p.paidPrice) as totalCost
FROM ShoppingTrips st, Purchases p
WHERE p.quantity < 3
  AND p.shopperID = st.shopperID
  AND p.tripTimeStamp = st.tripTimeStamp
  AND 3 > (SELECT MAX(p2.quantity) FROM Purchases p2 WHERE p2.tripTimeStamp = st.tripTimeStamp AND p2.shopperID = st.shopperID)
GROUP BY st.shopperID, st.tripTimestamp
HAVING SUM(p.quantity * p.paidPrice) < 100;
