//
//  MatchUniversityNameCell.m
//  SimuStock
//
//  Created by Jhss on 15/8/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MatchUniversityNameCell.h"

@implementation MatchUniversityNameCell

- (void)awakeFromNib {
  // Initialization code
  //下划线的高度
  self.lineHeight.constant = 0.5f;
  self.lineSpaceVertical.constant = 0.5f;
  self.verticalLine.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
