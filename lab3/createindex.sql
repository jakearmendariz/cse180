-- Indexes are data structures used by the database to improve query performance. Locating the tuples in the
-- Purchases table for a particular shopperID and productID might be slow if the database system has to search the
-- entire Purchases table. To speed up that search, create an index named SearchShopperProduct over the
-- shopperID and productID columns (in that order) of the Purchases table. Save the command in the file
-- createindex.sql.
CREATE INDEX SearchShopperProduct
ON Purchases(shopperID, productID)
-- Of course, you can run the same SQL statements whether or not this index exists; having indexes just changes
-- the performance of SQL statements. But this index could make it faster to determine if there are any purchases
-- by a particular shopperID of a particular productID, or find all purchases made by a particular shopperID.
-- For this assignment, you need not do any searches that use the index, but if you’re interested, you might want to
-- do searches with and without the index, and look at query plans using EXPLAIN to see how queries are
-- executed. Please refer to the documentation of PostgreSQL on EXPLAIN that’s at
-- https://www.postgresql.org/docs/12/sql-explain.html