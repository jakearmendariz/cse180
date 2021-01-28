-- numCheckstands is an attribute of the Markets table that indicates how many check stands that are in
-- that market. Hence each check stand in a market should have a value that’s between 1 and the number of
-- numCheckstands for that market; we’ll say that those are valid check stands for that market.

-- checkStand is an attribute of ShoppingTrips. Write a SQL query that identifies the shopping trips for
-- which checkStand is not valid. The output of your query should be the marketID of that shopping trip,
-- numCheckstands for that market, and the invalid checkStand in that shopping trip.

-- No duplicates should appear in your result.

--  Problem! This is only distinct for marketID, there should be distinct tuples not one attirbute
SELECT DISTINCT m.marketID, m.numCheckStands, st.checkStand
FROM Markets m, ShoppingTrips st
WHERE m.marketID = st.marketID 
  AND st.checkStand > m.numCheckStands OR st.checkStand < 1;