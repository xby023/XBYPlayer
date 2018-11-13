//
//  UINavigationController+Revolve.m
//  XBYPlayer
//
//  Created by xby023 on 2018/11/12.
//  Copyright © 2018年 com.BToken. All rights reserved.
//

#import "UINavigationController+Revolve.h"

@implementation UINavigationController (Revolve)

//是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}
//返回支持的方向
- (NSUInteger)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}
//这个是返回优先方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
