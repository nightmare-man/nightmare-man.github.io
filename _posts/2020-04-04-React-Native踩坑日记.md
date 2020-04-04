---
layout: post
title: React-Native踩坑日记
subtitle: React-Native踩坑日记
date: 2020-04-04
author: nightmare-man
tags: ReactNative
---
# React-Native踩坑日记1

1.记得安卓模拟器要改hosts文件 而且需要注意windows 下用的换行格式与linux不同，所以建议直接adb shell  然后用echo -e “127.0.0.1 localhost\n” >> hosts 这样来写入hosts 而不是pull到windows下再push回去 容易识别不了导致修改无效！！！  （windows crlf   linux lr）

2.如果编译错误 可以进android目录下 运行gradlew clean

3.网络问题一定要现在模拟器浏览器里看看能不能访问 再来改程序

4.rn也可以在debug浏览器里下断点

5.iis “绑定”设置里的 ip地址  的用途是 ，如果本机有多个ip地址 ，那么可以选定哪一个用来做服务器地址 一般默认全部为分配，这样每一个ip地址都可以用来访问iis

6.redux概念总结：

​	**action**：用来传递动作和参数，是个对象 有type属性 和参数属性，一般用create函数来创建

​	**reducer**：用来更新state树的某一部分，纯函数 接受自己管理的那部分state（旧）和action，返回自己所管理的新的state（新），reducer可以组合 也就是把一个大的reducer 分成树状的小的若干部分

​	**store**：所有reducer组成的state树 store=createStore（{reducername1：reducer1，reducername2：reducer2}）

​	通过调用**dispatch**（action）就可以执行对应的reducer 从而更新数据了，但是数据更新后怎么绑定回视图呢？
​	通过**connect**（mapStateToProps,mapDispatchToProps）（component）来将dispatch方法和对应的state绑定到视图上。**mapStateToProps**和**mapDispatchToProps** 本质上是一个对象，属性名都是对应组件props的属性名称，值分别是state树的一部分和dispatch函数。这样我们在对应组件就可以props.todos来绑定数据，即使state.todo更新，对应的prop.todo也可以跟新本且重新渲染，而可以用prop.onClick来主动更新props

```javascript
const mapStateToProps= (state =>{
    return {todos:state.todos};
});
const mapDispatchToProps=(dispatch=>{
    return {
        onClick:text=>{
            dispatch(ADD_TODO(text));
        }
    };
});
```

​	**redux-thunk** 由于reducer只能是纯函数 ，只用来更新state，但是请求api这种去拿数据的事情就没办法完成了。那么我们让dispatch（）除了能够接受action外，还可以接受函数过程，来处理网络具体的例子如下：

```javascript
export function fetchPosts(url) {  
   	return function (dispatch) {
        dispatch(requestPosts(url))
        return fetch(url)
            .then(
        	response => response.json(),
            error => console.log('An error occurred.', error)
     		 )
            .then(json =>
			dispatch(receivePosts(subreddit, json))
    	)
    }
}
```

上述函数用处理网络请求，可以用dispatch(fetchPosts("http://localhost")) 这种形式调用，但是这需要我们使用**redux-thunk**，他是一种middleware 也就是中间件。我们可以看到他的作用实在dispatch和reducer之间，因而称为中间件，而使用的方法是在createstore的时候加上，这样我们就可以dispatch函数了。

```javascript
import thunkMiddleware from 'redux-thunk'
import { createLogger } from 'redux-logger'
import { createStore, applyMiddleware } from 'redux'
import { selectSubreddit, fetchPosts } from './actions'
import rootReducer from './reducers'
const store = createStore(
  rootReducer,
  applyMiddleware(
    thunkMiddleware, // 允许我们 dispatch() 函数
    loggerMiddleware // 一个很便捷的 middleware，用来打印 action 日志
  )
)
```



