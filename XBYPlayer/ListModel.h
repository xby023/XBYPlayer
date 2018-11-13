//
//  ListModel.h
//  XBYPlayer
//
//  Created by xby023 on 2018/11/13.
//  Copyright © 2018年 com.BToken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface ListModel : NSObject

@property (nonatomic ,copy) NSString *title;

@property (nonatomic ,copy) NSString *cover;

@property (nonatomic ,copy) NSString *descriptions;

@property (nonatomic ,strong) NSArray *streams;

@end

@interface ListStreamsModel : NSObject

@property (nonatomic ,copy) NSString *quality;

@property (nonatomic ,copy) NSString *url;

@property (nonatomic ,copy) NSString *duration;

@property (nonatomic ,copy) NSString *size;

@property (nonatomic ,copy) NSString *width;

@property (nonatomic ,copy) NSString *height;



@end
