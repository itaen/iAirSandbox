//
//  ITWPreviewViewController.m
//  iAirSandbox
//
//  Created by itaen on 2017/11/14.
//  Copyright © 2017年 itaen. All rights reserved.
//

#import "ITWPreviewViewController.h"
#import "ITWPreviewItem.h"

@interface ITWPreviewViewController ()

@property (nonatomic, strong) ITWPreviewItem *item;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ITWPreviewViewController

- (instancetype)initWithPreviewItem:(ITWPreviewItem *)item {
    self = [super init];
    if (self) {
        _item = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.item.file;
    
    UILabel *label = (UILabel *)self.navigationItem.titleView;
    if ([label isKindOfClass:[UILabel class]]) {
        label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        if (self.item.file.length > 25) {
            label.font = [UIFont systemFontOfSize:14];
        }
    }
    
    if ([self.item.file.pathExtension isEqualToString:@"plist"]) {
        NSError *error;
        NSData *data = [NSData dataWithContentsOfFile:self.item.fullpath];
        
        NSPropertyListFormat fmt;
        NSDictionary *info =
        [NSPropertyListSerialization propertyListWithData:data
                                                  options:NSPropertyListMutableContainersAndLeaves
                                                   format:&fmt
                                                    error:&error];
        if (error) {
            NSLog(@"解析plist失败：%@", error);
        }
        else {
            NSString *content = nil;
            @try {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
                content = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            } @catch (NSException *exception) {
                NSLog(@"plist转json异常：%@", exception);
                content = [NSString stringWithFormat:@"%@",info];
            } @finally {
                self.textView.text = content;
            }
        }
    }
    else if ([self.item.file.pathExtension isEqualToString:@"log"]){
        NSData *data = [NSData dataWithContentsOfFile:self.item.fullpath];
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.textView.text = content;
    }
    [self.view addSubview:self.textView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(actionClose:)];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-44, CGRectGetWidth(self.view.bounds), 44)];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self
                                                                               action:@selector(actionShare:)];
    [toolBar setItems:@[shareItem]];
    toolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolBar];

}

- (void)actionClose:(UIButton *)sender {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)actionShare:(UIButton *)sender {
    UIActivityViewController *vc = [[UIActivityViewController alloc]
                                    initWithActivityItems:@[self.item.previewItemURL]
                                    applicationActivities:nil];
    vc.excludedActivityTypes = @[UIActivityTypePostToVimeo,
                                 UIActivityTypePostToFlickr,
                                 UIActivityTypePostToTencentWeibo,
                                 UIActivityTypeAssignToContact,
                                 UIActivityTypePrint,
                                 UIActivityTypePostToFacebook,
                                 UIActivityTypePostToTwitter
                                 ];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Getters

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-44)];
        _textView.editable = NO;
        _textView.selectable = YES;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _textView;
}

@end
