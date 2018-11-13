//
//  ListCell.m
//  XBYPlayer
//
//  Created by xby023 on 2018/11/13.
//  Copyright © 2018年 com.BToken. All rights reserved.
//

#import "ListCell.h"
#import "UIImageView+WebCache.h"
#define ScreenHeight  [[UIScreen mainScreen] bounds].size.height
@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.clipsToBounds = YES;

}

- (void)imageContentOffY{
    CGRect rect = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    self.backImageView.transform = CGAffineTransformMakeTranslation(0,-60 * rect.origin.y/ScreenHeight);
}

- (void)setListModel:(ListModel *)listModel{
    _listModel = listModel;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:_listModel.cover] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType == SDImageCacheTypeNone) {
            self.backImageView.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.backImageView.alpha = 1;
            }];
        }
    }];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = _listModel.title;
    
}
- (IBAction)actionForPlay:(UIButton *)sender {
    if (self.playBlock) {
        CGRect rect = [self convertRect:self.bounds toView:self.superview];
        self.playBlock(rect);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
