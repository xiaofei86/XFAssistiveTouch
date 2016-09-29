# XFAssistiveTouch

[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/xiaofei86/LPAssistiveTouch/master/LICENSE)&nbsp;
[![PLATFORM](https://img.shields.io/cocoapods/p/LPDebug.svg?style=flat)](https://cocoapods.org/?q=LPDEBUG)&nbsp;
[![COCOAPODS](https://img.shields.io/cocoapods/v/LPDebug.svg?style=flat)](https://cocoapods.org/?q=LPDEBUG)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://en.wikipedia.org/wiki/IOS_8)&nbsp;
[![BLOG](https://img.shields.io/badge/blog-xuyafei.cn-orange.svg?style=flat)](http://xuyafei.cn)&nbsp;

正在重构……	暂不可用！！！

LPAssistiveTouch 是仿照 iOS 系统的辅助按钮 AssistiveTouch 制作的辅助按钮。

<img src = "https://github.com/xiaofei86/LPDebug/raw/master/Images/1.gif" width = 373>
	
##Usage
	
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

##Link

简书地址：[http://www.jianshu.com/p/9c7cf61edb24](http://www.jianshu.com/p/9c7cf61edb24)