-- Find all the products whose manufacturer has the string Acme (appearing as consecutive letters with that
-- exact capitalization) in it, and whose regular price is more the 9.98. The output of your query should
-- have attributes productName, manufacturer and regularPrice. Tuples in your result should be ordered in
-- alphabetical order of manufacturer, with products from the same manufacturer appearing with
-- decreasing regularPrice.
-- No duplicates should appear in your result.

SELECT DISTINCT productName, manufacturer, regularPrice
FROM Products
WHERE productName LIKE '%Acme1%' And regularPrice > 9.98
ORDER BY manufacturer ASC, regularPrice DESC;