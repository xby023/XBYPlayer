//
//  XBYPlayer.h
//  XBYPlayer
//
//  Created by xby023 on 2018/11/12.
//  Copyright © 2018年 com.BToken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBYPlayer : UIView

@property (nonatomic ,copy) NSString *videoUrl;

- (void)pauseVideo;

@end
