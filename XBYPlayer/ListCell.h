//
//  ListCell.h
//  XBYPlayer
//
//  Created by xby023 on 2018/11/13.
//  Copyright © 2018年 com.BToken. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListModel.h"

@interface ListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (nonatomic ,strong) ListModel *listModel;

@property (nonatomic ,copy) void(^playBlock)(CGRect rect);
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)imageContentOffY;

@end
