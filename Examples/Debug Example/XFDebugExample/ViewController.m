//
//  ViewController.m
//  XFDebugExample
//
//  Created by 徐亚非 on 2016/10/9.
//  Copyright © 2016年 XuYafei. All rights reserved.
//

#import "ViewController.h"
//#import <XFPushController.h>
//#import <XFPushDataController.h>
#import "XFDebug.h"

@interface ViewController () <UITableViewDataSource>

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationItem.title = @"XFDebug";
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resign)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    [self.view addSubview:searchBar];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(searchBar.frame),
                                                                           CGRectGetMaxY(searchBar.frame),
                                                                           CGRectGetWidth(searchBar.frame),
                                                                           CGRectGetHeight(self.view.frame))
                                                          style:UITableViewStylePlain];
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    tableView.userInteractionEnabled = NO;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //XFDebugLog(@"%@", [[UIApplication sharedApplication].keyWindow valueForKey:@"recursiveDescription"]);
    XFDebugLog(@"%@", [NSDate date]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    if (indexPath.row % 3 == 0) {
        cell.backgroundColor = [UIColor orangeColor];
    } else if (indexPath.row % 3 == 1) {
        cell.backgroundColor = [UIColor grayColor];
    } else if (indexPath.row % 3 == 2) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)resign {
    [self.view endEditing:YES];
}

@end
