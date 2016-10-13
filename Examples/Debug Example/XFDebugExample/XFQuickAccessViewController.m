//
//  XFQuickAccessViewController.m
//  XFDebugExample
//
//  Created by 徐亚非 on 2016/10/9.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "XFQuickAccessViewController.h"
#import "XFDebug.h"

@interface XFQuickAccessViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation XFQuickAccessViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Unkonwn";
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)setUser:(NSInteger)user {
    _user = user;
    self.navigationItem.title = [NSString stringWithFormat:@"User%ld", user];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _transformArray[_user].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIViewController *vc = _transformArray[_user][indexPath.row];
    NSString *title = vc.navigationItem.title;
    if (!title.length) {
        title = NSStringFromClass([vc class]);
    }
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = _transformArray[_user][indexPath.row];
    [[XFAssistiveTouch sharedInstance] pushViewController:vc];
}

@end
