//
//  ListModel.m
//  XBYPlayer
//
//  Created by xby023 on 2018/11/13.
//  Copyright © 2018年 com.BToken. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"descriptions":@"description"
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"streams":@"ListStreamsModel"
             };
}

@end


@implementation ListStreamsModel

@end
