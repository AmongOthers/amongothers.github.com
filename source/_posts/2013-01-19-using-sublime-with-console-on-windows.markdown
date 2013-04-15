---
layout: post
title: "命令行与sublime"
date: 2013-01-19 12:56
comments: true
categories: tool
---
I've created subl.bat in C:\Program Files\Sublime Text 2 with contents: 

	start sublime_text.exe %* 

Now that I have C:\Program Files\Sublime Text 2 in PATH, I can simply type 'subl folder' and it works wonderfully without having to add anything to autostart.

在sublime中打开命令行，安装Package Control后安装Terminal，就可以在目录上执行右键菜单，Open Terminal Here，不过默认的是PowerShell，启动比较慢，在 Preferences > Package Settings > Terminal > Settings - User 添加如下配置：

	{
		"terminal": "cmd.exe"
	}
