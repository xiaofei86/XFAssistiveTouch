#LPDebug

[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/xiaofei86/LPAssistiveTouch/master/LICENSE)&nbsp;
[![PLATFORM](https://img.shields.io/cocoapods/p/LPDebug.svg?style=flat)](https://cocoapods.org/?q=LPDEBUG)&nbsp;
[![COCOAPODS](https://img.shields.io/cocoapods/v/LPDebug.svg?style=flat)](https://cocoapods.org/?q=LPDEBUG)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://en.wikipedia.org/wiki/IOS_8)&nbsp;
[![BLOG](https://img.shields.io/badge/blog-xuyafei.cn-orange.svg?style=flat)](http://xuyafei.cn)&nbsp;

本 Repositories 提供了 LPAssistiveTouchDemo 和 LPDebugDemo 两个 Demo。你可以在源码中学到怎样像 UIKit 一样去组织文件。

LPAssistiveTouch 是仿照 iOS 系统的辅助按钮 AssistiveTouch 制作的辅助按钮。其外观、行为、动画等效果都与系统的 AssistiveTouch 相同。如下图。

LPDebug 是基于 LPAssistiveTouch 制作的调试辅助按钮。暂时提供了页面快捷跳转、推送调试、查看和缓存打印信息三个功能。

之所以制作两个 Demo 是因为 LPDebug 开始只是满足内部需求的工具，功能也暂时比较少。所以你即可以基于 LPAssistiveTouch 建立属于自己的调试工具。也可以直接使用 LPDebug，它也会不断的进行完善。如果你对手机上调试的需求比较多，推荐去看看强大的 [FLEX](https://github.com/Flipboard/FLEX)。

```
pod 'LPDebug', '~> 1.1.0'
```

<img src = "https://github.com/xiaofei86/LPDebug/raw/master/Images/1.gif" width = 373>

##Architecture

LPAssistiveTouch 提供了和 UIKit 相同的接口。其中主要包含继承自 UIViewController 的 LPATNavigationController 和继承自 UIResponder 的 LPATViewController。

###LPATViewController

当 LPAssistiveTouch 展开后你所看到的每个按钮都是 LPATItemView。与 UIViewController 不同的是 LPATViewController 控制的是 0 - 8 个 LPATItemView。你所看到的展开后的每个界面就是 LPATViewController 控制的 N 个 View。LPATViewController 提供与系统相同的 loadView 和 viewDidload 方法用懒加载的方式去初始化 View，除此之外他还控制着自己层级的返回按钮（LPATItemView）。你可以子类化 LPATViewController 去定义自己 View 和他们的响应事件。然后调用 [self.navigationController pushViewController:viewController atPisition:position]; 来 push 出下级页面。

###LPATNavigationController

LPATNavigationController 只控制单个 contentView。他负责自己控制的所有的 LPATViewController 的 View 和 返回按钮在 contentView 上的行为，主要行为就是多级 controller 的切换和转场动画。你可以调用如下方法来 push 和 pop 控制器（LPATViewController）。

```objective-c
- (void)pushViewController:(LPATViewController *)viewController atPisition:(LPATPosition *)position;
- (void)popViewController;
```

另外他还控制收起和展开的动画。

```objective-c
- (void)spread;
- (void)shrink;
```

---

|文件|说明|
|----|----|
|LPATPosition|LPATItemView 根据 LPATPosition 来确定自己的位置|
|LPATItemView|LPATViewController 控制的对象|
|LPATViewController|LPATNavigationController 控制的对象|
|LPATNavigationController|控制 LPATViewController 实现转场动画、展开与收起|
|LPATRootViewController|继承自 LPATViewController 实现 loadView 方法来定义带手势的 LPATItemView 并提供 delegate 回调方便外部使用|
|LPATRootNavigationController|继承自 LPATNavigationController 实现在收起状态 contentView 的拖动、吸附、渐隐|
|LPAssistiveTouch|提供外部接口来使用 LPAssistiveTouch。实现 LPATRootNavigationController 与虚拟键盘的交互效果|
|LPDebug|LPDebug 供外部使用的接口|
|LPDataCache|使用 NSUserDefaults 缓存打印数据|
|LPMainViewController|LPDebug 显示打印信息的控制器。使用 LPDebugLog 打印的信息输出的目标控制器|
|LPTransformViewController|LPDebug 实现快捷跳转的控制器|
	
##Usage

###LPAssistiveTouch
	
首先通过 LPAssistiveTouch 去接 ```rootViewController``` 的代理。

```objective-c
_assistiveTouch = [LPAssistiveTouch shareInstance];
[_assistiveTouch showAssistiveTouch];
_rootViewController = (LPATRootViewController *)_assistiveTouch.rootNavigationController.rootViewController;
_rootViewController.delegate = self;
```

然后通过代理方法去设置根目录 LPATItemView 的数量、初始化 LPATItemView 、处理点击回调。

```objective-c
- (NSInteger)numberOfItemsInController:(LPATRootViewController *)atViewController {
    return 3;
}

- (LPATItemView *)controller:(LPATRootViewController *)controller itemViewAtPosition:(LPATPosition *)position {
    return [LPATItemView itemWithType: position.index + 4];
}

- (void)controller:(LPATRootViewController *)controller didSelectedAtPosition:(LPATPosition *)position {
	NSLog(@"%@", position.index);
}
```

当用户点击根目录的某个 item 的时候。可以通过 LPATNavigaitonController 的 ```pushViewController:atPisition:``` 方法 push 下级 LPATViewController。

```objective-c
- (void)controller:(LPATRootViewController *)controller didSelectedAtPosition:(LPATPosition *)position {
	// 初始化items
	NSMutableArray *array = [NSMutableArray array];
	for (int i = 0; i < 8; i++) {
	    NSString *imageName = [NSString stringWithFormat:@"Transform%d.png", i + 1];
	    CALayer *layer = [CALayer layer];
	    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:imageName].CGImage);
	    LPATItemView *itemView = [LPATItemView itemWithLayer:layer];
	    itemView.tag = _itemViewTag + i;
	    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_transformItemViewAction:)];
	    [itemView addGestureRecognizer:tapGesture];
	    [array addObject:itemView];
	}
	// 初始化 LPATViewController
	LPATViewController *viewController = [[LPATViewController alloc] initWithItems:[array copy]];
	// 在 position 处展开下一级viewController
	[_rootViewController.navigationController pushViewController:viewController atPisition:position];
}
```
在第二级目录的点击事件中可以继续 push 下一级页面，也可以使用 LPAssistiveTouch 中的 ```pushViewController:``` 这个方法会将你提供的 controller 在 keyWindows 自动找到合适的 UINavigationController 进行 push。如果没有找到，则会在合适的 UIViewController 进行 present。

```objective-c
- (void)p_transformItemViewAction:(UITapGestureRecognizer *)tapGesture {
    LPATItemView *itemView = (LPATItemView *)tapGesture.view;
    NSInteger index = itemView.tag - _itemViewTag;
    LPTransformViewController *transformViewController = [LPTransformViewController new];
    transformViewController.user = index;
    transformViewController.transformArray = [self p_getTransformViewControllersFromDelegate];
    [self pushViewController:transformViewController];
}
```

###LPDebug

LPDebug 的使用十分简单。调用 run 方法、然后接 delegate 来提供需要快捷跳转的控制器即可。

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ···
    _debug = [LPDebug run];
    _debug.transformDelegate = self;
    // ···
}

// 提供需要作快捷跳转的控制器。
- (UIViewController *)debugViewControllerByUser:(NSInteger)user atIndex:(NSInteger)index {
	 // 必须在大于某个数值时返回 nil。
    if (index > 8) {
        return nil;
    }
    UIViewController *vc = [UIViewController new];
    UIColor *color = [UIColor colorWithRed:user*30/255.0 green:index*30/255.0 blue:index*30/255.0 alpha:1];
    vc.view.backgroundColor = color;
    NSString *string = [NSString stringWithFormat:@"UIViewController%ld-%ld", user, index];
    vc.navigationItem.title = string;
    return vc;
}
```

##More

1、LPAssistiveTouch 处在 App 所有视图的最上层。可以遮盖 UIAlertView、ActionSheet、UIWindow、系统虚拟键盘等视图。

2、如下属性是用来告诉 LPAssistiveTouch 在哪个 UINavigationController 中 push 页面。如果为 nil 则自动遍历。

```objective-c
@property (nonatomic, strong) UINavigationController *navigationController;
``` 

##Link

简书地址：[http://www.jianshu.com/p/9c7cf61edb24](http://www.jianshu.com/p/9c7cf61edb24)