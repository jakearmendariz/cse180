-- NUMBER OF PURCHASES BOUGHT FOR RETAIL PRICE BY CUSTOMER
--  shopperid | count 
-- -----------+-------
--       1005 |     1
--       1009 |     2
--       1010 |     2
--       1245 |     2
--       2178 |     2
--       2345 |     2
--       3857 |     3
--       6228 |     1
-- (8 rows)
-- -- Find shoppers who bought products at the same price
SELECT pur.shopperID, COUNT(*)
FROM Purchases pur, Products p
WHERE pur.productID = p.productID
  AND pur.paidPrice = p.regularPrice
GROUP BY pur.shopperID;

CREATE OR REPLACE FUNCTION reduceSomePaidPricesFunction(theShopperID INTEGER, numPriceReductions INTEGER) RETURNS INTEGER
AS $$
    DECLARE 
    subtractAbleAmount NUMERIC(2,1);
    result INTEGER;
    ass INTEGER;
BEGIN  
    SELECT INTO subtractAbleAmount statusToSubtractable(theShopperID);
    EXECUTE 'CREATE OR REPLACE VIEW reducablePurchases AS
        SELECT * FROM Purchases p 
        WHERE p.shopperID = ' ||$1||'
        AND p.paidPrice = (SELECT pro.regularPrice FROM Products pro
                                WHERE pro.productId = p.productID)
        ORDER BY p.paidPrice DESC
        LIMIT '||$2||'';

    UPDATE Purchases p
    SET paidPrice = p.paidPrice - subtractAbleAmount
    FROM reducablePurchases r
    WHERE r.productID = p.productID
      AND r.shopperID = theShopperID
      AND r.tripTimestamp = p.tripTimestamp;
    
    GET DIAGNOSTICS result = ROW_COUNT;
    IF subtractAbleAmount = 0 THEN result := 0;
    END IF;
    RETURN result;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION statusToSubtractable(theShopperID INTEGER) RETURNS NUMERIC(2,1) 
AS $$
    DECLARE 
    subtractAbleAmount NUMERIC(2,1);
    status CHAR;
BEGIN
    SELECT sh.status INTO status FROM Shoppers sh WHERE sh.shopperID = theShopperID;
    IF status = 'L' THEN RETURN 0.5;
    ELSEIF status = 'M' THEN RETURN 1.0;
    ELSEIF status = 'H' THEN RETURN 2.0;
    ELSE RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;
