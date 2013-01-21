---
layout: post
title: "银行因人而异的零花钱"
date: 2013-01-15 22:30
comments: true
categories: oop-toy
tips: oop
---

>>
* 在正确的对象中做消息分派的决策
* 消息链应该动态建立而不是静态建立

银行推出了一个教育基金业务，参与的家庭如果有子女在读书，可以定期拿到钱，如果是高中生，就会给一定的金额（例如100）;如果是大学生，则给更多的金额(例如500)。

{% codeblock lang:java %}

public class Bank {
	public int getPocketMoneyForUniversityStudent() {
		return 500;
	}
	public int getPocketMoneyForHighSchoolStudent() {
		return 100;
	}
}

public abstract class Student {
	public abstract int getPocketMoney(Bank bank);
}

public class HighSchoolStudent extends Student {

	@Override
	public int getPocketMoney(Bank bank) {
		return bank.getPocketMoneyForHighSchoolStudent();
	}
}

public class UniversityStudent extends Student {

	@Override
	public int getPocketMoney(Bank bank) {
		return bank.getPocketMoneyForUniversityStudent();
	}
}

{% endcodeblock %}

上面的代码主要的问题就是，在Bank这个类中，为了不同的对象的调用特化了接口，这是代码中的smell，一般来说，在命名上为了某种目的而特化而不是使用更具
有普遍性的抽象来命名，就导致了类的内部逻辑暴露而导致耦合，下面的情况：

* 增加给小学生的零花钱的计划，则要Bank增加一个接口：getPocketMoneyForPrimarySchoolStudent
* 银行调整计划，对部分满足要求的高中生提供200元的金额，则要增加一个类或者枚举， 而Bank增加一个接口：
getPocketMoneyForOutstandingHighSchoolStudent

>>接口设计应该提供对有关部件的方便访问形式，而同时又隐藏其实现的细节，这样，部件的修改才不会影响到使用者。

所以，一个名字很特化的接口就意味着暴露了内部的实现，导致代码耦合。

{% codeblock lang:java %}

public class Bank {
	public int getPocketMoney(final Student student) {
		if(student instanceof HighSchoolStudent) {
			return getPocketMoneyForHighSchoolStudent();
		} else if(student instanceof UniversityStudent) {
			return getPocketMoneyForUniversityStudent();
		} else {
			return 0;
		}
	}
	
	private int getPocketMoneyForHighSchoolStudent() {
		return 100;
	}
	
	private int getPocketMoneyForUniversityStudent() {
		return 500;
	}
}

public class HighSchoolStudent extends Student {

	@Override
	public int getPocketMoney(Bank bank) {
		return bank.getPocketMoney(this);
	}
}

public class UniversityStudent extends Student {

	@Override
	public int getPocketMoney(Bank bank) {
		return bank.getPocketMoney(this);
	}
}

{% endcodeblock %}

在下面的讨论中，会使用*消息*这些OOP理念中有特别意味的术语，并适当的用*方法*这个术语加以说明。

在OOP的设计中，*消息链*是一个本质性的东西，发送一个消息给对象，而这个消息根据其*内在的状态*和*发送消息的对象*，进行不同的*消息分派*，也就是说或
者选择*短响应*(在本方法里不调用其它方法而直接处理）, 或者 通过发送给自己某些公有的或者私有的消息（调用自己的公有或者私有方法），或者发送给其它
对象(包括自己的内部对象或者其它可见的对象）消息，来完成对初始消息的响应，这就是所谓的*消息链*。

如何将*发送消息的对象*告诉接受消息的对象呢？(也就是说，调用某个对象的方法，如何告诉被调用的对象是谁调用这个方法的)

Bank的接口：getPocketMoney(final Student student) 将调用这个接口的Student对象的实例作为参数（注意使用*final*是比较好的）。而刚开始接触OOP的人可
能会倾向于使用枚举，例如: getPocketMoney(StudentType.HIGHSCHOOL/StudentType.UNIVERSITY/...)，我认为枚举的使用对接口也是一种特化，本质上和第一种
实现并没有任何区别，它们都破坏了*消息链*的基本原则：

* 在正确的对象中做消息分派的决策
* 消息链应该动态建立而不是静态建立

现在增加一个需求：为杰出的高中生每个月提供200，如果使用枚举实现：

{% codeblock lang:java %}

public enum StudentType {
	HIGHSCHOOL,
	UNIVERSITY,
	OUTSTANDING_HIGHSCHOOL
}

public class Bank {
	public int getPocketMoney(StudentType type) {
		if(type == StudentType.HIGHSCHOOL) {
			return getPocketMoneyForHighSchoolStudent();
		} else if(type == StudentType.UNIVERSITY) {
			return getPocketMoneyForUniversityStudent();
		} else if(type == StudentType.OUTSTANDING_HIGHSCHOOL) {
			return getPocketMoneyForOutstandingHighSchool();
		} else {
			return 0;
		}
	}
	
	private int getPocketMoneyForHighSchoolStudent() {
		return 100;
	}
	
	private int getPocketMoneyForUniversityStudent() {
		return 500;
	}
	
	private int getPocketMoneyForOutstandingHighSchool() {
		return 200;
	}
}

public class HighSchoolStudent extends Student {
	private int mScore;

	public HighSchoolStudent(int score) {
		mScore = score;
	}
	
	@Override
	public int getPocketMoney(Bank bank) {
		if(mScore < 90) {
			return bank.getPocketMoney(StudentType.HIGHSCHOOL);
		} else {
			return bank.getPocketMoney(StudentType.OUTSTANDING_HIGHSCHOOL);
		}
	}
}

{% endcodeblock %}

按照上面的实现，如果银行修改标准，80分以上的就可以认为是OutstandingHighSchoolStudent，那么就需要修改HighSchoolStudent的代码，而不是Bank的代码，
这样很奇怪，不是吗？原因就在于我们在错误的对象中去做*消息分派*，评价是否OutStandingHighSchoolStudent的逻辑本来就应该出现在Bank中。另一方面来说
，银行决定是否OutStandingHighSchoolStudent的标准如果是动态变化的，那么使用枚举而产生特化的接口就无法做到了，*消息分派*应该尽可能动态（或者术语：
*晚绑定*）。当接口使用枚举作为参数的时候，可能意味着这是一种代码的smell。

*动态构建消息链*的版本：

{% codeblock lang:java %}

package org.zww.pocketmoney;
public class Bank {
	private int mOutstandingScore = 90;
	
	public void setOutstandingScore(int score) {
		mOutstandingScore = score;
	}
	
	public int getPocketMoney(final Student student) {
		if(student instanceof HighSchoolStudent) {
			HighSchoolStudent hsStudent = (HighSchoolStudent)student;
			if(hsStudent.getScore() < mOutstandingScore) {
				return getPocketMoneyForHighSchoolStudent();
			} else {
				return getPocketMoneyForOutstandingHighSchoolStudent();
			}
		} else if(student instanceof UniversityStudent) {
			return getPocketMoneyForUniversityStudent();
		} else {
			return 0;
		}
	}
	
	private int getPocketMoneyForHighSchoolStudent() {
		return 100;
	}
	
	private int getPocketMoneyForUniversityStudent() {
		return 500;
	}
	
	private int getPocketMoneyForOutstandingHighSchoolStudent() {
		return 200;
	}
}

{% endcodeblock %}

补充：对于弱类型语言来说，就不能通过这种方法实现。
