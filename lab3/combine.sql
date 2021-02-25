-- Write a file, combine.sql (which should have multiple SQL statements that are in a Serializable transaction)
-- that will do the following. For each tuple in PurchaseChanges, there might already be a tuple in the Purchases
-- that has the same primary key (that is, the same value for shopperID, tripTimestamp and productID). If there
-- isn’t a tuple in Purchases with the same primary key, then this is a new purchase that should be inserted into
-- Purchases. If there already is a tuple in Purchases with that primary key, then this is an update of information
-- about that purchase. So here are the actions that you should take.

--  -- • If there isn’t already a tuple in the Purchases table which has that shopperID, tripTimestamp and
    -- productID, then insert a tuple into the Purchases table corresponding to that PurchaseChanges tuple. Use
    -- paidPrice as provided in the PurchaseChanges tuple, and set quantity to 1

--  -- • If there already is a tuple in the Purchases table which has that shopperID, tripTimestamp and productID,
    -- then update the tuple in Purchases that has that shopperID, tripTimestamp and productID. Update
    -- paidPrice for that existing Purchases tuple based on the value of paidPrice in the PurchaseChanges tuple,
    -- and increase quantity by 2.

-- Your transaction may have multiple statements in it. The SQL constructs that we’ve already discussed in class
-- are sufficient for you to do this part (which is one of the hardest parts of Lab3).
-- START TRANSACTION SET ISOLATION LEVEL SERIALIZABLE;

INSERT INTO Purchases(shopperID, tripTimestamp, productID, quantity, paidPrice)
SELECT pc.shopperID, pc.tripTimestamp, pc.productID, 1, pc.paidPrice
FROM PurchaseChanges pc
WHERE (SELECT COUNT(*)
        FROM Purchases p
        WHERE pc.shopperID = p.shopperID
          AND pc.tripTimestamp = p.tripTimestamp
          AND pc.productID = p.productID) = 0;

UPDATE Purchases pur
SET quantity = quantity + 2, paidPrice = pc.paidPrice
FROM PurchaseChanges pc
WHERE pc.shopperID = pur.shopperID
AND pc.tripTimestamp = pur.tripTimestamp
AND pc.productID = pur.productID;

-- COMMIT;
