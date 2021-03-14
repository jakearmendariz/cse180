-- Jake Armendariz

CREATE OR REPLACE FUNCTION reduceSomePaidPricesFunction(theShopperID INTEGER, numPriceReductions INTEGER) RETURNS INTEGER
AS $$
    DECLARE 
    subtractAbleAmount NUMERIC(2,1);
    result INTEGER;
    ass INTEGER;
BEGIN  
    -- Find the value we are suppose to subtract for each shopper
    SELECT INTO subtractAbleAmount statusToSubtractable(theShopperID);
    -- Build a view, this view should have the the list of purchases paid at regular price, by theShopperID sorted in descending order with a limit
    EXECUTE 'CREATE OR REPLACE VIEW reducablePurchases AS
        SELECT * FROM Purchases p 
        WHERE p.shopperID = ' ||$1||'
        AND p.paidPrice = (SELECT pro.regularPrice FROM Products pro
                                WHERE pro.productId = p.productID)
        ORDER BY p.paidPrice DESC
        LIMIT '||$2||'';
    -- Update the values from the view
    UPDATE Purchases p
    SET paidPrice = p.paidPrice - subtractAbleAmount
    FROM reducablePurchases r
    WHERE r.productID = p.productID
      AND r.shopperID = theShopperID
      AND r.tripTimestamp = p.tripTimestamp;
    -- Count the rows affected by the update
    GET DIAGNOSTICS result = ROW_COUNT;
    IF subtractAbleAmount = 0 THEN result := 0;
    END IF;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- From the status char, we need to find the subtractable amount if they paid full price for an item
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
