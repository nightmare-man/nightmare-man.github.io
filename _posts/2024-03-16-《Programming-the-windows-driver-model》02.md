---
layout: post
title: 《Programming the windows driver model》02
subtitle: 《Programming the windows driver model》02
date: 2024-03-16
author: nightmare-man
tags: 操作系统


---

# 0x00 设备和驱动程序的层次结构

![image-20240316153540600](/assets/img/image-20240316153540600.png)

​	上图是WDM模型使用的层次结构。设备对象是系统为了管理硬件而创建的数据结构。一个物理设备有多个设备对象。分别是，物理设备对象，PDO（physical device object），下层过滤设备对象，功能设备对象，上层过滤设备对象。

​	总线是能够插入多个硬件设备的。总线驱动程序的一个任务就是枚举总线上的硬件设备，并为其创建PDO。

​	创建完PDO后，PnP管理器参照注册表的信息，查找与这个PDO有关的过滤器驱动程序和功能驱动程序。按照图上的顺序，先装入下层过滤驱动程序，然后其adddevice历程，创建一个FiDO，然后PnP继续向上执行，直到安装好每个设备对象和驱动程序，完成设备堆栈。

​	

​	操作系统是递归的完成设备树的构建的。当根总线的堆栈建立起来后，根总线开始正常工作，然后创建检查到的硬件的PDO，然后PnP装入对应的驱动，一般来说，与根总线链接的应该是其他总线，因此递归的构建设备树。



# 0x01 与驱动有关的注册表键

有三种类型：

Hardward键：HKEY_LOCAL_MACHINE\SYSTEM\CurrentControl\Enum注册表储存了当前硬件的配置信息，比如设备id， 资源分配等。

Class键：HKEY_LOCAL_MACHINE\SYSTEM\CurrentControl\Class注册表键包含设备驱动程序的类信息，（同一个类型设备的共同信息）

Service键：包含与驱动程序有关的信息。



新设备安装时，注册表键里的信息，帮助安装驱动：

![image-20240316161108097](/assets/img/image-20240316161108097.png)

这里说的按照是顺序装入驱动程序，是指将驱动程序映像映射到内存里，重定位内存，最后调用驱动程序入口点，DriverEntry。