---
layout: post
title: "Backbone的routes"
date: 2013-01-30 21:11
comments: true
categories: webapp
tags: [backbone.js]
---

对于有一些Spine.js以及even less的Ember.js的经验的我来说，Backbone.js非常奇怪的是，它没有Controller这个概念。

[Understanding MVC And MVP (For JavaScript And Backbone Developers) by Addy Osmani](http://addyosmani.com/blog/understanding-mvc-and-mvp-for-javascript-and-backbone-developers/)

Classic MVC：

    View <--- Controller ---> Model
	|___________________________^


MVP的一个重要特点是，Presenter并不直接依赖于View，而是依赖于ViewInterface的抽象。

Supervising Controller：

	View as ViewInterface <--- Presenter ---> Model
	 |__________________________________________^

keypoint: Presenter可以直接操作View(该出手时就出手)

Passive View:

	View as ViewInterface <--- Presenter ---> Model

keypoint: View非常无知，它不绑定在Model上，全部由Presenter直接控制

MVVM(Presentation Model):

	View ---> ViewModel ---> Model

keypoint: View绑定在ViewModel的属性上(多加一层好办事)，ViewModel不会直接操作View。(WPF)

在Spine.js 1.0 (非常早的版本了，因为后来转而使用CoffeeScript而没有用过) 中，缺少的是View的概念，Controller负责响应UI事件和模式事件
。没有数据绑定，它应该是属于Passive View的范畴。


但是BackBone甚至没有Controller这个概念，而Route也不是Controller的替代品。

TodoMVC的例子:

地址："index.html#"

![](/images/routing-in-backbone/default.png)

地址: "index.html#/active"

![](/images/routing-in-backbone/active.png)

一开始我认为是: 

>> 对地址的URL附加的hash tags(#)的响应而进入应用的相应状态的过程

Model还是那个Model，但是Controller施加了不同的过滤器，导致给View的是不同的数据。也就是说，Controller首先响应这个变化。

但是这个不是非常正确的观点，看看 "http://example.com/#/posts/12" 表示访问id为12的文章， URL本来就是代表着资源，因此更自然的观点是：

>> 应用程序的不同的数据集合通过URL hash tag进行标识以便索引

但是TodoMVC的Backbone实现不是这样子的。

替换Model，这个是经典MVC的方式，因为View应该是Model的严格映射，而不是它的子集；而MVP会通过Presenter控制某个项目是否hidden（TodoMVC Backbone的实现）来实现子集的概念，而MVVM中，View是绑定在可以动态改变的ViewModel的属性上。
