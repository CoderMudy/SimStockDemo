//
//  IntroductionCattleCell.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation IntroductionCattleCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

//cell 牛人简介
- (void)bindData:(UserDescData *)desc {
  self.introductionView.text = desc.userDesc;
  [self.introductionView setTextSize:12.f];
  [self.introductionView
      setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self.introductionView fitToSuggestedHeight];
}

@end
