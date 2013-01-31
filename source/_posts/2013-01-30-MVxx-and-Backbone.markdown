---
layout: post
title: "MV*与Backbone"
date: 2013-01-30 21:11
comments: true
categories: webapp
tags: [backbone.js]
---

## 几种MV*框架的含义

关键的区别就是，View是依赖于绑定还是直接操作？如果是绑定，那么绑定在谁身上。

### Classic MVC

    View <--- Controller ---> Model
	|___________________________^

### MVP

Presenter并不直接依赖于View，而是依赖于ViewInterface的抽象，并具有直接操作View的能力。而在Supervising Controller方式的MVP中，View的渲染主要还是通过绑定在Model上，Presenter在比较复杂的情况下才出手；而Passive View方式的MVP中，View是无知的，Presenter控制View的渲染的细节。

#### Supervising Controller

	View as ViewInterface <--- Presenter ---> Model
	 |__________________________________________^

#### Passive View

	View as ViewInterface <--- Presenter ---> Model

### MVVM(Presentation Model)

源自微软的WPF的一套模式，View绑定在ViewModel的属性上（面向对象的方式：增加一个间接层来解决问题），ViewModel不会直接操作View。

	View ---> ViewModel ---> Model

## 例子

URL: "index.html#"

![](/images/routing-in-backbone/default.png)

URL: "index.html#/active"

![](/images/routing-in-backbone/active.png)

一开始我认为Route的本质是： 

>> 对URL附加的hash tags(#)的响应而进入应用的相应状态的过程

但是就像 "http://example.com/#/posts/12" 表示访问id为12的文章， URL代表着资源，因此更自然的观点是：

>> 应用程序的不同的数据集合通过URL hash tag进行标识以便索引

虽然后者显得更加自然，但是这个是Classic MVC的方式，将View绑定到新的Model上，用的比较少。MVP则通过Presenter控制某个项目是否hidden来实现（TodoMVC Backbone），而MVVM中，View绑定在动态改变的ViewModel的属性上，本例中可以是Visible Items。

BackBone.js没有天然的数据绑定。它倾向于Passive View方式的MVP。不过它的设计意图是对各种模式开放，而不假定:

[Understanding MVC And MVP (For JavaScript And Backbone Developers) by Addy Osmani](http://addyosmani.com/blog/understanding-mvc-and-mvp-for-javascript-and-backbone-developers/)