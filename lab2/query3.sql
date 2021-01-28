-- Output the productID, manufacturer and regularPrice for every product that has the highest regular price
-- of any product from its manufacturer. Careful: For some manufacturers, they might be multiple products
-- that have the same highest regular price. No duplicates should appear in your result.
SELECT DISTINCT p1.productID, DISTINCT p1.manufacturer, p1.regularPrice
FROM Products p1
WHERE (SELECT MAX(p2.regularPrice)
       FROM Products p2
       WHERE p2.manufacturer == p1.manufacturer);