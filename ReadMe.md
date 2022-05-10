# 吴乐川用于调用 ffmpeg 的 PowerShell 工具集

> 中国人——特别是汉族人，理应坚持广泛、规范地使用汉语。凡非必要之情形不说外国话、不用外国字。此乃天经地义！然则每当必要，亦不排斥采用外国之语言。不妨 **博世界之学问，养中国之精神** 。
>
> 本人亦支持少数民族坚持采用自己民族的传统语言。仍须强调，凡中国人，皆应会用汉语、积极使用汉语，此乃中华各民族之大一统之必由。



## 简介

本工具的核心是一套 PowerShell 脚本程序。但为了方便调用，还额外借助了批处理程序。即，总是由某个批处理来自动运行*同名*的 PowerShell 程序。本工具集中的诸工具均调用 ffmpeg 工具，以读取一个或若干个媒体（录像或录音）文件，对它们进行处理并产出结果。结果均为由 ffmpeg 产生的新的媒体文件。


## 源代码仓库

| <span style="display:inline-block;width:10em;">提供仓库服务之组织</span> | <span style="display:inline-block;width:10em;">仓库组织之国别</span> | 仓库地址 |
| ------------- | :----------: | ------- |
| 码云           | 中华人民共和国 | [https://gitee.com/nanchang-wulechuan/wulechuan-powershell--ffmpeg-wrappers.git](https://gitee.com/nanchang-wulechuan/wulechuan-powershell--ffmpeg-wrappers.git) |
| 阿里云之代码仓库 | 中华人民共和国 | [https://code.aliyun.com/wulechuan/wulechuan-powershell--ffmpeg-wrappers.git](https://code.aliyun.com/wulechuan/wulechuan-powershell--ffmpeg-wrappers.git) |
| GitHub         | 美           | [https://github.com/wulechuan/wulechuan-powershell--ffmpeg-wrappers.git](https://github.com/wulechuan/wulechuan-powershell--ffmpeg-wrappers.git) |




## 安装与使用

### 安装

1.  安装 ffmpeg 。本工具集中诸工具均会调用 ffmpeg 。

    > 见《[https://ffmpeg.org/download.html](https://ffmpeg.org/download.html)》。

1.  安装本工具集自身。双击运行 `安装.bat` 即可。这将：

    1.  产生一个 `快捷方式集` 文件夹。其中为本工具集中的每一个工具构建一个快捷方式。目前共有三个工具，故而会产生三个快捷方式。

    > 另，不妨手工将上述快捷方式复制到你常用的位置，例如你的视窗系统（Windows）的桌面。

1.  将 `专用于本机之配置.ps1.示范` 文件复制为 `专用于本机之配置.ps1` 文件。

1.  用文本编辑工具（例如 记事本 或 Visual Studio Code）打开 `专用于本机之配置.ps1` 文件。编辑其内容，以正确配置诸常量。参见下例：

    ```ps1
    ${global:ffmpeg可执行程序的完整路径} = 'D:\Users\公用\ffmpeg-2022-04-07\bin\ffmpeg.exe'
    ${global:位于用户桌面的_默认用于存放产生的文件的_文件夹的名称} = 'ffmpeg-产生的录像和录音'
    ```



### 各工具统一的用法

本工具目前题共三个入口批处理文件（`.bat`）。

1.  每一个批处理文件均对应一个*同名*的 PowerShell 文件（`.ps1`）。实质功能全部由 PowerShell 文件提供。所以上文才称批处理文件为所谓“**入口**”文件。

1.  每一个批处理文件均对应一个快捷方式文件，以行方便。比起古朴的批处理文件，快捷方式可以自由设计图标、键盘快捷键等。

使用上述任意一个批处理时，只需将一个或若干个媒体（录像或录音）文件用鼠标拖动到该批处理图标上即可。同理，将媒体文件拖动到快捷方式文件上也是可以的，功效与拖动到批处理文件图标上是完全相同的。



### 各工具之功用

#### `ffmpeg-截取视频片段`

将一个或若干个【录音】或【录像】文件拖动至本程序之图标上，对于给出的每一个文件，本程序都会询问【起】、【迄】两个时刻，并据此从该文件中截取一个片段保存成全新的【录音】或【录像】文件。



#### `ffmpeg-提取音轨`

将一个或若干各【录像】文件拖动至本程序之图标上，本程序即逐一处理这些【录像】，将其第 1 条【音轨】提取成一个 .wma 文件。



#### `ffmpeg-音视频轨合并`

将

-   2 个【录像】文件
-   或 1 个【录像】文件和 1 个【录音】文件

同时拖放至本程序之图标上，本程序即会将

-   其中代表【声音】来源文件的第 1 条【音轨】
-   与代表【画面】来源文件的第 1 条【视频轨】（一般仅见 1 条）

合并成全新的【录像】文件。


## FFMPEG

见其官方文档：

- 《[https://ffmpeg.org/documentation.html](https://ffmpeg.org/documentation.html)》。
