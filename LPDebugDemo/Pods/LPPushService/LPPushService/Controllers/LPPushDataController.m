//
//  LPPushDataController.m
//  LPPushServiceDemo
//
//  Created by XuYafei on 15/9/28.
//  Copyright © 2015年 loopeer. All rights reserved.
//

#import "LPPushDataController.h"
#import "LPPushDataManager.h"

@protocol LPEditTableViewCellDelegate <NSObject>

- (void)textFieldShouldEndEditing:(NSString *)text indexPath:(NSIndexPath *)indexPath;

@end

@interface LPEditTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (assign, nonatomic) id<LPEditTableViewCellDelegate> delegate;

@property (strong, nonatomic) UITextField *keyTextField;

@property (strong, nonatomic) UITextField *valueTextField;

@end

@implementation LPEditTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(
                          self.contentView.frame.origin.x,
                          self.contentView.frame.origin.y,
                          self.contentView.frame.size.width / 4,
                          self.contentView.frame.size.height)];
        _keyTextField.font = [UIFont systemFontOfSize:14];
        _keyTextField.textAlignment = NSTextAlignmentRight;
        _keyTextField.enabled = NO;
        [self.contentView addSubview:_keyTextField];
        
        _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(
                            _keyTextField.frame.origin.x + _keyTextField.frame.size.width,
                            _keyTextField.frame.origin.y,
                            self.contentView.frame.size.width - _keyTextField.frame.size.width,
                            _keyTextField.frame.size.height)];
        _valueTextField.delegate = self;
        _valueTextField.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_valueTextField];
        
    }
    return self;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:indexPath:)]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tag % 100 inSection:self.tag / 100];
        NSString *text = _valueTextField.text;
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [self.delegate textFieldShouldEndEditing:text indexPath:indexPath];
    }
    return YES;
}

@end

@interface LPPushDataController () <UITableViewDelegate, UITableViewDataSource, LPEditTableViewCellDelegate>

@end

@implementation LPPushDataController {
    NSArray *_data;
    UITableView *_tableView;
}

#pragma mark - LoadView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"Data";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDataController)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveData)];
    
    _data = [LPPushDataManager getCacheData];
    
    CGRect frame = self.view.frame;
    frame.size.height -= 64;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    [_tableView registerClass:[LPEditTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LPEditTableViewCell class])];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[_data objectAtIndex:section] allKeys] count] - 1 + [[[[_data objectAtIndex:section] objectForKey:@"aps"] allKeys] count];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LPEditTableViewCell class]) forIndexPath:indexPath];
    cell.tag = indexPath.section * 100 + indexPath.row;
    cell.delegate = self;
    NSDictionary *dictionary = [_data objectAtIndex:indexPath.section];
    NSDictionary *apsDictionary = [dictionary objectForKey:@"aps"];
    NSInteger apsCount = [[apsDictionary allKeys] count];
    if (indexPath.row < apsCount) {
        cell.keyTextField.text = [NSString stringWithFormat:@"%@  :", [[apsDictionary allKeys] objectAtIndex:indexPath.row]];
        NSString *value = [apsDictionary objectForKey:[[apsDictionary allKeys] objectAtIndex:indexPath.row]];
        cell.valueTextField.text = [NSString stringWithFormat:@"  %@", value];
    } else {
        cell.keyTextField.text = [NSString stringWithFormat:@"%@  :", [[dictionary allKeys] objectAtIndex:indexPath.row - apsCount + 1]];
        NSString *value = [dictionary objectForKey:[[dictionary allKeys] objectAtIndex:indexPath.row - apsCount + 1]];
        cell.valueTextField.text = [NSString stringWithFormat:@"  %@", value];;
    }
    return cell;
}

#pragma mark - EditTableViewCellDelegate

- (void)textFieldShouldEndEditing:(NSString *)text indexPath:(NSIndexPath *)indexPath {
    NSMutableArray *mutableArray = [_data mutableCopy];
    NSMutableDictionary *mutableDictionary = [[mutableArray objectAtIndex:indexPath.section] mutableCopy];
    NSMutableDictionary *mutableAps = [[mutableDictionary objectForKey:@"aps"] mutableCopy];
    NSInteger apsCount = [[mutableAps allKeys] count];
    if (indexPath.row < apsCount) {
        [mutableAps setObject:text forKey:[[mutableAps allKeys] objectAtIndex:indexPath.row]];
        [mutableDictionary setObject:mutableAps forKey:@"aps"];
    } else {
        [mutableDictionary setObject:text forKey:[[mutableDictionary allKeys] objectAtIndex:indexPath.row - apsCount + 1]];
    }
    [mutableArray replaceObjectAtIndex:indexPath.section withObject:mutableDictionary];
    _data = [mutableArray copy];
    [LPPushDataManager setCacheData:_data];
    _data = [LPPushDataManager getCacheData];
    [_tableView reloadData];
}

#pragma mark - Action

- (void)saveData {
    [self.view endEditing:YES];
}

- (void)dismissDataController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
