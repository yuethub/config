#include <sys/types.h>
#include <time.h>
#include <assert.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc ,char *argv[])
{
    int sockfd;
    int res;
    struct addrinfo hints;
    struct addrinfo *results;
    struct addrinfo *rp;

    char buf[128];

    if (argc < 3) { fprintf(stderr, "Usage: %s host service.\n", argv[0]); exit(EXIT_FAILURE); }
    memset(&hints, 0, sizeof(struct addrinfo));
    hints.ai_family =  AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = 0;
    hints.ai_flags = 0;

    res = getaddrinfo(argv[1], argv[2], &hints, &results);
    if (res != 0) {
        fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(res));
        exit(EXIT_FAILURE); }  assert(results != NULL); for (rp = results; rp != NULL; rp = results->ai_next) {
        sockfd = socket(results->ai_family, results->ai_socktype, results->ai_protocol);

        if (sockfd == -1)
            continue;
        else {
            printf("%s\n", inet_ntoa(((struct sockaddr_in *)rp->ai_addr)->sin_addr));
            printf("%d\n", ntohs(((struct sockaddr_in *)rp->ai_addr)->sin_port));
        }

        res = connect(sockfd, rp->ai_addr, rp->ai_addrlen);
        if (res != -1)
            break;
        close(sockfd);
    }

    if (rp == NULL) {
        fprintf(stderr, "Could not connect\n");
        exit(EXIT_FAILURE);
    }

    freeaddrinfo(results);

    res = write(sockfd, buf, 1);
    if (res == -1) {
        fprintf(stderr, "send error.\n");
        exit(EXIT_FAILURE);
    }
    time_t now;
    res = read(sockfd, &now, sizeof(now));
    now = ntohl(now);
    printf("receive %s", ctime(&now));
    close(sockfd);
    exit(0);
}
