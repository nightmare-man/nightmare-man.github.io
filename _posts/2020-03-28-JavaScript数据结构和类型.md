---
layout: post
title: JavaScript数据结构和类型
author: nightmare-man
subtitle: JavaScript数据结构和类型
date: 2020-03-28
tags: JavaScript
---
# 		JavaScript数据结构和类型

> ### 本文为MDN学习笔记，请勿作商务转载

### 0x00 数据类型

​		七种基本数据类型：

​		**布尔类型（Boolean）**，true ,false (underfined null都是false)

​		**null** 表明nulll值的特殊关键字

​		**数字（Number）**,整数或者浮点数，例如:42或者3.14159

​		**大整数（BigInt）** 可以安全操作或者储存大整数

​		**字符串（String）**表示一段文本的字符序列'nmsl',"我是你哥哥"

​		**代表（Symbol）** ECMAScript6 新添加类型，实例唯一且不可改变的数据类型

​		**对象（object）**

​		函数也是对象，但是mdn吧对象和函数并列为两个基本元素，认为对象是一个·命名容器

### 0x01 数据类型的转换

​		JavaScript是动态类型语言（dynamically typed language），意味着声明变量是可以不必指定数据类型，而且数据类型会在代码执行时自动转换。

```javascript
var answer = 42;
answer = 'Thanks for all the fish...';
```

​		数字和字符的表达式中使用（+），会把数字自动转换成字符串，而在涉及其他运算符（例如-），则不会把数字转换成字符串

```javascript
'27'-7//30
'27'+7//'277'
```

#### 		**字符串转数字**

​		**parseInt（）**和**parseFloat()**   前者会丢失小数部分，另外该函数可以指定进制（radix）

​		另外也可以直接对字符串使用**一元运算符**

```javascript
'1.1'+'1.1'='1.11.1'
(+'1.1')+(+'1.1')=2.2
```

### 0x02 字面量(Literals)

​		字面量是由语法表达式定义的常量；或者，由一定字词组成的表达定义的常量

#### 		数组字面量（Array literals）

​		数组字面值是一个封闭在方括号[]中的包含0或者多个表达式的列表，其中每个表达式代表苏族的一个元素。

​		当使用数组字面量创建一个数组时，该数组将会以指定的值作为其元素进行初始化，而长度会被设置为元素的个数

```javascript
var coffees = ["French Roast","Colombian","Kona"];
var a = [3];
console.log(a.length);//1
console.log(a[0]);//3
```

​		数组字面值也是一种对象初始化器（Array 相当于new Array(parameter1,parameter2...)）

##### 		数组字面量中多余的逗号

​		在用字面量初始化数组时不必列出所有元素，如果连写两个逗号(,) 那么中间会产生一个undefined

```javascript
var fish = ["Lion",,"Angel"];//["Lion",underfined,"Angel"];
```

​		如果你在元素列表的尾部添加一个逗号，将会被忽略，但是早期浏览器会报错，所以建议别写

​		MDN提议，不要使用在数组字面量连续的逗号来声明underfined元素，**应该显示的声明为underfined**

```javascript
var myList = ["Home",underfined,"School"];
```

#### 		布尔字面量（Boolean literals）

​		布尔类型有两种字面量：**true**和**false**

#### 		整数字面量（Integers）

​		整数可以用十进制，十六进制，八进制二进制

​		十进制整数字面量由一串数字序列组成，且没有前缀0

​		八进制的整数以0（或0O,0o）开头，只能包含数字0-7（严格模式下只能0O 0o开头）

​		十六进制整数以0x（或者0X）开头，可以包含数字（0-9）和字母a-f或者A-F

​		二进制以0b(或者0B)开头，只能包含数字0或者1

#### 		浮点数字面量（Floating-point literals）

​		浮点数字面值可以有以下的组成部分:

```javascript
3.14
-0.2324
-3.12e+12//-3.12*10^12
.1e-23//0.1*10^-23
```

#### 		字符串字面量（String literals）

​		字符串由单引号或者双引号括起来的多个字符

```javascript
"foo"
"bar"
"1234"
"on line \n another line"
"John's cat"
```

​		你可以在字符串上使用字符串对象的所有方法（和数组字面量不同，字符串字面量不是字符串对象的初始化方法，创建的是string类型 而不是obejct对象）--JavaScript会自动将字符串字面值转换成一个临时的字符串对象，调用该方法，然后废弃掉那个临时对象

```javascript
console.log("Join's cat".length);
```

​		在ES2015(ECMAScript6)中，还提供了一种模板字符串（tenplate literals），模板字符串提供了一些语法糖来构造字符串

```javascript
var name='Bob',time='today';
'hello ${name},how are you ${time}'
```

​		也可以使用模板字符串函数（称为Tag函数，因为放在模板前面）

```javascript
function myTag(strings,name,time){
    var s0=strings[0];
    var s1=strings[1];
    name='lsm';
    time='tomorrow'
    return s0+name+s1+time
}
var output=myTag'hello ${name},how are you ${}';
//'hello lsm,how are you tomorrow'
```

##### 		字符串中的逃逸字符（escape character）

​		下面是一些有特殊用途的字符

![TIM截图20200328165533](/assets/img/TIM截图20200328165533.png)

​		在引号前加反斜线'\‘，可以在字符串中插入引号

```javascript
var quote = "he read \"the cremation of sam mcgee\" by r.w.services";
console.log(quote);
```

​		要在字符串中插入’\‘，必须加转义，例如要把文件路径为c:\temp赋值给一个字符串

```javascript
var home = "c:\\temp"; //linux下路径层级用/ windows才用\
```

#### 		对象字面量（Object literals）

​		对象字面量是由{}中的一个对象的0个或者多个**“属性名-值”**的列表，不能在一条语句的开头就是用对象字面量，因为{}也被认为是一个语句块，例如：

```javascript
{name:'simili',age:23}//error
({name:'siminli',age:23})//yes
```

​		属性的值可以是任何类型，包括对象

```javascript
function getName(){
    return "lsm";
}
var people={name:'lsm',getname:getName};
```

​		更进一步的，你可以使用数字或者字符串字面量作为属性的名字

```javascript
var car={a:'saab',"b":"jeep",7:"mazda"};
console.log(car.b)//jeep
console.log(car[7])//mazda
```

​		对象的属性名可以是任意字符串，包括空串。如果对象属性名字不是合法的JavaScript标识符（不符合变量名规则），那么必须用“ ”包裹，属性的名字不合法，就不能用.访问，之恶能通过类数组标记[]来访问

```javascript
var unusualPropertyNames={
    "":"empty",
    "!":"bang!"
}
console.log(unusualPropertyNames."")//error
console.log(unusualPropertyNames[""])//empty
```

##### 		增强的对象字面量

​		ECMAScript6 增加了如下功能

```javascript
var obj={
    __proto__:theProtoObj,//设置原型
    handler,//handler：handler的简写
    toString(){//toString:funciton(){}的简写
        return "d"+super.toString();
    },
    ['prop_'+(()=>42)()]:42//动态表达式产生属性名
}
```

​		MDN**特别提醒注意**

```javascript
var foo = {a: "alpha", 2: "two"};
console.log(foo.a);    // alpha
console.log(foo[2]);   // two
//console.log(foo.2);  // SyntaxError: missing ) after argument list
//console.log(foo[a]); // ReferenceError: a is not defined
console.log(foo["a"]); // alpha
console.log(foo["2"]); // two
```

