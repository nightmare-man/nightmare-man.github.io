---
layout: post
title: 跳表(skip list)的实现
subtitle: 跳表(skip list)的实现
date: 2022-02-18
author: nightmare-man
tags: 数据结构与算法 c/c++
---
# 0x00

    在《Programming:principle and practice using c++》一书的习题中出现了一个跳表 skip list，第一次听说，百度后大开眼界，是一种顺序查找链表，时间复杂度O(n)，Redis中就有用到。原理详见[Redis 为什么用跳表而不用平衡树？ - 掘金 (juejin.cn)](https://juejin.cn/post/6844903446475177998)

    自己实现了一下，效果如图：



![QQ截图20220218173555.png](/assets/img/QQ截图20220218173555.png)

代码如下:

```cpp
#include "std_facilities.h"
#include "time.h"
#include "stdlib.h"
const int layer=5;
struct Node{
    int val;
    Node* next;
    Node* last;
    Node* up;
    Node* down;
    Node(int v=-1):val{v},next{nullptr},last{nullptr},up{nullptr},down{nullptr}{}
};

struct MList{
    vector<Node*> Head{vector<Node*>(layer+1)};
    vector<Node*> tail{vector<Node*>(layer+1)};
    MList(){
        Node* bottom=nullptr;
        Node* bottom1=nullptr;
        for(int i=0;i<layer+1;i++){
            Head[i]=new Node();
            tail[i]=new Node();
            Node* thisNode=Head[i];
            Node* thisNode1=(tail[i]);
            thisNode->val=-99999;
            thisNode1->val=99999;
            thisNode->down=bottom;
            thisNode1->down=bottom1;
            thisNode->next=thisNode1;
            thisNode1->last=thisNode;
            if(bottom) bottom->up=thisNode;
            if(bottom1) bottom1->up=thisNode1;
            bottom=thisNode;
            bottom1=thisNode1;
        }
    }
    ~MList(){
        for(int i=0;i<layer+1;i++){
            delete Head[i];
            delete tail[i];
        }
    }
};
void print(Node* l){
    while(l){
        cout<<l->val<<" ";
        l=l->next;
    }
    cout<<'\n';
}
void print(MList& l){
    for(int i=layer;i>=0;i--){
        print(l.Head[i]);
    }
}
//
Node* findx(MList& l,int val){
    Node* p=l.Head[layer];
    Node* ret=nullptr;
    while(true){
        if(val>p->val){
            p=p->next;
        }else if(val<p->val){
            p=p->last->down;
            if(p==nullptr) break;
        }else{
            ret=p;
            break;
        }
    }
    return ret;
}

void insert(MList& l,Node* n){
    Node* pos=nullptr;
    Node* p=l.Head[layer];
    Node* ret=nullptr;
    while(true){
        if(n->val>p->val){
            p=p->next;
        }else if(n->val<p->val){
            if(p->last->down)p=p->last->down;
            else{
                pos=p->last;
                break;
            }
            //if(p==nullptr) break;
        }else{
            error("已经存在该节点");
        }
    }
    
    n->next=pos->next;
    n->last=pos;
    pos->next->last=n;
    pos->next=n;
    Node* bottom=n;
    int maxnum=static_cast<int>(pow(2,layer));
    maxnum+=10;
    int randint=rand()%maxnum;
    int thislayer=1;
    cout<<"randint is"<<randint<<'\n';
    if(randint==0) thislayer=5;
    else if(randint>=1&&randint<3) thislayer=4;
    else if(randint>=3&&randint<7) thislayer=3;
    else if(randint>=7&&randint<15) thislayer=2;
    else thislayer=1;
    for(int i=1;i<thislayer+1;i++){ 
        Node* temp=new Node(n->val);
        while(true){
            if(pos->up){
                pos=pos->up;
                break;
            }else{
                pos=pos->last;
            }
        }
        temp->next=pos->next;
        temp->last=pos;
        pos->next->last=temp;
        pos->next=temp;
        temp->down=bottom;
        bottom->up=temp;
        bottom=temp;
    }
}
int main(){
    time_t t;
    srand((unsigned) time(&t));
    MList list;
    insert(list,new Node(1));
    insert(list,new Node(3));
    insert(list,new Node(5));
    insert(list,new Node(7));
    insert(list,new Node(18));
    insert(list,new Node(6));
    print(list);
    Node* x=findx(list,18);
    if(x) cout<<"find\n";
    else cout<<"no exist\n";
    return 0;
}

```
