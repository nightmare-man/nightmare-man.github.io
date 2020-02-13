---
layout: post
title: quick_sort_achievement
subtitle: quick_sort_achievement
date: 2020-02-13
author: nightmare-man
tags: 数据结构与算法
---
# 手写快速排序代码

```c
#include <stdio.h>
#include <stdlib.h>
#define maxsize 100000
#define cutoff 100
void traversal(int*data,int N){
	int i;
	for(i=0;i<N;i++){
		printf("%d\t",data[i]); 
	}
	printf("\n");
	printf("\n");
}
void swap(int*a,int*b){
    int temp=*a;
    *a=*b;
    *b=temp;
}
int get_pivot(int*data,int L,int R){
    int center=(L+R)/2;
    if(data[L]>data[center]) swap(data+L,data+center);
    if(data[L]>data[R]) swap(data+L,data+R);
    if(data[center]>data[R]) swap(data+center,data+R);
    swap(data+center,data+R-1);
 //   traversal(data,maxsize);
    return data[R-1];
}
void insert_sort(int * data,int N){
    int i,j;
    for(i=1;i<N;i++){
        int temp=data[i];
        for(j=i;j>0&&temp<data[j-1];j--){
            data[j]=data[j-1];
        }
        data[j]=temp;
    }
}
void q_sort(int*data,int L,int R){
//	traversal(data,maxsize);
    int len=R-L+1;
    if(len >cutoff){
    	int i=L+1;
        int j=R-2;//R 肯定比pivot大 R-1就是pivot
        int pivot=get_pivot(data,L,R);
        while(1){
            while(data[i]<pivot) i++;//如果符合规则左小右大，就i右移，j左移 
            while(data[j]>pivot) j--;
            if(i<j){
				swap(data+i,data+j);//两边都不符合规则后，交换不符合规则的两个元素 
				i++;				//交换后就符合规则了，所以继续i右移，j左移	
				j--;
			}
            else break;
        }
        swap(data+i,data+R-1);
        q_sort(data,L,i-1);
        q_sort(data,i+1,R); 
    }else{
        insert_sort(data+L,len);
    }
}
void quick_sort(int*data,int N){
    q_sort(data,0,N-1);
}

int main(void){
	srand(time(0));
	int i;
	int num=rand();
	int*data=(int*)malloc(sizeof(int)*maxsize);
	for(i=0;i<maxsize;i++){
		data[i]=rand();
	}
//	traversal(data,maxsize);
	quick_sort(data,maxsize);
	traversal(data,maxsize);
	return 0;
}
```

以上代码测试通过：1000w int rand（）随机生成 赋值花费0.4s  排序花费2.1s 阈值在100附近效果最佳，如果所有元素大小相等，排序时间仅需0.5s

![w](/assets/img/w.jpg)

这个对时间复杂度分析很有用，在q_sort函数中，我们只做了三件事， **1分子列  2递归求左 3递归求右**

如果定义时间复杂度为T（n）,那么**①T(n)=T(n左)+T(n左)+cn**，我们**分子列用的是线性的遍历** 所以是c*n。 最好情况下是二等分，有**T(n左)=T(右)=T(n/2)**，那么①变为②**T(n)=2T(n/2)+c*n**,用高中数列求通项的知识最终可以得到**③T(n)=nlogn**
