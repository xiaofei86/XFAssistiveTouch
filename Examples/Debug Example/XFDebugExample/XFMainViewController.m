//
//  XFMainViewController.m
//  XFDebugExample
//
//  Created by 徐亚非 on 2016/10/9.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFMainViewController.h"
#import "XFDebug.h"
#import "XFUserDefaults.h"

static NSString *const kXFDebugLogCacheKey = @"kXFDebugLogCacheKey";

@interface XFMainViewController ()

@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)NSString *cacheString;
@property (nonatomic, assign) BOOL isPrevious;

@end

@implementation XFMainViewController

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

+ (void)print:(NSString *)string {
    XFMainViewController *vc = [self sharedInstance];
    UITextView *textView = vc->_textView;
    textView.text = [NSString stringWithFormat:@"%@%@\n", textView.text, string];
    [XFUserDefaults setCacheData:@[textView.text] withKey:kXFDebugLogCacheKey];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cacheString = [XFUserDefaults getCacheDataWithKey:kXFDebugLogCacheKey].firstObject;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleDone target:self action:@selector(switchAction:)];
    
    _textView = [[UITextView alloc] initWithFrame:self.view.frame];
    _textView.text = [NSString string];
    _textView.editable = NO;
    [self.view addSubview:_textView];
}

- (void)switchAction:(UIBarButtonItem *)barButtonItem {
    NSString *temp = _cacheString;
    _cacheString = _textView.text;
    _textView.text = temp;
    
    _isPrevious = !_isPrevious;
    if (_isPrevious) {
        self.navigationItem.rightBarButtonItem.title = @"Next";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"Previous";
    }
}

@end
