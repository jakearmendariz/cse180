

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

-- UPDATE Purchases p
-- WHERE p.shopperID = shopperID 
-- AND p.paidPrice < (SELECT products.regularPrice FROM Products products WHERE p.productID = products.productID)
--     if numPriceReductions < 0 THEN BREAK
--     ENDIF;
--     IF p.status = 'L' THEN SET p.paidPrice =  p.paidPrice - 0.5, numPriceReductions -=1
--     ELSEIF p.status = 'M' THEN SET  p.paidPrice =  p.paidPrice - 1, numPriceReductions -=1
--     ELIF p.status = 'H' THEN SET  p.paidPrice =  p.paidPrice - 2, numPriceReductions -=1
--     ENDIF;

CREATE OR REPLACE FUNCTION reduceSomePaidPricesFunction(IN theShopperID INTEGER, numPriceReductions INTEGER)
    DECLARE subtractAbleAmount FLOAT
BEGIN  
    SET subtractAbleAmount = statusToSubtractable(ShopperID);
    CREATE VIEW reducablePurchases AS
    SELECT * FROM Purchases p 
    WHERE p.shopperID = theShopperID 
      AND p.paidPrice = (SELECT pro.regularPrice FROM Products pro
                            WHERE pro.productId = p.productID)
    ORDER BY p.paidPrice DESC
    LIMIT numPriceReductions;

    UPDATE Purchases p
    SET paidPrice = paidPrice - subtractAbleAmount
    FROM reducablePurchases r
    WHERE r.productID = p.productID
      AND r.shopperID = theShopperID
      AND r.tripTimestamp = p.tripTimestamp;
END;


CREATE OR REPLACE FUNCTION statusToSubtractable(IN theShopperID INTEGER)
    RETURNS FLOAT
    DECLARE subtractAbleAmount FLOAT
    DECLARE status NUMERIC(2,1);
BEGIN
    SET status = (SELECT sh.status FROM sh.Shoppers WHERE sh.shopperID = theShopperID);
    IF status = 'L' THEN RETURN 0.5;
    ELSEIF status = 'M' THEN RETURN 1.0;
    ELIF status = 'H' THEN RETURN 2.0;
    ENDIF;
END;



-- UPDATE Purchases p
-- WHERE p.shopperID = shopperID 
-- AND p.paidPrice < (SELECT products.regularPrice FROM Products products WHERE p.productID = products.productID)
--     if numPriceReductions < 0 THEN BREAK
--     ENDIF;

-- Find shoppers who bought products at the same price
-- SELECT pur.shopperID
-- FROM Purchases pur, Products p
-- WHERE pur.productID = p.productID
--   AND pur.paidPrice = p.regularPrice;


-- CREATE OR REPLACE VIEW reducablePurchases AS
-- SELECT * FROM Purchases p 
-- WHERE p.shopperID = 1005 
--     AND p.paidPrice = (SELECT pro.regularPrice FROM Products pro
--                         WHERE pro.productId = p.productID)
-- ORDER BY p.paidPrice DESC
-- LIMIT 3;

--  UPDATE Purchases p
--     SET paidPrice = p.paidPrice - 1
--     FROM reducablePurchases r
--     WHERE r.productID = p.productID
--       AND r.shopperID = p.shopperID
--       AND r.tripTimestamp = p.tripTimestamp;

-- SELECT *
-- FROM Purchases p, reducablePurchases r
-- WHERE r.productID = p.productID
--       AND r.shopperID = p.shopperID
--       AND r.tripTimestamp = p.tripTimestamp;
   



-- CREATE OR REPLACE FUNCTION reduceSomePaidPricesFunction (theShopperID INTEGER, numPriceReductions INTEGER) RETURNS INTEGER
-- AS $$
-- BEGIN
-- DECLARE SECTION;
--     int marketID; int empCount;
-- EXEC SQL DECLARE c CURSOR FOR 
--     SELECT market, COUNT(*)
--     FROM EMPLOYEES
--     GROUP BY marketID;
-- EXEC SQL OPEN CURSOR c;
-- while(1) {
--     EXEC SQL FETCH c
--         INTO :marketID, :empCount;
--     if (NOT_FOUND) break;
--     printf("Market %i has %i employees", marketID, empCount);





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