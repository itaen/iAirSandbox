//
//  ITWPreviewItem.m
//  iAirSandbox
//
//  Created by itaen on 2017/11/14.
//  Copyright © 2017年 itaen. All rights reserved.
//

#import "ITWPreviewItem.h"

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
    _previewItemURL = [NSURL fileURLWithPath:self.fullpath];
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
