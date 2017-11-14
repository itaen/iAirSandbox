//
//  ITWSandboxDashBoard.m
//  iAirSandbox
//
//  Created by itaen on 2017/11/13.
//  Copyright © 2017年 itaen. All rights reserved.
//



#import "ITWSandboxDashBoard.h"
#import <Aspects.h>
#import <QuickLook/QuickLook.h>

#define ITWSandboxIconName(file) [@"ITWIconBundle.bundle" stringByAppendingPathComponent:file]


@interface ITWPreviewItem : NSObject <QLPreviewItem>

@property (nonatomic, nullable, readonly) NSURL *previewItemURL;
@property (nonatomic, nullable, readonly) NSString *previewItemTitle;

@property (nonatomic, assign, readonly)   BOOL isDirectory;
@property (nonatomic, nullable, readonly) NSString *pwd;
@property (nonatomic, nullable, readonly) NSString *file;
@property (nonatomic, nullable, readonly) NSString *fullpath;

+ (instancetype)initWithPwd:(NSString *)pwd file:(NSString *)file;

@end

@implementation ITWPreviewItem
{
    BOOL _ready;
}

@synthesize previewItemURL = _previewItemURL;
@synthesize previewItemTitle = _previewItemTitle;
@synthesize isDirectory = _isDirectory;
@synthesize pwd = _pwd;
@synthesize file = _file;

+ (instancetype)initWithPwd:(NSString *)pwd file:(NSString *)file {
    return [[ITWPreviewItem alloc] initWithPwd:pwd file:file];
}

- (instancetype)initWithPwd:(NSString *)pwd file:(NSString *)file {
    self = [super init];
    if (self) {
        _pwd = pwd;
        _file = file;
        _fullpath = [pwd stringByAppendingPathComponent:file];
    }
    return self;
}

- (NSURL *)previewItemURL {
    if (_previewItemURL) {
        return _previewItemURL;
    }
    _previewItemURL = [NSURL URLWithString:self.fullpath];
    return _previewItemURL;
}

- (NSString *)previewItemTitle {
    return self.file;
}

- (BOOL)isDirectory {
    if (_ready) {
        return _isDirectory;
    }

    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self.pwd stringByAppendingPathComponent:self.file] error:nil];
    _isDirectory = [attributes[NSFileType] isEqualToString:NSFileTypeDirectory];
    _ready = YES;
    return _isDirectory;
}

- (NSDictionary <NSFileAttributeKey,id> *)attributes {
    return [[NSFileManager defaultManager] attributesOfItemAtPath:self.fullpath error:nil];
}

- (UIImage *)iconImage {
    ITWPreviewItem *item = self;
    NSString *iconName = [self iconForFile:item.file];
    return [UIImage imageNamed:ITWSandboxIconName(iconName)];
}

- (NSString *)iconForFile:(NSString *)file {
    if (!file) {
        return nil;
    }
    NSString *extension = file.pathExtension.lowercaseString;
    if (extension) {
        NSString *icon = [self iconForKey:extension];
        if (icon) {
            return icon;
        }
    }
    
    if (self.isDirectory) {
        return [self iconForKey:@"folder"];
    }
    return [self iconForKey:@"document"];
    
}

- (NSString *)iconForKey:(NSString *)key {
    static NSDictionary *type2icon = nil;
    if (!type2icon) {
        type2icon =  @{@"folder":@"001-folder",
                       @"exit":@"002-exit",
                       @"app":@"005-app-store",
                       @"mov":@"006-mov",
                       @"flv":@"007-flv",
                       @"avi":@"008-avi",
                       @"mp3":@"009-mp3",
                       @"js":@"010-js",
                       @"css":@"011-css",
                       @"html":@"012-html",
                       @"gif":@"013-gif",
                       @"pdf":@"014-pdf",
                       @"jpg":@"015-jpg",
                       @"zip":@"016-zip",
                       @"png":@"017-png",
                       @"txt":@"018-txt",
                       @"db":@"030-db",
                       @"sqlite":@"030-db",
                       @"document":@"document.png"
                       };
    }
    return type2icon[key];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p> %@",NSStringFromClass(self.class),self,@{@"URL":self.previewItemURL}];
}

@end


@interface ITWDirectoryViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
QLPreviewControllerDelegate,
QLPreviewControllerDataSource,
UIDocumentInteractionControllerDelegate
>



@end

@interface ITWSandboxDashBoard ()

@property (nonatomic, strong) UIViewController *rootViewController;

@end

@implementation ITWSandboxDashBoard

static ITWSandboxDashBoard *p_dashboard;
+ (instancetype)shared {
    @synchronized(self) {
        if (p_dashboard) {
            return p_dashboard;
        }
    }
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    ITWSandboxDashBoard *dashboard = [[ITWSandboxDashBoard alloc] initWithRootViewController:vc];
    p_dashboard = dashboard;
    
    return dashboard;
}

+ (void)clearShared {
    p_dashboard = nil;
}

+ (void)dissmiss {
    [[ITWSandboxDashBoard shared] dismissViewControllerAnimated:YES completion:nil];
    [self clearShared];
}

+ (void)popUpDashboard {
    if (p_dashboard) {
        [self dissmiss];
        return;
    }
    UIViewController *vc = [[[UIApplication sharedApplication].delegate window] rootViewController];
    [vc presentViewController:[ITWSandboxDashBoard shared] animated:YES completion:nil];
}

static BOOL enableShakePopUp = NO;
+ (void)enableShakeToView {
#ifdef DEBUG
    enableShakePopUp = YES;
    [[UIApplication sharedApplication] aspect_hookSelector:@selector(motionEnded:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UIEventSubtype subtype, UIEvent *event){
        [self motionEnded:subtype withEvent:event];
    } error:nil];
#endif
}

+ (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake && enableShakePopUp) {
        [self popUpDashboard];
    }
}



@end
