#include <stdio.h>
#include <unistd.h>

int main() {
    char *pw = getpass("Enter password: ");
    printf("Your password: %s\n", pw);
    return 0;
}
