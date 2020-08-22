---
layout: post
title: 【断更一段时间】CSAPP-LAB-RIO(RUBOST IO)
subtitle: 【断更一段时间】CSAPP-LAB-RIO(RUBOST IO)
date: 2020-08-22
author: nightmare-man
tags: demo/lab
---
# CSAPP-LAB-RIO(RUBOST IO)

### 0x00 代码

```c
#include "rio.h"

/*
    为什么要重写一个robust版本的 不带缓冲区的 wiret 和 read？
    主要是read，有时读取的数量会少于我们想要的 传入的n 的大小。
    原因有2种： 
        ①针对普通文件，read传入的n大于k到文件末尾的距离，也就是没有n个字节可读了，
    这个时候，read会读取能读的全部大小，文件位置k会到文件末尾，再次read，会返回0。
    这种原因，是我们没办法的事情，我们能够接收。
        ②针对终端和网络read。read终端时，每次最大只能read一个文本行，以'\n'结尾，
    但是这不是我们想要的结果，我们想要的是read n个字符，而不是1行；同样的，针对网络
    的read，我们read的是另一方一次发送的数据，对方可以一次发送一个字节，但是我们可能
    想要read 100个字节。
        基于第二种原因，我们写了read wite的包装函数
*/

int rio_readn(int fd,char*usr_buf,size_t n){//无缓冲区版robust（健壮的）io，read
    size_t remain_size=n;
    int ret;
    char* usr_buf_ptr=usr_buf;
    while(remain_size>0){
        ret=read(fd,usr_buf_ptr,remain_size);
        if(ret<0){
            if(errno==EINTR){
                //实际上，如果read被中断了，有两种可能情况，1停止读取，返回到read后直接返回读取数
                //2read被重启，但是之前已经从缓冲区读取的被丢弃了，继续读后面的
                //这两种情况通过设置SA_RESTART切换
                //所以被中断根本不会返回-1！！！！
            }else{
                return -1;//其余错误直接返回-1;
            }
        }else if(ret==0){
            //读到EOF了，没有可读的了
            break;
        }else{
            remain_size-=ret;
            usr_buf_ptr+=ret;
        }
       
    }
    return (n-remain_size);
}
int rio_writen(int fd,char*usr_buf,size_t n){//无缓冲区版robust write
    size_t remain_size=n;
    char*usr_buf_ptr=usr_buf;
    int ret;
    while(remain_size>0){
        ret=write(fd,usr_buf_ptr,remain_size);
        if(ret<0){
            return -1;//write是调用系统调用本质是陷阱实现的，是硬件中断的，不会被软件信号打断
            //read会被打断是因为他会阻塞，进程会被挂起，而write是不会的。
        }else if(ret==0){//实际上，对ret=0判断是没有意义的 write 永远不会返回0，写入不会得到eof
            break;
        }else{
            remain_size-=ret;
            usr_buf_ptr+=ret;
        }
    }
    return (n-remain_size);
}

void rio_init(int fd,rio_t*rp){//绑定一个描述符和缓冲区结构
    rp->rio_cnt=0;
    rp->rio_fd=fd;
    rp->rio_ptr=rp->rio_buf;
    return;
}
/*
    为什么需要一个带有缓冲区的、robust的read？
    前面已经解释了为什么需要robust的read，主要是为了在网络和终端上读到我们
    指定大小的数据。
        read本质是要求内核读数据到内核缓冲区，再从内核缓冲区读数据，复制到
    传入的用户态传入的指针指向的地址空间。为了减少对内核的访问，我们在用户态
    又设置了一个缓冲区。这样我们试着一次read指定大小的数据，写到用户缓冲区中，
    后面不再访问内核，直接访问缓冲区，等缓冲区空（全部读完了）,再调用read。
        为什么不把缓冲区设为全局变量？不安全，并发不安全，函数不可重入。
*/
int rio_readb(rio_t *rp,char*user_buf,size_t n){//从用户缓冲区读，不保证读取的数量
    size_t cnt;
    int ret;
    if(rp->rio_cnt<=0){
        ret=read(rp->rio_fd,rp->rio_buf,sizeof(char)* MAX_RIO_BUF_SIZE);
        if(ret<0){
            return -1;
        }else if(ret==0){
            return 0;
        }else{
            rp->rio_cnt=ret;//更新未读
            rp->rio_ptr=rp->rio_buf;//重置位置指针
        }
    }
    cnt=n;
    if(cnt>rp->rio_cnt){
        cnt=rp->rio_cnt;//最大之能从缓冲区都这么多
    }
    memcpy(user_buf,rp->rio_ptr,cnt);
    rp->rio_cnt-=cnt;
    rp->rio_ptr+=cnt;
    return cnt;
}
int rio_readnb(rio_t*rp,char*user_buf,size_t n){//保证从用户态缓冲读n个
    size_t remain_size=n;
    int ret;
    char*user_buf_ptr=user_buf;//指向存放位置
    while(remain_size>0){
        ret=rio_readb(rp,user_buf_ptr,remain_size);
        if(ret<0){
            return -1;//为-1时可能给user_buf里写入了部分数据
        }else if(ret==0){
            break;//遇到结尾了
        }else{
            remain_size-=ret;
            user_buf_ptr+=ret;
        }
    }
    return (n-remain_size);
}
int rio_readLineb(rio_t*rp,char*user_buf,size_t max_len){//读一行，以'\0'结尾，最大可用max_len-1
    char temp;                                             //返回的是不包含结尾'\0'在内的读取长度
    char *user_buf_ptr=user_buf;
    size_t n=1;
    int ret;
    while(n<max_len){
        ret=rio_readb(rp,&temp,1);
        if(ret==1){
            *user_buf_ptr=temp;
            user_buf_ptr++;
            if(temp=='\n'){
                n++;
                break;
            }else{
                n++;
            }
        }else if(ret==0){
            if(n==1){
                return 0;//真：什么都没读到，连结尾的0都没了
            }else{
                break;//没有n++，因为没读到
            }
        }else{
            return -1;
        }
    }
    *user_buf_ptr=0;//以0结尾
    return n-1;//去掉结尾的0
}
//没有写的用户态缓冲，因为如果你要写，那么必定是很着急的，这和读不一样，读
//的缓冲，本质是提前读，但是写如果缓冲，那么是延后写，可是提前读数据可以接
//受，延后写就难以接受了，何况，内核本身就对读写都缓冲了，再延迟写，简直了
// int readLineb(rio_t*rp,char*user_buf)
```

