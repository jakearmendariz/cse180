-- 1. Greater than 0 regular price
ALTER TABLE Products
ADD CONSTRAINT positive_regularPrice 
CHECK (regularPrice > 0);


-- 2. Paytype is one of the following
ALTER TABLE ShoppingTrips
ADD CONSTRAINT paytype_valid
CHECK (payType LIKE 'N' OR payType LIKE 'V' OR payType LIKE 'A' OR payType LIKE 'C' OR payType IS NULL);


-- 3. In Shoppers, if shopperName is NULL, then joinDate must also be NULL.
ALTER TABLE Shoppers
ADD CONSTRAINT shopper_join_null_rule
CHECK ((shopperName IS NOT NULL) OR (shopperName IS NULL AND joinDate IS NULL));