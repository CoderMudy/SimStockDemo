//
//  EWMultiLeftTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/7/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "EWMultiLeftTableViewCell.h"
#import "Globle.h"

@implementation EWMultiLeftTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.layer.borderColor = [Globle colorFromHexRGB:@"d8d8d8"].CGColor;
    _rightBtn.layer.borderWidth = 1;
    _rightBtn.frame = CGRectMake(10, 7, 30, 30);
    [self.contentView addSubview:_rightBtn];
    
    
    UIImage *image = [UIImage imageNamed:@"对号"];
    _rightImageView = [[UIImageView alloc]initWithImage:image];
    _rightImageView.frame = CGRectMake(15, 12, 20, 20);
    _rightImageView.hidden = YES;
    [self.contentView addSubview:_rightImageView];

    
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
