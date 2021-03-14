#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main() {
char *query = (char*)malloc(255 * sizeof(char));
sprintf(query, "%s got back", NULL);
printf("%s\n", query);
}
