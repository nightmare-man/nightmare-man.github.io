---
layout: post
title: CSAPP-LAB-MALLOC实现与GC原理
subtitle: CSAPP-LAB-MALLOC实现与GC原理
date: 2020-08-19
author: nightmare-man
tags: 计算机组成原理
---
# CSAPP-LAB-MALLOC实现与GC原理

### 0x00 代码

```c
#include <sys/types.h>
#include <stdlib.h>
#include <stdio.h>
#define RTLD_NEXT	((void *) -1l)
#define WSIZE 4//定义一个字的大小 单位BYTE
#define DSIZE 8
#define CHUNKSIZE 1<<12//每次堆空间不足时，扩展4096字节
#define MAX(x,y) ((x>y)?(x):(y))
#define PACK(size,alloc) ((size)|(alloc))//合成块大小，2个字对齐，因此最低三位用不上，
//用来标记free/alloc

//读写*p
#define GET(p) (*(unsigned int*)(p))
#define PUT(p,val) (*(unsigned int*)(p)=val)

//
#define GET_SIZE(p) (GET(p)&~0x07)//获取块大小 
#define GET_ALLOC(p) (GET(p)&0x01)//获取是否占用

//bp block pointer HDR ->HEADER 给定一个块 拿到块的头部标记的地址和尾部标记的地址
#define HDRP(bp) ((char*)(bp)-WSIZE)
#define FTRP(bp) ((char*)(bp)+GET_SIZE(HDRP(bp))-DSIZE)//可以看到 拿到尾部标记是靠头部标记的大小
//所以要更新尾部，必须要先更新头部
//
#define NEXT_BLKP(bp) ((char*)(bp)+GET_SIZE(((char*)(bp)-WSIZE)))//拿到这个块的大小信息，bp加上
#define PREV_BLKP(bp) ((char*)(bp)-GET_SIZE(((char*)(bp)-DSIZE)))//拿到上一个块的大小信息bp减去

#define HEAP_MAX_SIZE 400 //堆的最大大小 单位MB
static char* mem_heap;//自定义堆起始地址
static char* mem_brk;//记录堆顶地址
static char* mem_max_addr;//合法的最大堆顶
static char* heap_listp;//记录第一个块的地址
void mem_init(){
    mem_heap=(char*)malloc(HEAP_MAX_SIZE*1024*1024);//
    mem_brk=mem_heap;
    mem_max_addr=mem_heap+HEAP_MAX_SIZE*1024*1024-1;//要-1，不然是非法的
    return;
}
void* mem_sbrk(size_t size){//增加堆顶，现阶段不能分为负 单位 byte
    void* old_brk=mem_brk;
    if(size<0||mem_brk>mem_max_addr){
        fprintf(stderr,"brk overflow!\n");
        return (void*)-1;
    }
    mem_brk+=size;
    return old_brk;
}
static void* coalesce(void*bp){
    size_t prev_alloc=GET_ALLOC(HDRP(PREV_BLKP(bp)));
    size_t next_alloc=GET_ALLOC(HDRP(NEXT_BLKP(bp)));
    size_t size =GET_SIZE(HDRP(bp));
    if(prev_alloc&&next_alloc){
        return bp;
    }else if(prev_alloc&&!next_alloc){
        size = size + (size_t)GET_SIZE(HDRP(NEXT_BLKP(bp)));
        PUT(HDRP(bp),PACK(size,0));
        PUT(FTRP(bp),PACK(size,0));
    }else if(!prev_alloc&&next_alloc){
        size= size+(size_t)GET_SIZE(HDRP(PREV_BLKP(bp)));
        PUT(FTRP(bp),PACK(size,0));
        PUT(HDRP(PREV_BLKP(bp)),PACK(size,0));
        bp=PREV_BLKP(bp);
    }else{
        size+=GET_SIZE(HDRP(PREV_BLKP(bp)));
        size+=GET_SIZE(HDRP(NEXT_BLKP(bp)));
        PUT(HDRP(PREV_BLKP(bp)),PACK(size,0));
        PUT(FTRP(NEXT_BLKP(bp)),PACK(size,0));
        bp=PREV_BLKP(bp);

    }
    return bp;
}

static void *extend_heap(size_t words){//扩展堆，单位 字
    char*bp;
    size_t size;
    size=(words%2==0?words:words+1);
    size=size*WSIZE;
    bp=mem_sbrk(size);
    if(bp==((void*)-1)){
        fprintf(stderr,"can't extend heap size\n");
        return NULL;
    }
   
    PUT(HDRP(bp),PACK(size,0));//新的空闲块 设置头部
     printf("first h %p size %d\n",HDRP(bp),GET_SIZE(HDRP(bp)));
    PUT(FTRP(bp),PACK(size,0));//设置新的空闲块的尾部
    PUT(NEXT_BLKP(bp),PACK(0,1));//设置新的epilogue 结尾块
    return coalesce(bp);

}
void mm_free(void * bp){
    size_t size=GET_SIZE(HDRP(bp));
    PUT(HDRP(bp),PACK(size,0));
    PUT(FTRP(bp),PACK(size,0));
    coalesce(bp);//释放时立即合并空闲块
}
void *find_fit(size_t asize){
   
    char*p=heap_listp;//指向第一个块的header
    size_t size;
    void* ret=NULL;
    while(size=GET_SIZE(p)){//如果块大小为0，那么是结尾块 epilogue
        if(size>=asize){
            ret=p+WSIZE;//即指向block
            break;
        }else{
            p+=size;//下一个块的header;
        }
    }
    return ret;
}
void place(void*bp,size_t asize){//bp是新扩展的块，我们要分割出一个asize的块
    size_t size=GET_SIZE(HDRP(bp));
    if(size==asize){
        PUT(HDRP(bp),PACK(size,1));
        PUT(FTRP(bp),PACK(size,1));
    }else if(size>asize+2*DSIZE){//如果扩展块的大小比asize还大2个双字，那么就可以多出一个空闲块
    //，该空闲块的playlod大小为1个双字，不用考虑双字节对齐，在extend的时候考虑了
        PUT(HDRP(bp),PACK(asize,1));
        PUT(FTRP(bp),PACK(asize,1));
        PUT(HDRP(NEXT_BLKP(bp)),PACK(size-asize,0));
        PUT(FTRP(NEXT_BLKP(bp)),PACK(size-asize,0));
    }
}
void* mm_malloc(size_t size){//分配内存 单位byte（不包括头尾）
    size_t asize;//对齐后的大小(包括头尾)
    size_t extend_size;//如果找不到合适的块，要分配的大小
    char*bp;//返回的块地址
    if(size==0){
        return NULL;
    }
    if(size<=DSIZE){
        asize=2*DSIZE;//如果playload 小于1个双字，那么块的实际大小至少是2个双字（头脚占一个双字）
    }else{
        asize=DSIZE*((size+DSIZE+DSIZE-1)/DSIZE);//+DSIZE 是h f的大小，+DSIZE-1是对齐用
    }
    bp=find_fit(asize);
    if(bp!=NULL){
        place(bp,asize);
        return bp;
    }
    extend_size=MAX(asize,CHUNKSIZE);
    bp=extend_heap(extend_size/WSIZE);
    if(bp==NULL){
        return NULL;//如果扩展也失败，那就返回NULL；
    }
    place(bp,asize);//从扩展出的空闲块分割出一个asize大小的块占用；多余的就空闲块
    return bp;
}
int mm_init(){
   
    mem_heap=mem_sbrk(4*WSIZE);
   
    if(mem_heap==(void*)(-1)){//初始分配4个字用来 保存 start sign prologue h/f epilogue
        return -1;
    }
    heap_listp=mem_heap;
    PUT(heap_listp,0);
    PUT(heap_listp+(1*WSIZE),PACK(DSIZE,1));
    PUT(heap_listp+(2*WSIZE),PACK(DSIZE,1));
    PUT(heap_listp+(3*WSIZE),PACK(0,1));// [start sign][prologue header][prologue footer][epilogue]
    heap_listp+=2*WSIZE;//指向块的起始位置
      printf("heap:%p\n",mem_heap);
    if(extend_heap(CHUNKSIZE/WSIZE)==NULL){
        return -1;
    }
    printf("size heap:%d\n",GET_SIZE(heap_listp));
    return 0;
}
void print_heap(){
    void*bp=heap_listp;
    size_t size;
    int cnt=0;
    while((size=GET_SIZE(HDRP(bp)))){
        printf("%p\tblock[%d]\tsize:%lu\talloced?[%d]\n",bp,cnt,size,(int)GET_ALLOC(HDRP(bp)));
        cnt++;
        bp=NEXT_BLKP(bp);
    }
    printf("total %d blocks\n",cnt);
}
void my_init(){
    mem_init();
    mm_init();
}
```

​	（上面的代码里有个bug，暂时没捉到，但是可以使用）

### 0x01 实现思路

​	在虚拟地址空间中，动态内存分配器（dynamic memory alloctor）维护着一个区域-**堆**（heap）。堆是匿名文件的映射，向上增长的，堆顶由一个指针brk指示。

​	**堆的本质是一个块的集合**，块既可以是已经分配了的，也可以是空闲的。动态内存分配器负责分配足够的块给程序使用，并且可能需要满足对齐要求。

​	**为了满足对齐要求，分配出去的块的大小可能大于要求的大小，这是块内的碎片化；另一方面，随着分配的进行，能够分配的块的大小越来越小，即使空闲块的总大小满足要求，但是单独的空闲块不能满足要求，这是外部的碎片化**。

​	如果按照空闲块查找策略（通常是遍历找到第一个符合大小的），没有合适的空闲块，那么最后不得不扩展brk指针，产生一个新的足够大的空闲块。

​	所以，为了实现一个分配器，我们必须要做以下几件事：

​	1）有一个区域来存放块，我们既可以用mmap来映射匿名文件，获得一个单独的虚拟内存区域，也可以调用系统的malloc例程，在堆中模拟一个区域。

​	2）将区域以块的集合的形式组织起来。首先，我们要能够标记空闲块和已分配块，其次，我们要能够标记一个块的大小，那么由于块的大小是8字节对齐的，因此我们将 大小&是否分配0/1 放在同一个字里（4字节），那么块的形式：

​	[header] [playlod]

​	同时，我们注意到，需要维持一个结构能够访问所有块，这个结构我们可以选择为链表，由于块都是相邻的（不断分割，始终相邻），因此不需要next指针，通过大小既可以计算下一个块的位置。但是如何访问前一个块呢？于是我们给块再加上一个尾标：

​	[header] [playload] [footer] 

​	footer和header一样 也是记录 size & allocated? 

​	3)如何分配？我们遍历所有块，第一个合适大小的空闲块，即可，如果这个块的大小比请求的大，那么就进行分割，将块分割成一个合适的对齐的块，返回其playload起始地址，并将块的头尾allocated置1，另一个块则是空闲的，给其加上头尾块，跳入大小和空闲信息。

​	如果没有合适的，我们就扩展brk指针，创建一个大的新的空闲块，填入大小&allocated,并从这个块分割。

​	4）关于碎片，每次我们free一个块（传入的是playload）我们将其头尾标记allocated置0，然后看相邻的前一个块和后一个块是否空闲，空闲则合并，合并的方法很简单，重新确定合并后的头尾，填入size&allocated信息。



0x02 GC原理

​	在C语言中，我们用动态内存分配器分配堆中的空间，使用free释放对块的占用。对不再使用的已经分配的块的释放，由应用程序自己进行，如果程序不释放，就会造成**内存泄漏（memory leak）**。

​	但是，在有些语言如java中，对于不再使用的，已经分配的块的释放，会由jvm来自动释放，称为**垃圾回收**（**garbage collection,GC**）其实在C语言中，也有一种保守的GC,当malloc需要一个空闲块，但是没有合适的时候，首先考虑的不是扩展堆而是GC，释放一些没有使用的，已经分配的块。

​	那么GC是如何实现的呢？常见的GC使用 **mark&sweep** 方法。**它将当前存在的变量作为根节点，将每个块的作为堆节点：**

![image-20200819103214106](/assets/img/image-20200819103214106.png)

​	**从每个根节点出发，先看其是不是一个合法的，指向堆中已经分配的块指针，如果是，那么就将该 已经分配的块 标记，并且 遍历这个块中的每个位置 递归地进行上一步 ，再看其是不是一个合法的，指向堆中已经分配的块指针。**

​	**这样，最后每个被引用的已经分配的块都会被标记，没有被标记的已经分配的块，就会被GC释放（sweep）**。

​	但是c语言是**保守的 mark&sweep** ，原因是，它的GC会将long等任意两个字节的数据当作指针来标记已经分配的块，**因为C语言不对内存中的数据做类型标记**（它只是简单的对编写时的变量，记录size，在编译汇编时生成符号表，而分配的内存，则不做任何标记，随便程序怎么使用）

​	而java等则是精准的mark&sweep。