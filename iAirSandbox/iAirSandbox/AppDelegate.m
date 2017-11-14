//
//  AppDelegate.m
//  iAirSandbox
//
//  Created by itaen on 2017/11/13.
//  Copyright © 2017年 itaen. All rights reserved.
//

#import "AppDelegate.h"
#import "ITWSandboxDashBoard.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //启动摇一摇手势唤起沙盒文件预览页面
    [ITWSandboxDashBoard enableShakeToView];
    return YES;
}
@end
