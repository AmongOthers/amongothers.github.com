---
layout: post
title: "命令行调用sublime"
date: 2013-01-19 12:56
comments: true
categories: tool
---
I've created subl.bat in C:\Program Files\Sublime Text 2 with contents: 

	start sublime_text.exe %* 

Now that I have C:\Program Files\Sublime Text 2 in PATH, I can simply type 'subl folder' and it works wonderfully without having to add anything to autostart.
