/**
 * runSupermarketApplication skeleton, to be modified by students
 * 
 * Jake Armendariz
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "libpq-fe.h"

/* These constants would normally be in a header file */
/* Maximum length of string used to submit a connection */
#define  MAXCONNECTIONSTRINGSIZE    501
/* Maximum length of string used to submit a SQL statement */
#define   MAXSQLSTATEMENTSTRINGSIZE  2001

/* Exit with success after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void good_exit(PGconn *conn)
{
    PQfinish(conn);
    exit(EXIT_SUCCESS);
}

/* Exit with failure after closing connection to the server
 *  and freeing memory that was used by the PGconn object.
 */
static void bad_exit(PGconn *conn)
{
    PQfinish(conn);
    exit(EXIT_FAILURE);
}


 /* getMarketEmpCounts:
  * marketID is an attribute in the Employees table, indicating the market at
  * which the employee works.  The only argument for the getMarketEmpCounts
  * function is the database connection.
  *
  * getMarketEmpCounts should compute the number of employees who work at each
  * of the markets that has at least one employee.  getMarketEmpCounts doesn’t
  * return anything.  It should just print the number of employees who work at
  * each of the markets that has at least one employee.  Each line out by
  * getMarketEmpCounts should have the format:
  *             Market mmm has eee Employees.
  * where mmm is a market that has at least one employee and eee is the number
  * of employees who work at that market.
  */
void getMarketEmpCounts(PGconn *conn) {
    PGresult *res = PQexec(conn,"SELECT marketID, COUNT(*) FROM Employees GROUP BY marketID"); 
    if (PQresultStatus(res) != PGRES_TUPLES_OK){ // query unsuccessful
        printf("Error, in marketEmpCounts\n");
        PQclear(res);
        bad_exit(conn);
    }
    int n = PQntuples(res);
    for (int j = 0; j < n; j++) //Print each of the results, row by row
        printf("Market %s has %s employees\n",
        PQgetvalue(res, j, 0),
        PQgetvalue(res, j, 1) );
    PQclear(res);
}


/* updateProductManufacturer:
 * manufacturer is an attribute of Product.  Sometimes the manufacturer value
 * gets changed, e.g., if the manufacturer gets acquired.
 *
 * Besides the database connection, the updateProductManufacturer function has
 * two arguments, a string argument oldProductManufacturer and another string
 * argument, newProductManufacturer.  For every product in the Products table if
 * any) whose manufacturer equals oldProductManufacturer,
 * updateProductManufacturer should update their manufacturer to be
 * newProductManufacturer.
 *
 * There might be no Products whose manufacturer equals oldProductManufacturer
 * (that’s not an error), and there also might be multiple Products whose
 * manufacturer equals oldProductManufacturer, since manufacturer is not UNIQUE.
 * updateProductManufacturer should return the number of Products whose
 * manufacturer was updated.
 */
int updateProductManufacturer(PGconn *conn,
                              char *oldProductManufacturer,
                              char *newProductManufacturer) {
    // if either parameter is null, exit
    if (oldProductManufacturer == NULL || newProductManufacturer == NULL) {
        printf("Error, one of the arguments passed into updateProductManufacturer was null\n");
        bad_exit(conn);
    }
    // Check to make sure the strings are normal length, anything longer would cause error in malloc
    if(strlen(oldProductManufacturer) + strlen(newProductManufacturer) > 194) {
        printf("Error, the length of oldProductManufacturer and newProductManufacturer were too long, max size is 194 characters total\n");
        bad_exit(conn);
    }
    char *query = (char*)malloc(255 * sizeof(char));
    //61 base characters. 255 - 61 => 194. So max length of input strings is 194
    sprintf(query, "UPDATE Products SET manufacturer = '%s' WHERE manufacturer = '%s'", newProductManufacturer, oldProductManufacturer);
    PGresult *res = PQexec(conn, query); 
    if (PQresultStatus(res) != PGRES_COMMAND_OK){
        PQclear(res);
        printf("Error, in updateProductManufacturer, update clause\n");
        bad_exit(conn);
    }
    // gets the amount of updated tuples, converts to integer
    int num_replacements = atoi(PQcmdTuples(res));
    PQclear(res);
    return num_replacements;
}


/* reduceSomePaidPrices:
 * Besides the database connection, this function has two integer parameters,
 * theShopperID, and numPriceReductions.  reduceSomePaidPrices invokes a Stored
 * Function, reduceSomePaidPricesFunction, that you will need to implement and
 * store in the database according to the description in Section 5.  The Stored
 * Function reduceSomePaidPricesFunction should have the same parameters,
 * theShopperID and numPriceReductions as reduceSomePaidPrices.  A value of
 * numPriceReductions that’s not positive is an error, and you should call
 * exit(EXIT_FAILURE).
 *
 * The Purchases table has attributes including shopperID (shopper who made the
 * purchase), productid (product that was purchased) and paidPrice (price that
 * was paid for the purchased product, which is not necessarily the same as the
 * regularPrice of that product).  reduceSomePaidPricesFunction will reduce the
 * paidPrice for some (but not necessarily all) of the purchases made by
 * theShopperID.  Section 5 explains which Purchases should have their paidPrice
 * reduced, and also tells you how much you should reduce those paidPrice values.
 * The reduceSomePaidPrices function should return the same integer result that
 * the reduceSomePaidPricesFunction Stored Function returns.
 *
 * The reduceSomePaidPrices function must only invoke the Stored Function
 * reduceSomePaidPricesFunction, which does all of the work for this part of the
 * assignment; reduceSomePaidPrices should not do the work itself.

 */

int reduceSomePaidPrices(PGconn *conn, int theShopperID, int numPriceReductions) {
    // make sure that both values are valid, exit if not
    if (numPriceReductions < 0) {
        printf("Error, numPriceReductions is less than 0\n");
        bad_exit(conn);
    }else if (theShopperID < 0) {
        printf("Error, theShopperID is less than 0\n");
        bad_exit(conn);
    }
    char *query = (char*)malloc(90 * sizeof(char));
    sprintf(query, "SELECT reduceSomePaidPricesFunction(%i, %i)", theShopperID, numPriceReductions);
    // calls the function, and check if successful
    PGresult *res = PQexec(conn,query); 
    if (PQresultStatus(res) != PGRES_TUPLES_OK){
        printf("Error in reduceSomePaidPrices, %s\n", PQresultErrorMessage(res));
        PQclear(res);
        bad_exit(conn);
    }
    // Only one value should be returned: number of price reductions preformed
    int n = atoi(PQgetvalue(res, 0, 0));
    PQclear(res);
    return n;
}

int
main(int argc, char **argv)
{
    PGconn      *conn;
    int         theResult;
    
    if (argc != 3) {
        fprintf(stderr, "Must supply userid and password\n");
        exit(EXIT_FAILURE);
    }
    
    char *userID = argv[1];
    char *pwd = argv[2];
    
    char conninfo[MAXCONNECTIONSTRINGSIZE] = "host=cse180-db.lt.ucsc.edu user=";
    strcat(conninfo, userID);
    strcat(conninfo, " password=");
    strcat(conninfo, pwd);
    
    /* Make a connection to the database */
    conn = PQconnectdb(conninfo);
    
    /* Check to see if the database connection was successfully made. */
    if (PQstatus(conn) != CONNECTION_OK) {
        fprintf(stderr, "Connection to database failed: %s\n",
                PQerrorMessage(conn));
        bad_exit(conn);
    }

        
     /* Perform the call to getMarketEmpCounts described in Section 6 of Lab4.
      * getMarketEmpCounts doesn't return anything.
      */
    printf("Output of getMarketEmpCounts\n");
    getMarketEmpCounts(conn);

        
    /* Perform the calls to updateProductManufacturer described in Section 6
     * of Lab4, and print their outputs.
     */
    int cn = updateProductManufacturer(conn, "Consolidated Noodles", "Universal Pasta");
    int ac = updateProductManufacturer(conn, "Acme Coyote", "Acme Roadrunner");

    printf("Output of updateProductManufacturer when oldProductManufacturer is 'Consolidated Noodles' and newProductManufacturer is 'Universal Pasta'\n%i\n", cn);
    printf("Output of updateProductManufacturer when oldProductManufacturer is 'Acme Coyote' and newProductManufacturer is 'Acme Roadrunner'\n%i\n", ac);
    
    
        
    /* Perform the calls to reduceSomePaidPrices described in Section 6
     * of Lab4, and print their outputs.
     */
    printf("Output of reduceSomePaidPrices\n");
    int a = reduceSomePaidPrices(conn, 3857, 2);
    int b = reduceSomePaidPrices(conn, 3857, 5);
    int c = reduceSomePaidPrices(conn, 2345, 3);
    int d = reduceSomePaidPrices(conn, 6228, 2);
    printf("reduceSomePaidPrices(%i, %i) => %i\n", 3857, 2, a);
    printf("reduceSomePaidPrices(%i, %i) => %i\n", 3857, 5, b);
    printf("reduceSomePaidPrices(%i, %i) => %i\n", 2345, 2, c);
    printf("reduceSomePaidPrices(%i, %i) => %i\n", 6228, 2, d);
    good_exit(conn);
    return 0;

}

// Output of getMarketEmpCounts
// Market 88 has 4 employees
// Market 19 has 3 employees
// Market 77 has 2 employees
// Market 10 has 2 employees
// Market 13 has 2 employees
// Output of updateProductManufacturer when oldProductManufacturer is 'Consolidated Noodles' and newProductManufacturer is 'Universal Pasta'
// 4
// Output of updateProductManufacturer when oldProductManufacturer is 'Acme Coyote' and newProductManufacturer is 'Acme Roadrunner'
// 0
// Output of reduceSomePaidPrices
// reduceSomePaidPrices(3857, 2) => 2
// reduceSomePaidPrices(3857, 5) => 1
// reduceSomePaidPrices(2345, 2) => 2
// reduceSomePaidPrices(6228, 2) => 0