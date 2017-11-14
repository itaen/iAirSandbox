//
//  ITWSandboxRootViewController.m
//  iAirSandbox
//
//  Created by itaen on 2017/11/14.
//  Copyright © 2017年 itaen. All rights reserved.
//

#import "ITWSandboxRootViewController.h"
#import "ITWSandboxDashBoard.h"
#import "ITWDirectoryViewController.h"


@interface ITWSandboxRootViewController()

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation ITWSandboxRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"沙盒阅览器";
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(actionClose:)];
    self.view.backgroundColor = [UIColor grayColor];

}

- (void)actionClose:(UIButton *)sender {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [ITWSandboxDashBoard clearShared];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 1) {
        cell.textLabel.text = @"Document";
        cell.imageView.image = [UIImage imageNamed:ITWSandboxIconName(@"001-folder")];
    }
    else {
        cell.textLabel.text = @"Bundle";
        cell.imageView.image = [UIImage imageNamed:ITWSandboxIconName(@"005-app-store")];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    NSString *path = NSHomeDirectory();
    if (row == 0) {
        path = [[NSBundle mainBundle] bundlePath];
    }
    ITWDirectoryViewController *vc = [[ITWDirectoryViewController alloc] initWithDirPath:path];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    
    return _tableView;
}

@end

