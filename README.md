#LPAssistiveTouch

[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/xiaofei86/LPAssistiveTouch/master/LICENSE)&nbsp;
[![PLATFORM](https://img.shields.io/cocoapods/p/LPDebug.svg?style=flat)](https://developer.apple.com/library/ios/navigation/)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://en.wikipedia.org/wiki/IOS_8)&nbsp;
[![BLOG](https://img.shields.io/badge/blog-xuyafei.cn-orange.svg?style=flat)](http://xuyafei.cn)&nbsp;

LPAssistiveTouch用来当做辅助按钮。完全仿照iOS系统的辅助按钮AssistiveTouch。外观、拖动效果、自动吸附效果、5秒渐隐效果、随键盘弹起效果等都与AssistiveTouch一致。

具体实现可参考[LPDebug](https://github.com/xiaofei86/LPDebug)（基于LPAssistiveTouch的调试工具）。

<img src = "https://github.com/xiaofei86/LPAssistiveTouch/raw/master/Images/1.gif" width = 373>

#OneLine

	[[LPAssistiveTouch shareInstance] showAssistiveTouch];
	
#Usage
	
首先通过LPAssistiveTouch去接```rootViewController```的代理。

```objective-c
_assistiveTouch = [LPAssistiveTouch shareInstance];
[_assistiveTouch showAssistiveTouch];
_rootViewController = (LPATRootViewController *)_assistiveTouch.rootNavigationController.rootViewController;
_rootViewController.delegate = self;
```

然后通过代理方法去配置根目录的每个item的样式。

```objective-c
- (LPATItemView *)controller:(LPATRootViewController *)controller itemViewAtPosition:(LPATPosition *)position {
	return [LPATItemView itemWithType:LPATItemViewTypeNSLog];
}
```

当用户点击根目录的某个item的时候，通过代理处理点击事件。可以通过LPATNavigaitonController的```pushViewController:atPisition:```方法展开下一级用户自定义的LPATViewController。

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
	//初始化LPATViewController
	LPATViewController *viewController = [[LPATViewController alloc] initWithItems:[array copy]];
	//在position除展开下一级viewController
	[_rootViewController.navigationController pushViewController:viewController
                                                              atPisition:position];
}
```
在第二级目录的点击事件中可以继续push下一级页面，也可以使用LPAssistiveTouch中的```pushViewController:```将自定义的UIViewController在keyWindows找到合适的UINavigationController进行展示。如果没有找到，则会在合适的UIViewController进行present。

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

#More

1、LPAssistiveTouch处在APP所有视图的最上层。可以遮盖UIAlertView、ActionSheet、UIWindow、系统键盘等视图。

2、如下属性是用来告诉LPAssistiveTouch在哪个UINavigationController中push页面。如果为nil则自动遍历。

	@property (nonatomic, strong) UINavigationController *navigationController;