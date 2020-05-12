---
layout: post
title: JavaScript实现的快排
author: nightmare-man
subtitle: JavaScript实现的快排
date: 2020-05-12
tags: JavaScript
---

# JavaScript实现的快排

按照c语言的模式写了一个js版的，和网上别人的一比较，发现写法差别很大。

下面是按照c语言模式写的

```javascript
const cutoff=4;
function get_pivot(arr,L,R){
    var M=parseInt((L+R)/2);
    var temp=0;
    if(arr[L]>arr[M]){
        temp=arr[L];
        arr[L]=arr[M];
        arr[M]=temp;
    }
    if(arr[M]>arr[R]){
        temp=arr[M];
        arr[M]=arr[R];
        arr[R]=temp;
    }
    if(arr[L]>arr[R]){
        temp=arr[L];
        arr[L]=arr[R];
        arr[R]=temp;
    }
    temp=arr[M];
    arr[M]=arr[R-1];
    arr[R-1]=temp;
    return temp;
}
function insert_sort(arr){
    for(var i=1;i<arr.length;i++){
        var temp=arr[i];
        for(var j=i;j>0&&temp<arr[j-1];j--){
            arr[j]=arr[j-1];
        }
        arr[j]=temp;
    }
}
function q_sort(arr,L,R){
    var len=R-L+1;
    if(len>cutoff){
        var pivot=get_pivot(arr,L,R);
        var I=L+1;
        var J=R-2;
        var temp=0;
        while(1){
            while(arr[I]<pivot){
                I++;
            }
            while(arr[J]>pivot){
                J--;
            }
            if(I<J){
                temp=arr[I];
                arr[I]=arr[J];
                arr[J]=temp;
                I++;
                J--;
            }else{
                break;
            }
        }
        temp=arr[I];
        arr[I]=arr[R-1]
        arr[R-1]=temp;
        q_sort(arr,L,I-1);
        q_sort(arr,I+1,R);
    }else{
        insert_sort(arr);
    }
}
function quick_sort(arr){
    q_sort(arr,0,arr.length-1);
}
```

下面是网上的网友的

```javascript

Array.prototype.quickSort = function() {
    const l = this.length
    if(l < 2) return this
    const basic = this[0], left = [], right = []
    for(let i = 1; i < l; i++) {
      const iv = this[i]
      iv >= basic && right.push(iv) // to avoid repeatly element.
      iv < basic && left.push(iv)
    }
    return left.quickSort().concat(basic, right.quickSort())
}
const arr = [5, 3, 7, 4, 1, 9, 8, 6, 2];

————————————————
版权声明：本文为CSDN博主「廿四桥明月夜」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/u012207345/java/article/details/82463632
```

可以看到，网友的十分简洁，区别主要是：

1：pivot主元或者说是基准选的比较随意，就选的第一元素，而c语言版选的L，M，R三个位置的中位数

2：网友版的使用了数组自带的函数，并且充分利用了JavaScript里数组变长的特点，用了push和concat

3：网友版本直接把排序函数绑在array对象原型上了，通过this访问本身的元素

经过测试，网友版本的速度吊打我的c语言模式版。100w个随机数组成的数组，网友版本1s左右，我的版本150s仍然没有出结果（不是算法问题，10w可以跑出结果）



20：51更新，发现性能差距主要在函数调用上的开销太大，将c语言版本的get_pivot和insert_sort内联到q_sort后性能反超网友版本一大截，在5000w个随机数上网友的堆直接炸了

![QQ截图20200512212345](/assets/img/QQ截图20200512212345.png)