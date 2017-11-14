//
//  ITWSandboxDashBoard.m
//  iAirSandbox
//
//  Created by itaen on 2017/11/13.
//  Copyright © 2017年 itaen. All rights reserved.
//

#import "ITWSandboxDashBoard.h"
#import <Aspects.h>
#import "ITWSandboxRootViewController.h"

@implementation ITWSandboxDashBoard

static ITWSandboxDashBoard *p_dashboard;
+ (instancetype)shared {
    @synchronized(self) {
        if (p_dashboard) {
            return p_dashboard;
        }
    }
    ITWSandboxRootViewController *vc = [[ITWSandboxRootViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    ITWSandboxDashBoard *dashboard = [[ITWSandboxDashBoard alloc] initWithRootViewController:vc];
    p_dashboard = dashboard;
    
    return dashboard;
}

+ (void)clearShared {
    p_dashboard = nil;
}

+ (void)popUpDashboard {
    if (p_dashboard) {
        [[ITWSandboxDashBoard shared] dismissViewControllerAnimated:YES completion:nil];
        [self clearShared];
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
