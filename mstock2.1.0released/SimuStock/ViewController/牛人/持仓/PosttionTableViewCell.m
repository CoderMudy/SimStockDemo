//
//  PosttionTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/4/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PosttionTableViewCell.h"

@implementation PosttionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, 44);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
