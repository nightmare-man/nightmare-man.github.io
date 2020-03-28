---
layout: post
title: JavaScript变量
subtitle: JavaScript变量
date: 2020-03-28
author: nightmare-man
tags: JavaScript
---
# 				JavaScript变量

> ### mozilla的mdn文档是基于ECMAScript6.0的新特性的
>
> ### 且本文选择的是中级教程，省略了很多c-like的东西，适用于有编程语言经验的开发者。

### 0x00 大小写

​		JavaScript是区分大小写的，指令被称为语句Statement 并用’；‘分割。但如果一行语句独占一行的话，那么分号是可以省略的，（mdn文档不推荐这么做，eslint等插件会对代码做出规范，个人认为只要不是一会儿写一会儿不写，就没什么问题）。

### 0x01 注释

​		c-like的注释规则

```javascript
//单行注释
/*
	多行注释
*/
```

### 0x02 变量

#### 		声明

​		JavaScript变量有三种声明方式：

​		**var**	声明一个变量，可选初始化一个值，如果在函数内部，为局部作用域，否则为全局

​		**let**	 声明一个局部变量，作用域以{   }为界，ECMA6的特性

​		**const**   声明一个常量 常量名字大写

#### 		命名规范

​		字母，数字，下划线(_) ，美元符号（$）; 但是数组不能作为开头

​		变量名遵循驼峰原则  但是类名首字母需要大写

​		常量则全部大写

#### 		变量赋值

​		用var或者let语句声明的变量，如果没有被赋值，为undefined，不同于null，null一个值，undefined是彻底没有。

```javascript
var a;
console.log("the value of a is "+a);// undefined
console.log("the value of b is "+b);//undefined 不是reference error，因为变量提升
var b;//变量提升 
if(a === undefined){
    console.log("yes");
}else{
    console.log("no");
}
//yes
```

​		undefined在布尔类型环境中被当作false  在数值环境参与计算为NaN(not a number)

​		而null 同样在布尔运算中为false，数值却为0

#### 		变量的作用域

​		在函数之外声明的变量，叫做**全局变量**，可以在任何地方被访问，在函数内部声明的变量，叫局部变量，只能在当前函数内部访问（var定义的变量）

​		ECMAScript6 带来的语句块作用域let，在此之前都是用匿名函数实现的语句块作用域，即在两个{   }之间的作用域

```javascript
if(true){
	var x = 5;
}
console.log(x);//5

if(true){
    let y = 5;
}
console.log(5);//ReferenceError:y没有被声明
```

#### 		变量提升

> JavaScript 变量的另一个不同寻常的地方是，你可以先使用变量稍后再声明变量而不会引发异常。这一概念称为变量提升；JavaScript 变量感觉上是被“提升”或移到了函数或语句的最前面。但是，提升后的变量将返回 undefined 值。因此在使用或引用某个变量之后进行声明和初始化操作，这个被提升的变量仍将返回 undefined 值。

```javascript
console.log(x===underfined);//true
var x = 3;
//这在其它语言中会产生ReferenceError

// will return a value of undefined
var myvar = "my value";

(function() {
  console.log(myvar); // undefined
  var myvar = "local value";
})();
```

​		个人感觉，函数的定义和初始化应该在使用之前，而且尽量在所选定的作用域的顶端

​		需要注意的是，let（const）不会提升变量，而是直接报出ReferenceError

#### 		函数提升

​		对于函数来说，只有函数声明会被提升到顶部，而函数表达式不会被提升

```javascript
/* 函数声明 */

foo(); // "bar"

function foo() {
  console.log("bar");
}


/* 函数表达式 */

baz(); // 类型错误：baz 不是一个函数

var baz = function() {
  console.log("bar2");
};
```

#### 		全局变量

​		实际上，全局变量是全局对象的属性。在网页中，（缺省的，default）全局对象是window，所以可以使用**window.variable**的语法来赋值和访问全局变量，由于HTML是DOM模型，每个节点都是是对象，你同样可以使用body.variable ，或者parent.phoneNumber

#### 		常量

​		const的作用域和let相同，都是在当前大括号内。在同一作用域内，不能使用与变量名相同名字来命名常量。

​		值得注意的是，如果常量对象，其属性是可以改变的,数组也是同样的（实际是Array对象）

```javascript
const MY_OBJECT = {key:"value"};
MY_OBJECT.key="otherValue";
```



​		