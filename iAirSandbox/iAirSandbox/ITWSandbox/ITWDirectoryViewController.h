//
//  ITWDirectoryViewController.h
//  iAirSandbox
//
//  Created by itaen on 2017/11/14.
//  Copyright © 2017年 itaen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITWPreviewItem.h"

@interface ITWDirectoryViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
QLPreviewControllerDelegate,
QLPreviewControllerDataSource,
UIDocumentInteractionControllerDelegate
>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, copy,   readonly) NSString *dirPath;
@property (nonatomic, strong)           NSMutableArray <ITWPreviewItem *> *previewItems;
@property (nonatomic, strong)           NSIndexPath *indexPath;

- (instancetype)initWithDirPath:(NSString *)dirPath;

@end
