#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    char *host;
    int sockfd;
    int len, result;
    struct sockaddr_in address;
    struct hostent *hostinfo;
    struct servent *servinfo;
    char buffer[128];

    if (argc == 1)
        host = "localhost";
    else 
        host = argv[1];

    hostinfo = gethostbyname(host);
    if (!hostinfo) {
        fprintf(stderr, "no host: %s\n", host);
        exit(EXIT_FAILURE);
    }

    servinfo = getservbyname("daytime", "tcp");
    if (servinfo == NULL) {
        fprintf(stderr, "no daytime services\n");
        exit(EXIT_FAILURE);
    }
    printf("daytime port is %d\n", ntohs(servinfo->s_port));

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    address.sin_family = AF_INET;
    address.sin_port = servinfo->s_port;
    address.sin_addr = *(struct in_addr *)*hostinfo->h_addr_list;
    len = sizeof(address);
    
    result = connect(sockfd, (struct sockaddr *)&address, len);
    if (result == -1) {
        perror("oops: getdate");
        exit(EXIT_FAILURE);
    }

    result = read(sockfd, buffer, sizeof(buffer));
    buffer[result] = '\0';
    printf("read %d bytes: %s", result, buffer);
    close(sockfd);
    return 0;
}


