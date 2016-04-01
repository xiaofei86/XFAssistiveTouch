//
//  LPTransformViewController.m
//  LPDebugDemo
//
//  Created by XuYafei on 16/3/17.
//  Copyright © 2016年 loopeer. All rights reserved.
//

#import "LPTransformViewController.h"
#import "LPDebug.h"

@interface LPTransformViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation LPTransformViewController

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
    self.navigationItem.title = [NSString stringWithFormat:@"User%ld", user + 1];
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
    [[LPAssistiveTouch shareInstance] pushViewController:vc];
}

@end
