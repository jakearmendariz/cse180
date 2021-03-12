

--  Here’s how to determine which Purchases should have their paidPrice reduced, and how much that
-- reduction should be:
-- • status is an attribute in the Shoppers table. status is ‘L’ for a low status shopper, ‘M’ for a
-- medium status shopper, and ‘H’ for a high status shopper. status can also be NULL,
-- indicating that there is no status for that shopper.

-- • You’ll reduce paidPrice for some of the Purchases whose shopperID equals theShopperID.
-- The reduction should be 2 for a high status shopper, 1 for a medium status shopper, and
-- 0.50 for a low status shopper. (Make no reductions if the shopper’s status is NULL.)

-- • A “Regular Price Purchase” is a purchase whose paidPrice equals the regularPrice of the
-- productid that was purchased. Only reduce paidPrice for “Regular Price Purchases”.

-- • However, you won’t reduce paidPrice for more than numPriceReductions purchases made
-- by theShopperID. To determine which paidPrice values should be reduced, order these
-- purchases by paidPrice in descending order, so that the highest paidPrice value comes first.
-- The first numPriceReductions purchases according to that ordering should have paidPrice
-- reduced by the appropriate amount, based on the status of theShopper.

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
-- SELECT pur.shopperID, COUNT(*)
-- FROM Purchases pur, Products p
-- WHERE pur.productID = p.productID
--   AND pur.paidPrice = p.regularPrice
-- GROUP BY pur.shopperID;

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

    -- SELECT COUNT(*) INTO result 
    -- FROM reducablePurchases r, Purchases p
    -- WHERE r.productID = p.productID
    --   AND r.shopperID = theShopperID
    --   AND r.tripTimestamp = p.tripTimestamp;

    UPDATE Purchases p
    SET paidPrice = p.paidPrice - subtractAbleAmount
    FROM reducablePurchases r
    WHERE r.productID = p.productID
      AND r.shopperID = theShopperID
      AND r.tripTimestamp = p.tripTimestamp;
    
    GET DIAGNOSTICS result = ROW_COUNT;
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
--------

-- CREATE OR REPLACE FUNCTION reduceSomePaidPricesFunction(INTEGER, INTEGER) RETURNS INTEGER
-- AS $$
--     DECLARE 
--     subtractAbleAmount NUMERIC(2,1);
--     result INTEGER;
-- BEGIN  
--     SELECT INTO subtractAbleAmount statusToSubtractable($1);
--     CREATE OR REPLACE VIEW reducablePurchases AS
--     SELECT * FROM Purchases p 
--     WHERE p.shopperID = $1 
--       AND p.paidPrice = (SELECT pro.regularPrice FROM Products pro
--                             WHERE pro.productId = p.productID)
--     ORDER BY p.paidPrice DESC
--     LIMIT $1;

--     SELECT COUNT(*) INTO result 
--     FROM reducablePurchases r
--     WHERE r.productID = p.productID
--       AND r.shopperID = theShopperID
--       AND r.tripTimestamp = p.tripTimestamp;

--     UPDATE Purchases p
--     SET paidPrice = paidPrice - subtractAbleAmount
--     FROM reducablePurchases r
--     WHERE r.productID = p.productID
--       AND r.shopperID = theShopperID
--       AND r.tripTimestamp = p.tripTimestamp;
    
--     RETURN result;
-- END;
-- $$ LANGUAGE plpgsql;


-- CREATE OR REPLACE FUNCTION statusToSubtractable(theShopperID INTEGER) RETURNS NUMERIC(2,1) 
-- AS $$
--     DECLARE 
--     subtractAbleAmount NUMERIC(2,1);
--     status CHAR;
-- BEGIN
--     SELECT sh.status INTO status FROM Shoppers sh WHERE sh.shopperID = theShopperID;
--     IF status = 'L' THEN RETURN 0.5;
--     ELSEIF status = 'M' THEN RETURN 1.0;
--     ELSEIF status = 'H' THEN RETURN 2.0;
--     ELSE RETURN 0;
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;



-- -- UPDATE Purchases p
-- -- WHERE p.shopperID = shopperID 
-- -- AND p.paidPrice < (SELECT products.regularPrice FROM Products products WHERE p.productID = products.productID)
-- --     if numPriceReductions < 0 THEN BREAK
-- --     ENDIF;




-- -- CREATE OR REPLACE VIEW reducablePurchases AS
-- -- SELECT * FROM Purchases p 
-- -- WHERE p.shopperID = 1005 
-- --     AND p.paidPrice = (SELECT pro.regularPrice FROM Products pro
-- --                         WHERE pro.productId = p.productID)
-- -- ORDER BY p.paidPrice DESC
-- -- LIMIT 3;

-- --  UPDATE Purchases p
-- --     SET paidPrice = p.paidPrice - 1
-- --     FROM reducablePurchases r
-- --     WHERE r.productID = p.productID
-- --       AND r.shopperID = p.shopperID
-- --       AND r.tripTimestamp = p.tripTimestamp;

-- -- SELECT *
-- -- FROM Purchases p, reducablePurchases r
-- -- WHERE r.productID = p.productID
-- --       AND r.shopperID = p.shopperID
-- --       AND r.tripTimestamp = p.tripTimestamp;
   



    --          o What happens if the number of “Regular Price Purchases” is more than
--     numPriceReductions? Only the first numPriceReductions paidPrice values are
--     reduced, and the value returned by the Stored Function is numPriceReductions.
--          o What happens if the number of “Regular Price Purchases” is equal to
--     numPriceReductions? Those numPriceReductions paidPrice values are reduced,
--     and the value returned by the Stored Function is numPriceReductions.
--          o What happens if the number of “Regular Price Purchases” is less than
--     numPriceReductions? paidPrice values for all of those purchases are reduced, and
--     the value returned by the Stored Function is the actual number of purchases whose
--     paidPrice was reduced, which will be less than numPriceReductions