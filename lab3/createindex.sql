-- Indexes are data structures used by the database to improve query performance. Locating the tuples in the
-- Purchases table for a particular shopperID and productID might be slow if the database system has to search the
-- entire Purchases table. To speed up that search, create an index named SearchShopperProduct over the
-- shopperID and productID columns (in that order) of the Purchases table. Save the command in the file
-- createindex.sql.
CREATE INDEX SearchShopperProduct
ON Purchases(shopperID, productID);
