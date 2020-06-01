#include <iostream>
#include <cstring>
#include <string>
#include <vector>
using namespace std;

template <typename T>
int compare(const T &t1, const T &t2)
{
    if (t1 < t2)
        return -1;
    else if (t1 > t2)
        return 1;
    return 0;
}

template <unsigned N, unsigned M>
int compare(const char (&p1)[N], const char (&p2)[M])
{
    return strcmp(p1, p2);
}

int main(int argc, char *argv[])
{
    std::cout << compare("hi", "mom") << std::endl;
    return 0;
}

