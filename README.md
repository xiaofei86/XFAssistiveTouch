<img src = "https://github.com/xiaofei86/XFAssistiveTouch/raw/master/Images/XFAssitiveTouchHeader.png" width = 850>

[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square)](https://raw.githubusercontent.com/xiaofei86/XFAssistiveTouch/master/LICENSE)&nbsp;
[![COCOAPODS](https://img.shields.io/cocoapods/v/XFAssistiveTouch.svg?style=flat-square)](https://cocoapods.org/?q=XFAssistiveTouch)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat-square)](https://en.wikipedia.org/wiki/IOS_8)&nbsp;
[![BLOG](https://img.shields.io/badge/blog-xuyafei.cn-orange.svg?style=flat-square)](http://xuyafei.cn)&nbsp;

XFAssistiveTouch 是仿照 iOS 系统的辅助按钮 AssistiveTouch 制作的辅助按钮。你可以用在调试等场景中使用。

#Getting Started
* 阅读此 README 文档或 [相关博客](http://www.jianshu.com/p/9c7cf61edb24) 了解 XFAssistiveTouch
* 下载 XFAssistiveTouch 运行 Examples 文件夹中的示例查看效果
* 参考 Installation 章节将 XFAssistiveTouch 集成在你的项目中
* 参考 Usage 章节或示例代码在你的项目中使用 XFAssistiveTouch


#Communication

* 如果你需要使用上的帮助，请联系我 <xuyafei86@163.com> 。
* 如果你有使用上通用的问题，请新建 Issue。
* 如果你发现 BUG，请新建 Issue。
* 如果你对 XFAssistiveTouch 有新的需求，请新建 Issue。
* 如果你想帮助改善 XFAssistiveTouch，请提交 Pull Request。

#Installation

XFAssistiveTouch 支持两种方式来安装

### 使用 cocoapods 安装

```
pod 'XFAssistiveTouch', '~>0.0.1'
```

### 通过 clone/download 安装

1. 将 XFAssistiveTouch clone 或 download 到本地
2. 将 XFAssistiveTouch 文件夹中的所有文件复制到你的项目中

#Usage

###显示 XFAssistiveTouch

* 导入头文件 
 
```
#import "XFAssistiveTouch.h"
```

* 初始化 XFAssistiveTouch

```
XFAssistiveTouch *assistiveTouch = [XFAssistiveTouch sharedInstance];
assistiveTouch.delegate = self;
[assistiveTouch showAssistiveTouch];
```

* 实现 XFXFAssistiveTouchDelegate 来初始化 XFXFAssistiveTouch 的首页

```objective-c
@protocol XFXFAssistiveTouchDelegate <NSObject>

- (NSInteger)numberOfItemsInViewController:(XFATViewController *)viewController;
- (XFATItemView *)viewController:(XFATViewController *)viewController itemViewAtPosition:(XFATPosition *)position;
- (void)viewController:(XFATViewController *)viewController didSelectedAtPosition:(XFATPosition *)position;

@end
```

###操作 XFXFAssistiveTouch

在实现 XFXFAssistiveTouchDelegate 时，你可以给首页的 XFATItemView 添加手势以便在点击的时候对 XFXFAssistiveTouch 或你项目的 UIViewController 进行交互。

####XFXFAssistiveTouch 可进行的交互

* 展开 XFXFAssistiveTouch

```
- (void)spread;
```

* 收起 XFXFAssistiveTouch

```
- (void)shrink;
```

* 在 XFXFAssistiveTouch 展示下级 XFATViewController

```
- (void)pushViewController:(XFATViewController *)viewController atPisition:(XFATPosition *)position;
```

* 回到 XFXFAssistiveTouch 上级页面

```
- (void)popViewController;
```

#### XFXFAssistiveTouch 可与项目进行的交互

* 在 targetViewcontroller 中 push 或 present 提供的 viewController。

```
- (void)pushViewController:(UIViewController *)viewController atViewController:(UIViewController *)targetViewController;
```

* 自动找到项目中最上层的 ViewController push 或 present 提供的 viewController。

```
- (void)pushViewController:(UIViewController *)viewController;
```

#Architecture

###交互
<img src = "https://github.com/xiaofei86/XFAssistiveTouch/raw/master/Images/Architecture1.png" width = 850>

###文件

|类|说明|
|---|---|
|XFATLayoutAttributes|提供方法返回某些固定的坐标和大小，用来适配 iPhone 和 iPad |
|XFATPosition|对位置信息进行封装以隐藏计算细节，项目中传递位置信息的容器|
|XFATItemView|项目中的基本视图，每个页面由最多 8 个组成|
|XFATViewController|页面控制器，控制最多 8 个 XFATItemView|
|XFATNavigationController|控制多个 XFATViewController 的切换、返回、展开、收起、移动、隐藏等的行为及动画|
|XFATRootViewController|继承自 XFATViewController，XFAssistiveTouch 的首页|
|XFAssistiveTouch|用最高层级的 UIWindows 作为 XFATNavigationController 的平台。提供代理来让用户配置首页，并提供连接 keyWindow 的方法。**用户只需直接与此类进行交互**|

#License

XFAssistiveTouch is released under the [MIT License](https://raw.githubusercontent.com/xiaofei86/XFAssistiveTouch/master/LICENSE).