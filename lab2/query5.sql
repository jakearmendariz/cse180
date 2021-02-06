-- For every purchase that has all of the following properties:
-- • quantity is 3 or more.
-- • payType isn't NULL.
-- • The purchase was on February 5, 2020.
-- • The paid price for the product is less than the regular price for that product.

-- you should output the name of the shopper, the name of the product purchased, and the paid price. No
-- duplicates should appear in your result.

-- [If you have an attribute theTimestamp that is a timestamp, you can extract the date from that timestamp
-- as follows: You can write DATE(theTimestamp), or you can write theTimestamp::DATE in your SQL
-- statement. Both work in PostgreSQL; similar functionality is provided by other major SQL
-- implementations.]


SELECT sh.shopperName, pr.productName, p.paidPrice
FROM Purchases p, Products pr, Shopper sh, ShoppingTrip st
WHERE p.productID = pr.productID
  AND p.shopperID = sh.shopperID
  AND st.shopperID = p.shopperID
  AND st.timestamp = p.timestamp
  AND st.payType IS NOT NULL
  AND p.quantity > 3
  AND DATE(p.tripTimestamp) = DATE("2020-02-5")
  AND p.paidPrice < pr.regularPrice;




SELECT p.proppaidPrice, 
FROM Purchases p
WHERE p.quantity > 3
  AND p.tripTimestamp > TIMESTAMP('2020-02-5', '0:00:00')
  AND p.tripTimestamp < TIMESTAMP('2020-02-6', '0:00:00')
  AND IS NOT NULL (
    SELECT st.payType
    FROM ShoppingTrips st
    WHERE st.shopperID = p.shopperID
      AND st.timestamp = p.timestamp
  )
  AND p.paidPrice < (
    SELECT pr.regularPrice
    FROM Products pr
    WHERE p.productID = pr.productID
  )

