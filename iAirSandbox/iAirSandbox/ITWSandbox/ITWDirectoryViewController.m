//
//  ITWDirectoryViewController.m
//  iAirSandbox
//
//  Created by itaen on 2017/11/14.
//  Copyright © 2017年 itaen. All rights reserved.
//

#import "ITWDirectoryViewController.h"
#import "ITWSandboxDashBoard.h"

@implementation ITWDirectoryViewController
@synthesize tableView = _tableView;

- (instancetype)initWithDirPath:(NSString *)dirPath {
    self = [super init];
    if (self) {
        _dirPath = dirPath;
        
        BOOL isDirectory;
        if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDirectory] || !isDirectory) {
            return nil;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(actionClose:)];
    [self.view addSubview:self.tableView];
    
    NSError *error = nil;
    NSArray <NSString *> *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.dirPath error:&error];
    self.previewItems = @[].mutableCopy;
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error = nil;
        NSDictionary <NSFileAttributeKey,id> *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self.dirPath stringByAppendingPathComponent:obj] error:&error];
        NSString *fileType = attributes[NSFileType];
        if ([fileType isEqualToString:NSFileTypeRegular] || [fileType isEqualToString:NSFileTypeDirectory]) {
            ITWPreviewItem *previewItem = [ITWPreviewItem initWithPwd:self.dirPath file:obj];
            [self.previewItems addObject:previewItem];
        }
    }];
}

- (void)actionClose:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [ITWSandboxDashBoard clearShared];
}

#pragma mark - UITableViewDataSource &UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.previewItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ITWPreviewItem *previewItem = self.previewItems[indexPath.row];
    cell.textLabel.text = previewItem.previewItemTitle;
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = [previewItem iconImage];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ITWPreviewItem *item = self.previewItems[indexPath.row];
    if (item.isDirectory) {
        ITWDirectoryViewController *dirVC = [[ITWDirectoryViewController alloc] initWithDirPath:item.fullpath];
        [self.navigationController pushViewController:dirVC animated:YES];
    }else{
        if (![QLPreviewController canPreviewItem:item]) {
            NSLog(@"无法预览: %@",item);
            if (![item.previewItemURL isFileURL]) {
                NSLog(@"previewItemURL is not FILE URL");
            }
            //pop up previewViewController,action sheet to send file to other app or tools
            
        }
        
        self.indexPath = indexPath;
        QLPreviewController *previewVC = [QLPreviewController new];
        previewVC.dataSource = self;
        previewVC.delegate = self;
        [self presentViewController:previewVC animated:YES completion:nil];
    }
}

#pragma mark - QLPreviewViewController DataSource & Delegate

- (NSInteger)numberOfPreviewItemsInPreviewController:(nonnull QLPreviewController *)controller {
    return 1;
}

- (nonnull id<QLPreviewItem>)previewController:(nonnull QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.previewItems[self.indexPath.row];
}

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id<QLPreviewItem>)item {
    return YES;
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 48;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
