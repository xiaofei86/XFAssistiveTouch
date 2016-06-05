//
//  LPMainViewController.m
//  LPDebugDemo
//
//  Created by 徐亚非 on 16/5/29.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPMainViewController.h"
#import "LPDebug.h"
#import "LPDataCache.h"

static NSString *const kLPDebugLogCacheKey = @"kLPDebugLogCacheKey";

@implementation LPMainViewController {
    UITextView *_textView;
    NSString *_cacheString;
    BOOL _isPrevious;
}

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

+ (void)print:(NSString *)string {
    LPMainViewController *vc = [self sharedInstance];
    UITextView *textView = vc->_textView;
    textView.text = [NSString stringWithFormat:@"%@%@\n", textView.text, string];
    [LPDataCache setCacheData:@[textView.text] withKey:kLPDebugLogCacheKey];
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
    
    _cacheString = [LPDataCache getCacheDataWithKey:kLPDebugLogCacheKey].firstObject;
    
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
