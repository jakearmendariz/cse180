-- Find all the products whose manufacturer has the string Acme (appearing as consecutive letters with that
-- exact capitalization) in it, and whose regular price is more the 9.98. The output of your query should
-- have attributes productName, manufacturer and regularPrice. Tuples in your result should be ordered in
-- alphabetical order of manufacturer, with products from the same manufacturer appearing with
-- decreasing regularPrice.
-- No duplicates should appear in your result.

SELECT DISTINCT pr.productName, pr.manufacturer, pr.regularPrice
FROM Products pr
WHERE pr.manufacturer LIKE '%Acme%'
    AND pr.regularPrice > 9.98
ORDER BY pr.manufacturer ASC, pr.regularPrice DESC;