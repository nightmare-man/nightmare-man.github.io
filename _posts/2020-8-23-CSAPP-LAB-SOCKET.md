---
layout: post
title: 【断更一段时间】CSAPP-LAB-SOCKET
subtitle: 【断更一段时间】CSAPP-LAB-SOCKET
date: 2020-08-23
author: nightmare-man
tags: demo/lab
---
# CSAPP-LAB-SOCKET

### 0x00 代码

​	server.c

```c
#include <sys/socket.h>
#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <string.h>
#include "rio.h"
int main(){
    struct sockaddr_in my_sock;
    memset(&my_sock,0,sizeof(my_sock));
    my_sock.sin_addr.s_addr=inet_addr("127.0.0.1");
    my_sock.sin_family=AF_INET;
    my_sock.sin_port=htons((unsigned short)7778);
    int fd=socket(AF_INET,SOCK_STREAM,0);
    if(fd<0){
        printf("socket error\n");
        return -1;
    }
    int ret=bind(fd,(struct sockaddr*)(&my_sock),sizeof(struct sockaddr));
    if(ret<0){
        printf("bind error\n");
        return -1;
    }
    ret=listen(fd,1024);
    if(ret<0){
        printf("listen error\n");
        return -1;
    }
    socklen_t ret_size=sizeof(struct sockaddr);
    memset(&my_sock,0,sizeof(struct sockaddr));
    fd=accept(fd,(struct sockaddr*)(&my_sock),&ret_size);//我吐了，这个地方虽然传入的是指针，但是引用值
                                                        //还是要有初值，为sizeof(struct sockaddr)
    if(fd<0){
        printf("connected error\n");
        return -1;
    }
    printf("client addr:%s\nport:%u",inet_ntoa(my_sock.sin_addr),(unsigned int)ntohs(my_sock.sin_port));
    rio_t rp;
    rio_init(fd,&rp);
    char read_buf[MAX_RIO_BUF_SIZE];
    while(1){
        rio_readLineb(&rp,read_buf,MAX_RIO_BUF_SIZE);
        printf("%s",read_buf);
    }
    close(fd);
    return 0;
}
```

​	client.c

```c
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>
#include "rio.h"
int main(){
    struct sockaddr_in my_sock;
    memset(&my_sock,0,sizeof(my_sock));
    my_sock.sin_addr.s_addr=inet_addr("127.0.0.1");
    my_sock.sin_family=AF_INET;
    my_sock.sin_port=htons(7778);
    int fd=socket(AF_INET,SOCK_STREAM,0);
    if(fd<0){
        printf("socket error\n");
        return -1;
    }
    int ret=connect(fd,(struct sockaddr*)(&my_sock),sizeof(my_sock));
    if(ret<0){
        printf("connect error\n");
        return -1;
    }
    rio_t rp;
    rio_init(STDIN_FILENO,&rp);
    char write_buf[MAX_RIO_BUF_SIZE];
    while(1){
        rio_readLineb(&rp,write_buf,MAX_RIO_BUF_SIZE);
        rio_writen(fd,write_buf,strlen(write_buf));//这个地方写入的大小是strlen(write_buf)字节大小
    }                                              //而不是sizeof(write_buf) 这是一个指针的大小
    close(fd);
    return 0;
}
```

​	编译命令 gcc server.c ./rio.so -o server

gcc client.c ./rio.so -o client

​	rio.so是上一个实验编译的共享库