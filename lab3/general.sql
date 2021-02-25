-- General constraints for Lab3 are:

-- 1.In Products, regularPrice must be greater than zero. Please give a name to this constraint when you create it.
-- We recommend that you use the name positive_regularPrice, but you may use another name. The other general
-- constraints don’t need names, but you may name them if you’d like.

ALTER TABLE Products
ADD CONSTRAINT positive_regularPrice 
CHECK (regularPrice > 0);


-- 2. In ShoppingTrips, the value of payType must be either ‘N’, ‘V’, ‘A’, ‘C’ or NULL.

ALTER TABLE ShoppingTrips
CHECK (payType = 'N' OR payType = 'V' OR payType = 'A' OR payType = 'C' OR payType = NULL);


-- 3. In Shoppers, if shopperName is NULL, then joinDate must also be NULL.
ALTER TABLE Shoppers
CHECK ((shopperName IS NOT NULL) OR (shopperName IS NULL AND joinDate IS NULL));
-- Write commands to add general constraints in the order the constraints are described above, and save your
-- commands to the file general.sql. (Note that UNKNOWN for a Check constraint is okay, but FALSE isn’t.)