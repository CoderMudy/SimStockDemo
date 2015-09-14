//
//  RankingSortCell.m
//  SimuStock
//
//  Created by jhss on 13-11-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "RankingSortCell.h"

@implementation RankingSortCell

-(void)layoutSubviews
{
  self.contentView.frame = self.bounds;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  CALayer *layer = _bgRankIcon.layer;
  self.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, self.frame.size.height);
  [layer setMasksToBounds:YES];
  [layer setCornerRadius:self.bgRankIcon.height / 2.0f];
}

@end
