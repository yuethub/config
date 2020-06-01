#include <stdio.h>

void sock_write(char *msg, size_t len)
{
    printf("size_t: %lu", sizeof(int));
    printf("size_t: %lu", sizeof(long long unsigned));
}

int main()
{
    sock_write(NULL, 0);
    return 0;
}
