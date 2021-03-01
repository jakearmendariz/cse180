BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

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

COMMIT;
