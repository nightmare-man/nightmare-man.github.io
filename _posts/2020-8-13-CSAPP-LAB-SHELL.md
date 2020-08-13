---
layout: post
title: CSAPP-LAB-SHELL
subtitle: CSAPP-LAB-SHELL
date: 2020-08-13
author: nightmare-man
tags: 计算机组成原理 demo/lab
---
# CSAPP-LAB-SHELL

0x00 代码

```C
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <wait.h>
#include <sys/wait.h>
#include <string.h>
#define maxsize 1000
int parse_command(char*command,int*argc,char*argv[]){
    int bg=0;
    char*p=command;
    int flag=0;
    int cnt=0;
    int length=0;
    char* start=p;
    while(1){
        if(*p=='\0'||*p=='\n'){
            if(flag==0){

            }else{
                argv[cnt]=(char*)malloc(sizeof(char)*(length+1));
                strncpy(argv[cnt],start,(size_t)length);
                argv[cnt][length]='\0';
                cnt++;
            }
            break;
        }
        if(*p==' '){
            if(flag==0){
            }else{
                argv[cnt]=(char*)malloc(sizeof(char)*(length+1));
                strncpy(argv[cnt],start,(size_t)length);
                argv[cnt][length]='\0';
                flag=0;  
                cnt++; 

            }
        }else{
            if(flag==0){
                length=1;
                start=p;
                flag=1;
            }else{
                length++;
            }
        }
        p++;
    }
    if(cnt==0){
        return -1;//error
    }
    if(argv[cnt-1][0]=='&'&&argv[cnt-1][1]=='\0'){
        cnt--;
        bg=1;
    }  
    *argc=cnt;
    return bg;
    
}
void eval_command(char*command){
    char * argv[maxsize];
    int argc=0;
    int bg=0;
   
    bg=parse_command(command,&argc,argv);
    pid_t p=0;
    p=fork();
    if(bg!=-1){
        if(p==0){
            if(execve(argv[0],argv,__environ)<0){
                //如果返回-1则执行文件失败，直接终止进程
                printf("executable file not found!\n");
                exit(0);
            }
        }else{//前台和后台的区别是 前台子进程时shell挂起，等着回收就行了
            if(bg==1){
                printf("[%d] %s",p,command);
            }else if(bg==0){
                int status=0;
                if(waitpid(p,&status,0)<0){
                    printf("waitfg:waitpid error!\n");
                }
            }
        }
    }
    return ;
    

}
int main(){
    pid_t p=0;
    char COMMAND_LINE[maxsize];
    while(1){
        int cnt=0;
        printf("L_SHELL>");
        fgets(COMMAND_LINE,maxsize,stdin);
        eval_command(COMMAND_LINE);
      //  eval_command(COMMAND_LINE);
    }
    return 0;
}
```

![image-20200813221923634](/assets/img/image-20200813221923634.png)