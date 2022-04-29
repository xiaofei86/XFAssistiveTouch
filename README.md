<img src = "https://github.com/xiaofei86/XFAssistiveTouch/raw/master/Images/XFAssitiveTouchHeader.png" width = 850>

[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg?style=flat-square)](https://raw.githubusercontent.com/xiaofei86/XFAssistiveTouch/master/LICENSE)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat-square)](https://en.wikipedia.org/wiki/IOS_8)&nbsp;

XFAssistiveTouch 是仿照 iOS 系统的辅助按钮 AssistiveTouch 制作的辅助按钮。你可以用在调试等场景中使用。

## 快速开始

* 阅读此 README 文档了解 XFAssistiveTouch
* 下载 XFAssistiveTouch 运行 Examples 文件夹中的示例查看效果
* 参考 Installation 章节将 XFAssistiveTouch 集成在你的项目中
* 参考 Usage 章节或示例代码在你的项目中使用 XFAssistiveTouch

## 安装

1. 将 XFAssistiveTouch clone 或 download 到本地
2. 将 XFAssistiveTouch 文件夹中的所有文件复制到你的项目中

## 使用

### 显示 XFAssistiveTouch

* 导入头文件 
 
```objective-c
#import "XFAssistiveTouch.h"
```

* 初始化 XFAssistiveTouch

```objective-c
XFAssistiveTouch *assistiveTouch = [XFAssistiveTouch sharedInstance];
assistiveTouch.delegate = self;
[assistiveTouch showAssistiveTouch];
```

* 实现 XFAssistiveTouchDelegate 来初始化 XFAssistiveTouch 的首页

```objective-c
@protocol XFAssistiveTouchDelegate <NSObject>

- (NSInteger)numberOfItemsInViewController:(XFATViewController *)viewController;
- (XFATItemView *)viewController:(XFATViewController *)viewController itemViewAtPosition:(XFATPosition *)position;
- (void)viewController:(XFATViewController *)viewController didSelectedAtPosition:(XFATPosition *)position;

@end
```

### 操作 XFAssistiveTouch

在实现 XFAssistiveTouchDelegate 时，你可以给首页的 XFATItemView 添加手势以便在点击的时候对 XFAssistiveTouch 或你项目的 UIViewController 进行交互。

#### XFAssistiveTouch 可进行的交互

* 展开 XFAssistiveTouch

```objective-c
- (void)spread;
```

* 收起 XFAssistiveTouch

```objective-c
- (void)shrink;
```

* 在 XFAssistiveTouch 展示下级 XFATViewController

```objective-c
- (void)pushViewController:(XFATViewController *)viewController atPisition:(XFATPosition *)position;
```

* 回到 XFAssistiveTouch 上级页面

```objective-c
- (void)popViewController;
```

#### XFAssistiveTouch 可与项目进行的交互

* 在 targetViewcontroller 中 push 或 present 提供的 viewController。

```objective-c
- (void)pushViewController:(UIViewController *)viewController atViewController:(UIViewController *)targetViewController;
```

* 自动找到项目中最上层的 ViewController push 或 present 提供的 viewController。

```objective-c
- (void)pushViewController:(UIViewController *)viewController;
```

## 设计

### 交互
<img src = "https://github.com/xiaofei86/XFAssistiveTouch/raw/master/Images/Architecture1.png" width = 850>

### 文件

|类|说明|
|---|---|
|XFATLayoutAttributes|提供方法返回某些固定的坐标和大小，用来适配 iPhone 和 iPad。|
|XFATPosition|对位置信息进行封装以隐藏计算细节，项目中传递位置信息的容器。|
|XFATItemView|项目中的基本视图，每个页面由最多 8 个组成。|
|XFATViewController|页面控制器，控制最多 8 个 XFATItemView|
|XFATNavigationController|控制多个 XFATViewController 的切换、返回、展开、收起、移动、隐藏等行为及动画。|
|XFATRootViewController|继承自 XFATViewController，XFAssistiveTouch 的首页。|
|XFAssistiveTouch|用顶层 UIWindow 展示 XFATNavigationController。用户只需直接与此类进行交互。|

## 如何贡献

* 如果你在使用上有疑问、建议、需求或发现 BUG，请新建 Issue。
* 如果你想帮助改善 XFAssistiveTouch，可以提交 Pull Request。

# License

XFAssistiveTouch is released under the [MIT License](https://raw.githubusercontent.com/xiaofei86/XFAssistiveTouch/master/LICENSE).
