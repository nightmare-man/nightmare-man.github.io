---
layout: post
title: JavaScript面向对象
author: nightmare-man
subtitle: JavaScript面向对象
date: 2020-05-13
tags: JavaScript

---

# JavaScript面向对象

​	传统的 oop（object oriented programming）中，由对象 object 和类的概念，前者是后者的实例，后者是前者的模板

​	而js则全然不同，js中，只存在对象，它实现oo的方式是，把一部分对象拿出来作为另一部分对象的**原型**，也就是传统oo中的**类**，只不过它不显式的指出这是一个模板。

​	为例建立传统oo与jsoo的联系与区别，方便理解，本文把传统oo的实例和js的对象联系在一起，把传统oo的类和js的原型对象联系在一起。

​	js面向对象分四个点 **实例/对象**   **构造函数**  **类/原型对象**   **继承** ，下面分别展开

### 0x00 实例/对象

​	js中，一切皆是**实例/对象**，所有**实例/对象**都有一个“**_\_proto__**”,（该属性不是标准属性，但是几乎所有浏览器都支持），该属性直接指向此对象的**原型对象**

### 0x01 构造函数

如何构造一个**实例/对象**？

​	实现的方法不只一种，主流方法是用**构造函数**

```javascript
function Person(name,age){
    this.name=name;
    this.age=age;
    this.getAge=function(){
        return this.age;
    }
}
Person()//strict模式下直接报错，因为此时this指向undefined
new Person（）//基于Person构造函数产生一个新的**实例/对象**，且通过this绑定了属性和方法
```

​	这个函数直接调用会报错，需要new来调用，与传统oo类似

​	但是，我们这里只见**构造函数**，没有看见传统oo中的类啊，也就是没看到**类/原型对象**啊

### 0x02 类/原型对象

​	js的**类/原型对象**是隐式的，因为名字和构造函数相同，你如果直接输入Person,一定访问的是	Person那个函数，所以js里的原型链实际上是这样的

```javascript
var aa=new Person('lsm',21);
console.log(aa.__proto__===Person.prototype);
//true
```

​	后面的Person是构造函数，构造函数的.prototype,才真正指向Person**类/原型对象**

可以看到，结果是一个名叫Person的空对象，这就是**类/原型对象**，至于为什么构造函数里由name和age两个属性，而我们的**类/原型对象**是空的，因为我们设置的name和age都是给根据**构造函数**Person产生的对象设置的，每个对象根据传入构造函数的值不同都有不同的age，name值。

​	那么有人说，既然你的**类/原型对象**是空的，那干嘛还要来呢，不直接就 **实例/对象**+**构造函数**就实现了oo？此言差异。

​	一则，只是这样，怎么实现**继承**呢？

​	二则，如果有些属性或者方法，对于所有**实例/对象**都是一样的是公共的，我们还在每用**构造函数**给每一个**实例/对象**都创建一次，不是太浪费空间了？

```javascript
var bb=new Person('a',12);
var cc=new Person('b',21);
console.log(bb.getAge===cc.getAge);
//false
//可以看到构造出的不同对象的getAge并不是同一个函数，但实际上是应该共用一个的，我们不该给每个**实例/对象**都定义一个
```

​	针对第二个问题，既然**类/原型对象**也是对象，那我们就可以给它添加属性和方法，js让根据原型对象及其构造函数产生的**实例/对象**，可以直接访问原型的属性和方法。

```javascript
Person.prototype.run=function(){
    console.log(this.name+" is running!");
}
var aa=new Person('lsm',21);
aa.run();//原型对象的方法
//lsm is running!
```

### 0x03 继承

​	传统oo的继承是类与类之间的层级关系，而js中，由于类也是一种对象，并且通过上面的可知，对象可以得到原型对象的属性和方法，那我们就可以通过原型链的方式实现继承了！

​	a->b->c

​	1.a是一个对象，由原型对象b及构造函数产生， 这里a相当于 传统oo中的对象 b是类；

​	2.b的原型对象又是c，那么b可以访问c的所有属性和方法，那么a就可以访问c的所有属性和方法，那我们不就实现了传统oo中的 b继承c，a是b的实例吗？

​	同理我们延长这个原型链就可以构造更深层次的继承



