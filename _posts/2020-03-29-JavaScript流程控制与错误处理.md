---
layout: post
title: JavaScript流程控制与错误处理
author: nightmare-man
subtitle: JavaScript流程控制与错误处理
date: 2020-03-29
tags: JavaScript
---
# JavaScript流程控制与错误处理

> ### 本文是作者个人笔记，禁止商业用途转载

### 0x00 语句块

​		语句块由一对{}界定，由基本语句或者语句块组成，通常用在流程控制里

```javascript
while(x<10){
    x++;
}
```

​		这里的{x++;}即是语句块。再ECMAScript6之前，没有块级作用域，只有函数作用域

```javascript
var x =1;
{
    var x =2;
}
alert(x);//2
```

### 0x01 条件判断语句

​		当一个逻辑为真是，执行某些语句，为假时，执行另一部分

```javascript
if(condition){
    statement_1;
}else{
    statement_2;
}//严格模式下，必须用语句块
```

​		同样可以使用1级联的else if 来判断多种条件

```javascript
if (condition_1) {
  statement_1;
}else if (condition_2) {
  statement_2;
}else if (condition_n_1) {
  statement_n;
}else {
  statement_last;
}
```

​		MDN推荐使用语句块，而不是省略他们，并且不建议在**条件表达式**中使用赋值语句，因为容易和等值比较混淆

```javascript
if(x = y){ // no!

 /*  语句  */

}
```

​		如果想使用赋值，通常在赋值语句上再加上（）

```javascript
if ((x = y)) {
  /* statements here */
}
```

​		下面这些值将会被计算成false：

​		false	underfined	null	0	NaN	 ""(空字符串)

​		当传递给条件语句所有其他的值**包括Boolean对象**，均为true

​		请不要混淆原始的布尔值true和false 与 Bo'o'le'an对象的真和假

```javascript
var b = new Boolean(false);
if (b) //结果视为真
if (b == true) // 结果视为假
```

### 0x02 switch语句

​		**switch**语句允许一个程序求一个表达式的值并且尝试去匹配表达式的值到一个**case标签**，如果成功匹配，这个程序执行相关的语句。

```javascript
switch(expression){
    case laber_1:
        statements_1;
        [break;]//breank可选
    case laber_2:
        statements_2;
        [break;]
    ...
    default:
    	statements_3;
        [break;]
}
```

​		程序从上往下依次匹配case里的值，如果匹配，就执行对应的语句，并且如果改语句没有breank（可选），那么执行完后继续匹配。如果一直没有匹配对应的case，那么就执行default里面的语句。

```javascript
switch(name){
    case "Oranges":
		document.write("Oranges are $0.59 a pound");
        breank;
    case "Apples":
        document.write("Apple are $0.48 a pound");
        break;
    default:
        document.write("Sorry,we are out of "+name);
}
```

### 0x03 异常处理语句

​		你可以用throw语句抛出一个异常并用**try.**..**catch**语句捕获他

​		我们将预料到的可能出现的错误用try catch处理，称之为**异常Exception**

#### 		异常类型

​		理论上JavaScript可以抛出任意对象（throw Object），然而不是所有对象都能产生有效的结果，尽管抛出数值或者字符串值作为错误信息十分常见，但是用异常类型更高效：

​		ECMAScrpit exceptions    DOMExcepiton and DOMError

#### 		throw语句

​		throw抛出一个异常，当你抛出一个异常时，你必须有一个含有值的表达式被抛出

```javascript
throw expression;
```

​		理论上你可以抛出任意表达式而不是一种类型的表达式:

```javascript
throw "Error2";//String type
throw 42;//Number type
throw true;//Boolean type
throw {toString:function(){return "I am an object!;"}};//Object type
```

​		你可以在抛出异常时声明一个对象，（**自定义异常**），那你就可以在catch块中查询到对象的属性

```javascript
//Create an object type UserExcepiton
function UserException(message){
    this.message=message;
    this.name="UserException";
}
//Make the exception convert to a pretty string when used as
//a string (e.g. by the error console)
UserException.prototype.toString=function(){
    return this.name+':"'+this.message+'"'
}//函数对象的原型

//Create an instance of the object type and throw it
throw new UserException("Value too high");
```

#### 		try...catch语句

​		try...catch 语句标记一块待尝试的语句，并规定一个以上的响应，应该有一个有一个异常被抛出。如果我们抛出一个异常，try...catch语句就捕获他。

​		try...catch语句有一个包含一条或者多条语句的try代码块，0个或者1个的catch代码块（对于多种类型的exception想要捕获，直接一个catch就够了，因为传入的参数时不能指定类型，只能自己判断）catch代码块中的语句会在try代码块中抛出异常时执行。换句话说如果你在try代码块中的代码没有执行成功，那么你希望将执行流程转入catch代码块。如果try代码块没有抛出异常，catch代码块就会被跳过。

​		你可以添加finally代码块，将总会在try catch之后被执行。

> ​		下面的例子使用了`try...catch`语句。示例调用了一个函数用于从一个数组中根据传递值来获取一个月份名称。如果该值与月份数值不相符，会抛出一个带有`"InvalidMonthNo"`值的异常，然后在捕捉块语句中设`monthName`变量为`unknown`。

```javascript
function getMonthName(mo){
    mo=mo-1;//adjust month number for array index(1=Jan,12=Dec)
    var months=["Jan","Feb","Mar","Apr","May",
                "Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    if(months[mo]){
        return months[mo];
    }else{
        throw "InvalidMonthNo";//throw keyword is used here
    }
}
try{
    monthName=getMonthName(myMonth);//funciton could throw exception;
}catch(e){
    monthName="unknown";
    logMyErrors(e);//pass exception object to error handler->your own funciton
}
```

​		**catch块**

​		你可以使用catch块来处理所有可能在try中产生的异常

```javascript
catch(cathcID){
	statements;
}
```

​		捕捉块指定了一个标识符（catchID）来存放抛出语句指定的值；你可以用这个标识符来获取抛出的异常信息。在插入throw块时JavaScript创建这个标识符（变量）；标识符之存在于catch块的存续期间里，当catch块执行完成时，标识符不再可用。

#### 		finally块

​		finally块包含了在try和catch块完成后，下面接着try...catch的语句之前执行的语句。

​		finally块无论是否抛出异常都会被执行。如果抛出一个异常，就算没有异常处理，finally里的语句块也会执行

​		你可以用finally块来命令你的脚本在异常发生时优雅地退出；举个例子，你可能需要在绑定的脚本中释放资源。接下来的例子用文件处理语句打开了一个文件（服务端的JavaScript允许你进入文件）。如果在文件打开时抛出一个异常，finally块会在脚本错误之前关闭文件。

```javascript
openMyFile();
try{
    writeMyFile(theData);//This may throw a error
}catch(e){
    handleError(e);//If we got a error we handle it
}finally{
    closeMyFile();//always close the resource
}
```

​		如果finally块返回一个值，那么该值时整个try-catch-finally流程的返回值，不管在try..catch块中语句返回了什么

```javascript
function f() {
  try {
    console.log(0);
    throw "bogus";
  } catch(e) {
    console.log(1);
    return true; // this return statement is suspended
                 // until finally block has completed
    console.log(2); // not reachable
  } finally {
    console.log(3);
    return false; // overwrites the previous "return"
    console.log(4); // not reachable
  }
  // "return false" is executed now  
  console.log(5); // not reachable
}
f(); // console 0, 1, 3; returns false
```

#### 		嵌套的try...catch语句

​		和if else使用方式相似

#### 		使用Error对象

​		使用错误类型，你也可以用'name'和'message'获取更精炼的信息，‘name’提供了常规的错误类（如'DOMException'或者‘Error’），而‘message’提供了一条从错误对象转换到字符串的简明信息。（name时类型，message是具体信息）

​		在你抛出你个人所为的异常时，为了充分利用那些属性(比如你的catch块不能分辨是你个人所为还是系统的异常时)，你可以使用Error构造函数

```javascript
function doSomethingErrorProne(){
	if(ourCodeMakesAMistake()){//自己的错误
        throw (new Error('The message'));
    }else{
        doSomethongToGetAJavascriptError();//系统的错误
    }
}
try{
    doSomethingErrorProne();
}catch(e){
    console.log(e.name);//logs 'Error';
    console.log(e.message);//logs 'The message' for ourmistake or a JavaScript error message
}
```

