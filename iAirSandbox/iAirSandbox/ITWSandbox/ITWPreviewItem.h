//
//  ITWPreviewItem.h
//  iAirSandbox
//
//  Created by itaen on 2017/11/14.
//  Copyright © 2017年 itaen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

#define ITWSandboxIconName(file) [@"ITWIconBundle.bundle" stringByAppendingPathComponent:file]

NS_ASSUME_NONNULL_BEGIN
@interface ITWPreviewItem : NSObject <QLPreviewItem>

@property (nonatomic, nullable, readonly) NSURL *previewItemURL;
@property (nonatomic, nullable, readonly) NSString *previewItemTitle;

@property (nonatomic, assign, readonly)   BOOL isDirectory;
@property (nonatomic, nullable, readonly) NSString *pwd;
@property (nonatomic, nullable, readonly) NSString *file;
@property (nonatomic, nullable, readonly) NSString *fullpath;

+ (instancetype)initWithPwd:(NSString *)pwd file:(NSString *)file;

- (UIImage *)iconImage;

@end
NS_ASSUME_NONNULL_END
