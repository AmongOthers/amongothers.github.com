---
layout: post
title: "银行因人而异的零花钱"
date: 2013-01-15 22:30
comments: true
categories: oop-toy
tips: oop
---

银行推出了一个教育基金业务，参与的家庭如果有子女在读书，可以定期拿到钱，如果是高中生，就会给一定的金额（例如100）;如果是大学生，则给更多的金额(例如500)。

[第一个可以工作的版本](https://github.com/AmongOthers/PocketMoney/tree/init_version)

{% codeblock Bank.java lang:java %}
public class Bank {
	public int getPocketMoneyForUniversityStudent() {
		return 500;
	}
	public int getPocketMoneyForHighSchoolStudent() {
		return 100;
	}
}
{% endcodeblock %}

{% codeblock Student.java lang:java %}
public abstract class Student {
	public abstract int getPocketMoney(Bank bank);
}
{% endcodeblock %}

{% codeblock HighSchoolStudent.java lang:java %}
public class HighSchoolStudent extends Student {

	@Override
	public int getPocketMoney(Bank bank) {
		return bank.getPocketMoneyForHighSchoolStudent();
	}
}
{% endcodeblock %}

{% codeblock UniversityStudent.java lang:java %}
public class UniversityStudent extends Student {

	@Override
	public int getPocketMoney(Bank bank) {
		return bank.getPocketMoneyForUniversityStudent();
	}
}
{% endcodeblock %}
