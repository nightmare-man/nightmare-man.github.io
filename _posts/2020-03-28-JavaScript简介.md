---
layout: post
title: JavaScript简介
subtitle: JavaScript简介
date: 2020-03-28
author: nightmare-man
tags: JavaScript
---
# 					JavaScript简介

> ### 本文是阅读mozilla文档后的个人笔记，禁止商业转载

### 0x00 什么是JavaScript?

​		JavaScript是一门跨平台，面向对象的**脚本语言**，既用于网页端的交互（通过操作DOM文档对象模型）,也在nodejs环境下在服务端做开发语言。

### 0x01 JavaScript和Java

​		JavaScript 遵循Java的表达式规范，命令规范，以及基础流程控制(c-like)

​		但JavaScript 是解释型语言（通常）  变量的数据类型是动态的 简化的基础数据类型（不区分int long double flaot） 基于原型的**动态继承**（可以动态添加属性和方法） JavaScript 支持**匿名函数**

​		当然，这些也让JavaScript写起来要十分谨慎和可阅读性十分差。

### 0x02 JavaScript和ECMAScript规范

​		JavaScript的标准化组织是ECMA，符合其规范的JavaScript语言称为ECMAScript,罪行的ECMAScript规范是7，然而现在在能保证兼容性的是5.1，而开发时，使用6或者7的特性，然后使用类似于babel的工具转化到5.1投入生产。

### 0x03 JavaScript解释器

​		各种浏览器的开发工具（通常是F12打开）中，均有console（控制台），可以编写并运行JavaScript代码。

### 0x04 Hello world

```javascript
function greetMe(user){
    alert('Hi '+user);
}
greetMe('Alice');//'Hi Alice'
```

