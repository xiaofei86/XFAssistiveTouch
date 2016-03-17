//
//  LPPushController.m
//  LPPushServiceDemo
//
//  Created by XuYafei on 15/9/28.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPPushController.h"
#import "LPPushDataController.h"
#import "LPPushDataManager.h"
#import <BPush.h>

@interface LPBaseCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation LPBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _textLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.userInteractionEnabled = NO;
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

@end

static const NSInteger itemHeight = 40;

@interface LPPushController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>

@end

@implementation LPPushController {
    LPPushDataManager *_dataManager;
    NSArray *_titleArray;
    NSMutableArray *_logArray;
    UICollectionView *_collectionView;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _titleArray = @[@"绑定", @"解绑", @"App ID", @"User ID", @"Channel ID", @"Set Tags", @"Del Tags", @"List Tags",];
        _logArray = [[NSMutableArray alloc] init];
        [_logArray addObject:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Caches/com.baidu.native_push.default"]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceTokenFail:) name:kPushGetDeviceTokenFailNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceTokenSuccess:) name:kPushGetDeviceTokenSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchWithNotification:) name:kPushLaunchNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotification:) name:kPushLocalNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(silentNotification:) name:kPushRemoteNotification object:nil];
        [LPPushDataManager setAppBadgeNumber:0];
    }
    return self;
}

#pragma mark - LoadView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"LPPushService";
    UIBarButtonItem *dataItem = [[UIBarButtonItem alloc] initWithTitle:@"Data" style:UIBarButtonItemStylePlain target:self action:@selector(showData)];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearLogs)];
    self.navigationItem.rightBarButtonItems = @[dataItem, clearItem];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.itemSize = CGSizeMake(itemHeight * 2, itemHeight);
    collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewFlowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, itemHeight) collectionViewLayout:collectionViewFlowLayout];
    [_collectionView registerClass:[LPBaseCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    _tagInputTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, itemHeight, self.view.frame.size.width, itemHeight)];
    _tagInputTextField.font = [UIFont systemFontOfSize:12];
    _tagInputTextField.textColor = [UIColor colorWithRed:0 green:122.0 / 255.0 blue:1 alpha:1];
    _tagInputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tagInputTextField.placeholder = @"多个标签之间用英文逗号隔开";
    _tagInputTextField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_tagInputTextField];
    
    _outputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, itemHeight * 2, self.view.frame.size.width, self.view.frame.size.height - itemHeight * 2 - 64)];
    _outputTextView.editable = NO;
    _outputTextView.delegate = self;
    [_outputTextView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)]];
    [self.view addSubview:_outputTextView];
    
    [self updateLogs];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.presentedViewController) {
        if ([LPPushDataManager isLuanchFromNotification]) {
            [self addLogString:@"is luanch from notification"];
        } else {
            [self addLogString:@"is luanch from app icon"];
        }
    }
}

#pragma mark - UICollectionViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self bind:indexPath];
            break;
        case 1:
            [self unbind:indexPath];
            break;
        case 2:
            [self appId:indexPath];
            break;
        case 3:
            [self userId:indexPath];
            break;
        case 4:
            [self channelId:indexPath];
            break;
        case 5:
            [self setTags:indexPath];
            break;
        case 6:
            [self delTags:indexPath];
            break;
        case 7:
            [self lisTags:indexPath];
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rgb = 0.4 + indexPath.row * 0.02;
    if (indexPath.row == 0 || indexPath.row == _titleArray.count - 1) {
        _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
    }
    LPBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
    return cell;
}

#pragma mark - Notification

- (void)getDeviceTokenFail:(NSNotification *)notification {
    NSDictionary *dictionary = (NSDictionary *)[notification object];
    [self addLogString:[NSString stringWithFormat:@"%@", dictionary]];
}

- (void)getDeviceTokenSuccess:(NSNotification *)notification {
    NSDictionary *dictionary = (NSDictionary *)[notification object];
    [self addLogString:[NSString stringWithFormat:@"%@", dictionary]];
}

- (void)launchWithNotification:(NSNotification *)notification {
    [self addLogString:@"receiveLaunchNotification"];
}

- (void)localNotification:(NSNotification *)notification {
    NSDictionary *dictionary = (NSDictionary *)[notification object];
    [self addLogString:[NSString stringWithFormat:@"%@", dictionary]];
}

- (void)remoteNotification:(NSNotification *)notification {
    NSDictionary *dictionary = (NSDictionary *)[notification object];
    [self addLogString:[NSString stringWithFormat:@"%@", dictionary]];
}

- (void)silentNotification:(NSNotification *)notification {
    NSDictionary *dictionary = (NSDictionary *)[notification object];
    [self addLogString:[NSString stringWithFormat:@"%@", dictionary]];
}

#pragma mark - LogAction

- (void)clearLogs {
    _logArray = [[NSMutableArray alloc] init];
    _outputTextView.text = [NSString string];
    [self endEditing];
}

- (void)updateLogs {
    NSMutableArray *array = [_logArray mutableCopy];
    [self clearLogs];
    for (int i = 0; i < array.count; i++) {
        [self addLogString:[NSString stringWithFormat:@"%@", array[i]]];
    }
    [self endEditing];
}

- (void)addLogString:(NSString *)logStr {
    logStr = [self replaceUnicode:logStr];
    NSString *additionStr = [logStr stringByAppendingString:@"\n\n"];
    [_logArray addObject:additionStr];
    NSString *preLogString = self.outputTextView.text;
    if (preLogString) {
        [self.outputTextView setText:[additionStr stringByAppendingString:preLogString]];
    } else {
        [self.outputTextView setText:additionStr];
    }
    [self endEditing];
}

#pragma mark - ButtonAction

- (void)endEditing {
    [self.view endEditing:YES];
}

- (void)showData {
    LPPushDataController *dataController = [[LPPushDataController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dataController];
    [self.navigationController presentViewController:navigationController animated:YES completion:^{}];
}

- (void)bind:(id)sender {
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        [self addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodBind,result]];
    }];
}

- (void)unbind:(id)sender {
    [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
        [self addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodUnbind,result]];
    }];
}

- (void)setTags:(id)sender {
    NSString *tagsString = self.tagInputTextField.text;
    if (![self checkTagString:tagsString]) {
        return;
    }
    NSArray *tags = [tagsString componentsSeparatedByString:@","];
    if (tags) {
        [BPush setTags:tags withCompleteHandler:^(id result, NSError *error) {
            [self addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodSetTag,result]];
        }];
    }
}

- (void)delTags:(id)sender {
    NSString *tagsString = self.tagInputTextField.text;
    if (![self checkTagString:tagsString]) {
        return;
    }
    NSArray *tags = [tagsString componentsSeparatedByString:@","];
    if (tags) {
        [BPush delTags:tags withCompleteHandler:^(id result, NSError *error) {
            [self addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodDelTag,result]];
        }];
    }
}

- (void)lisTags:(id)sender {
    [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
        [self addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodListTag,result]];
    }];
}

- (void)appId:(id)sender {
    [self addLogString:[@"App ID : " stringByAppendingString:[BPush getAppId]]];
}

- (void)userId:(id)sender {
    [self addLogString:[@"User ID : " stringByAppendingString:[BPush getUserId]]];
}

- (void)channelId:(id)sender {
    [self addLogString:[@"Channel ID : " stringByAppendingString:[BPush getChannelId]]];
}

- (BOOL)checkTagString:(NSString *)tagStr {
    NSString *str = [tagStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    if ([str isEqualToString:@""]) {
        [self addLogString:@"tags can not be empty"];
        return NO;
    }
    return YES;
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80000
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListImmutable
                                                                     format:NULL
                                                                      error:NULL];
#else
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
#endif
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

@end
