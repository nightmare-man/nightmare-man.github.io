---
layout: post
title: bochs和WinImage的使用及硬盘详解
subtitle: bochs和WinImage的使用及硬盘详解
date: 2020-06-10
author: nightmare-man
tags: 8086汇编 工具使用
---

# bochs和WinImage的使用及硬盘详解

### 0x00 bochs简介

​		bochs是一款跨平台的 开源的x86硬件模拟器，用于运行旧的linux或者dos系统是极其合适的，也可以用来编写操作系统或者实模式下的一些软件

​		去官网下载最近的版本，直接安装，打开后是这个界面，我们点load，然后选择从官网下载的freedosimg解压后的目录里的bochsrc文件

![QQ截图20200610162958](/assets/img/QQ截图20200610162958.png)

![QQ截图20200610163123](/assets/img/QQ截图20200610163123.png)

​		然后返回界面点击start  就可以运行freedos了

![QQ截图20200610163310](/assets/img/QQ截图20200610163310.png)

​	

### 0x01 如何配置

​		我们刚刚load的 bochsrc文件，实际上是配置文件，用文本工具打开后如下图

![QQ截图20200610163345](/assets/img/QQ截图20200610163345.png)

```c
megs: 32 #内存大小 32MB
romimage: file=$BXSHARE/BIOS-bochs-latest#BIOS文件的路径
vgaromimage: file=$BXSHARE/VGABIOS-lgpl-latest#vga文件路径
vga: extension=vbe, update_freq=15
floppya: 1_44=a.img, status=inserted#挂载软盘，盘符为a 对应物理路径为a.img 大小1.44MB
floppyb: 1_44=b.img, status=inserted#挂载软盘，盘符为b 对应物理路径为b.img  大小1.44MB
ata0-master: type=disk, path=c.img, cylinders=306, heads=4, spt=17#硬盘 盘符c: 
								 #cylinders 柱面数 heads 磁头数 spt 每磁道扇区数
boot: c#设置启动盘
log: bochsout.txt
mouse: enabled=1#启用鼠标
cpu: ips=15000000#instruction per second   cpu速度

```

​		img文件一种文件压缩格式，他可以用来压缩整个软盘或者光盘内的所有文件，在这里用来当做虚拟的磁盘使用，我们可以借助类似WinImage等软件打开，往里面读写文件，如下图：

![QQ截图20200610164612](/assets/img/QQ截图20200610164612.png)

​		所以，如果我们想和虚拟机里的系统实现文件传输，就要借助winimage 往里面写入或者复制文件

### 0x02 WinImage使用

​		依次点击 映像 inject a file 就可往img映像里加入文件。

​		如果要新建一个空白的img文件，可以点击文件，新建，然后选择格式，最后保存，注意默认保存后缀为.imz，需要选择自定义文件，然后修改后缀为.img

​		![QQ截图20200610175832](/assets/img/QQ截图20200610175832.png)

​		如果要新建一张软盘的img 就选1.44MB,如果要新建一个硬盘的img 就 选择上图的**自定义格式映像**，里面会有一些设置：

![QQ截图20200610182635](/assets/img/QQ截图20200610182635.png)

​		上述设置中主要是修改**总扇区数**来修改硬盘映像总大小，而扇区总数有一个最大值，由上面的**每簇扇区数**决定！



### 0x03 硬盘储存结构详解

![2843224-e0854f19c817c83c](/assets/img/2843224-e0854f19c817c83c.png)

![2843224-56f2056f0b36009f](/assets/img/2843224-56f2056f0b36009f.png)



​		如上图，一个硬盘多个**磁头（heads）**，每个磁头对应一个盘面，每个盘面被分成很多**磁道（tracks）**一个盘面的磁道数即是**柱面（cylinders）**，每个磁道又分成若干**扇区（sector）**，一个扇区一般储存512BYTE

​		所以硬盘		**存储容量 ＝ 磁头数 × 磁道(柱面)数 × 每道扇区数 × 每扇区字节数**

​		spt 即 sectors per track (每个磁道扇区数)

​		那么在我们的img硬盘格式设置那张图，已知 6400个扇区  磁头数是2  ，每磁道扇区数32 所以每磁头对应100个磁道，也就是有100个柱面，所上面那个img在bochsrc中设置硬盘是，cylingers 100，heads 2，spt 32