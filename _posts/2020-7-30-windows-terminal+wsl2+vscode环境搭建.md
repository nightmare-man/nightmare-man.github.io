---
layout: post
title: windows-termianal+wsl2+vscode环境搭建
subtitle: windows-termianal+wsl2+vscode环境搭建
date: 2020-07-30
author: nightmare-man
tags: 工具使用
---
# windows-termianal+wsl2+vscode环境搭建

### 0x01 写在前面的废话

​	最近学习CSAPP需要linux环境下搭建c语言环境，并且还需要写markdown博客。一开始折腾双系统，但是linux下的桌面软件实在难用，写博客太糟心。最终选定方案是win10下用wsl2，顺便体验了下新的terminal，不得不说颜值bigger都非常高，下面开始安装：

### 0x02 wsl2

​	因为电脑之前装了双系统，所以重新装win10，并把硬盘全部重新分区了。下了官方iso镜像，然后用rufus写到u盘里（rufus真的好用，界面美观，相比起来utraliso简直像上个世纪的软件，功能也专业强大）。rufus自动识别镜像类型后，将u盘设置为efi+gpt，并提示需要关闭bios里的secure boot。
​	安装好win10后，首先是设置里的各种性能优化，再就是开启wsl2了，wsl2原理是一个小型轻便的linux虚拟机，而wsl1是nt内核实现了linux内核的调用。所以相比wsl1，除了要开启wsl功能外，还需要开启虚拟机功能，以管理员权限在powershell运行两条命令如下：

```c
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
#开启虚拟机功能
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux 
#开启wsl
```

​	目前win10自带的wsl还是1（2020-7-30），上面两条命令执行后，重启在命令行输入wsl -l -v可以看到wsl 版本是1，要开启wsl2，还需要下载wsl2的功能包，baidu下然后安装就行了。再就是去微软商店下载linux发行版了，现在可选的就ubutn和debian，比较熟悉ubuntu，就选它了，相关软件里意外发现了windows terminal，早有耳闻，也一起安装了试试，发现真的好好用。

​	wsl2与wsl1不同，由于是虚拟机，所有不能直接访问其文件系统（安装目录里发现wsl2是虚拟vhd硬盘，而wsl1里文件可以win里直接查看）。wsl2用网络实现了文件接口，用file explorer里可以用	**//wsl$/**	来访问linux的文件

### 0x01 ubuntu上c环境配置

​	首先是换源，用sudo cp将/etc/apt/sources.list文件复制一份备份，然后设置权限chmod 777，网上说+r，可惜不知道为什么+r不生效，就777了，将里面的内容全删了，换国内源，具体内容就不写了，百度一大把。另外，vim下删除全部内容的命令

```c
:1,$d  #$代表最后一行，d是删除，也就是全部删除
```

​	换源后再更新下系统，因为是搭建学习环境，就无脑全部更新了:

```c
sudo apt update #更新软件列表
sudo apt upgrade #按照列表更新
```

​	现在ubuntu推荐使用apt命令而不是apt-get了，前者是对后者的各种优化版，可以显示进度了。



​	另外新学了一个**显示指定进程的命令**:

```c
ps -aux|grep 指定进程名
```

​	ps（processor status）任务状态命令，-a （all）显示当前终端下的所有进程，而 -u 是以用户为主的格式来显示程序状况， -x是显示所有终端的程序（包括其他用户，linux好像一共有6个终端）

![image-20200730150323478](/assets/img/image-20200730150323478.png)

​	pid是processor id 进程号，vsz是进程占据的虚拟内存大小，而rss是进程占用的物理内存大小 command是创建该进程的程序。

​	而|是linux里的管道，管道就是将输入输出流化，大多数命令都有屏幕输出，通过|重定向可以将前面命令的输出，作为后面命令的输入，因此ps -aux|grep xxx，中grep命令的输入是之前ps -aux的输出，也就是上面那张图。

​	**grep（global regular expression print）**是一种正则输出命令，通过正则从输出中得到输出。

​	这就是ps -aux|grep 能显示指定进程状态的原因

​	

​	现在我们测试下，我们使用**sudo apt update &** 命令来后台运行apt update命令，**在命令后面加&可以让进程在后台运行，**其屏幕输出不可见，也不妨碍我们继续执行其他命令。然后我们用**ps -aux|sudo apt update**就可以查看其运行情况（图中显示我开启了两个进程）

![image-20200730152413959](/assets/img/image-20200730152413959.png)

​	其中的状态stat，每个值的解释如下：

![image-20200730152724650](/assets/img/image-20200730152724650.png)

​	

​	有点扯远了，继续来搭建c环境，因为我们是学习c语言，所以一个gcc+gdb就足够了，我们sudo apt install gcc gdb就行了。

​	写一个.c文件，然后**gcc 1.c -m32**就可以生成不带后缀的linux下32位平台的可执行文件了。

### 0x03 terminal配置

​	安装terminal后，创建一个桌面快捷方式，右键属性设置快捷键，因为常用，有一个全局快捷键打开还是很赞的，同样其他应用也可以这样设置全局开启快捷键。

![image-20200730153246523](/assets/img/image-20200730153246523.png)

​	windows terminal采用json文件来配置外观行为和功能，在打开terminal后菜单栏里点设置自动打开配置的json文件，具体的配置规则可以在msdn里搜索terminal找到官方说明，这里不搬运了。

​	唯一需要注意的是wsl2和wsl1不同，wsl2不能直接在文件资源管理器里直接访问，要用	**//wsl$/发行版名称/**	来访问linux的根目录，所以startingDirectory要注意下（这个也是msdn上terminal配置里专门说明的）

​	我的配置文件如下：

```json
{
    "$schema": "https://aka.ms/terminal-profiles-schema",

    "defaultProfile": "{2c4de342-38b7-51cf-b940-2309a097f518}",
    "copyOnSelect": false,
    "confirmCloseAllTabs":false,//屏蔽关闭所有窗口提示
    // If enabled, formatted data is also copied to your clipboard
    "copyFormatting": false,
    "initialPosition":"340,0", //打开后的左上角的初始位置
    "initialCols":80,   //terminal的列数
    "initialRows":20,//行数
  
    "profiles":
    {
        "defaults":
        {
            "snapOnInput":true,
            "suppressApplicationTitle":true,//禁止改变标题
            "acrylicOpacity": 0.8,//模糊透明度
            "useAcrylic":true,//开启模糊
            "backgroundImage":"%USERPROFILE%/Pictures/Saved Pictures/background.jpg",
            "backgroundImageOpacity":0.3,//背景模糊
            "scrollbarState":"hidden"//隐藏滚动条
            // Put settings here that you want to apply to all profiles.
        },
        "list":
        [
            {
                "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",//这个id要去网上生成
                "hidden": false,
                "name": "Ubuntu",
                "tabTitle":"wsl-ubuntu",
                "source": "Windows.Terminal.Wsl",
                "startingDirectory": "//wsl$/Ubuntu/home/lsm/"
            },
            {
                "guid": "{9adf3e08-d88a-4f44-902b-809590b5df4c}",
                "hidden": false,
                "name": "Aliyun",
                "tabTitle":"remote-Aliyun",
                "commandline": "ssh root@120.55.63.155"
            },
            {
                // Make changes here to the cmd.exe profile.
                "guid": "{6f6a0f0f-efee-4811-9e04-76fbbebf80d1}",
                "name": "bash",
                "tabTitle":"git-bash",
                "commandline": "bash1.exe",
                "hidden": false,
                "startingDirectory": "%USERPROFILE%/Documents/repository/"
            },
            {
                // Make changes here to the powershell.exe profile.
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "name": "Windows PowerShell",
                "tabTitle":"local-powershell",
                "commandline": "powershell.exe",
                "hidden": true
            },
            {
                // Make changes here to the cmd.exe profile.
                "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                "name": "命令提示符",
                "commandline": "cmd.exe",
                "hidden": false
            },
            {
                "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                "hidden": true,
                "name": "Azure Cloud Shell",
                "source": "Windows.Terminal.Azure"
            }
        ]
    },

   
    "schemes": [],

  
    "keybindings":
    [

        { "command": {"action": "copy", "singleLine": false }, "keys": "ctrl+c" },
        { "command": "paste", "keys": "ctrl+v" },

        // Press Ctrl+Shift+F to open the search box
        { "command": "find", "keys": "ctrl+f" },

        { "command": { "action": "splitPane", "split": "auto", "splitMode": "duplicate" }, "keys": "alt+shift+d" }
    ]
}
```



### 0x04 vscode配置

​	目前好用的ide（integrated develop environment）当属vscode了，美观时尚的界面，轻快的体验，开源并且拥有非常多好用的插件。

​	我们只需要安装两个插件即可，一个是官方的c/c++插件，另一个是remote-wsl插件，前者提供常见c开发时的功能，比如代码高亮，tasks.json模板生成（用来配置vscode运行功能），launch.json模板生成(用来配置vscode调试功能生成)；后者则是连接到wsl里，实现在vscode里写代码，在linux环境上调用gcc gdb编译，运行以及调试。

​	需要注意的是vscode里的workspace的概念，对应工程的概念，如果只是单纯的编辑文件，不需要指定workspace，但是想要运行 或者 调试，都需要指定workspace文件夹，并且该目录下的.vscode目录里要有tasks.json,launch.json文件。

​	指定workspace的方式可以点菜单里的**打开文件夹**，也可以在terminal里cd 到指定目录，然后使用**code .命令，也可以直接code 文件夹路径**（理论上来说wsl里的linux应该不支持该命令的，毕竟linux没安装vscode，但是巨硬可能在wsl里配置了windows里的path吧，wsl里的linux也可以直接用code命令调用win里的vscode，并且可以将workspace设置在linux里，可能是remote-wsl插件实现的吧）