# Fine Client

[![Support Platforms](https://img.shields.io/badge/flutter-android%20%7C%20ios-green.svg)](https://github.com/Nomeleel/fine_client) [![Flutter Dependency](https://img.shields.io/badge/flutter-dependency-orange.svg)](https://github.com/Nomeleel/awesome_flutter) [![Star on GitHub](https://img.shields.io/github/stars/Nomeleel/fine_client.svg?style=flat&logo=github&colorB=deeppink&label=stars)](https://github.com/Nomeleel/fine_client) 

以后好玩的项目前端部分都放到这里了，毫无疑问会用Flutter去写，现在将专注在安卓和苹果手机上运行，后期会考虑在Mac OS、PC Desktop、Web上实现。

## Fine List

君子生非异也，善假于物也。

目前有以下好玩的项目：
| 名称 | 介绍 | 备注
| :------: | ------ | :------: |
| [数独](#数独) | 数独不会解，截图上传就完事了。什么？你不会截图，那你试试手动输入模式。 |
| [创意拼图](#创意拼图) | 想要微信九宫格整体显示为一张图片，可以试试这个。注意！并非一张图片裁切成九份这么简单！ |
| [歌词提示器](#歌词提示器) | 横屏显示的歌词提示器，并支持调节歌词字体大小和颜色。 |

**多说无益，直接看图吧**

## 数独

你还在为玩数独而烦恼吗？别傻了，试试这个小工具吧！干嘛要玩数独，明明写代码更有乐趣嘛！消灭乐趣的只能是下一个乐趣，俗称：我干掉我自己！

从此把数独解出来只需要三步：

① 在手机上对数独游戏界面截图

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/sudoku_app_image.JPG" width="20%" />

② 上传图片

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/upload_image.JPG" width="20%" />

③ 抄作业 

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/answer_1.JPG" width="20%" /> <img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/fill_answer.JPG" width="20%" />

然后高高兴兴的吃经验。哈哈哈！

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/get_exp.JPG" width="20%" />

**什么？ 出大问题！！！**

但要是图片识别出了问题怎么办？别担心，早给你想到了。
可以将识别结果带到手动模式界面，重新编辑再上传就好了。

就像这样，在图片中瞎填几个数字，用来模拟识别有误的情况：

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/error_image.JPG" width="20%" />

这时候数独发现搞不定了，就来请求英明的你，帮它进行校正了：

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/str_mode_request.JPG" width="20%" />

机智的你给它比了个 **♥**

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/str_view.JPG" width="20%" />

它似乎也明白**投我以桃，报之以李**的道理：

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/answer_2.JPG" width="20%" />

真实情况是：你基于识别出来的结果，修改了识别错误的格子，然后提交-->抄作业-->吃经验。

如此贴心的一条龙服务啊！

还有经典数独模式可以解了，那不规则数独模式怎么办：

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/todo.JPG" width="20%" />

这也好办，卸载数独软件就好了。俗称：不能消灭问题，那就消灭掉提出问题的人😒

**好好好，接下来进行技术总结**

其实没啥总结的，就是用了一个Python写的后台，利用opencv的能力识别了图片，用了简单的算法算出了数独，就这么简单啊！
为了将前后端分离，也为了能让后端更灵活，所以后端单拉了一个项目，名字我都想好了就叫：**Fine Service**，哈哈哈。详情请[出门左转，下个路口再见吧！](https://github.com/Nomeleel/fine_service)

## 创意拼图

当你出去玩拍了很多照片 但发朋友圈不得不拼接 并且还想拼出一个美美的自己时 如果有一个工具能帮我拼接就好了
哈哈哈 这里刚好有一个 使用已很简单

先选一张美美的自己

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/creative_stitching_1.PNG" width="20%" />

在选择最多18张图

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/creative_stitching_2.PNG" width="20%" />

(图片来自于PhotoX)

剩下的交给时间，片刻后即可预览结果，可以点开图片看到详细图片

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/creative_stitching_3.PNG" width="20%" />

觉得拼得不行返回重复步骤即可，待到感觉拼的不错就可以导出图片
**横图和竖图混排都可以的**，这里只演示了竖图，没办法，手机只有竖图

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/cs_export_1.PNG" width="20%" />

最后等到发朋友圈的时候是这个样子的

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/wechat_moment.jpeg" width="20%" />

就这？哈哈哈

## 歌词提示器

某次演唱会之前就想做个歌词提示器 今天也算做出来了 但是也已经物是人非了[捂脸]

就是这个样子的：

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/gctsq_1.gif" width="40%" />

还可以调节字体颜色和大小：

<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/fine_client/markdown/gctsq_2.gif" width="40%" />