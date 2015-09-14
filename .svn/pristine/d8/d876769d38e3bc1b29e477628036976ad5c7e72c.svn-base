//
//  WBPrasieCell.m
//  SimuStock
//
//  Created by jhss on 14-12-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WBPrasieCell.h"
#import "CellBottomLinesView.h"

@implementation WBPrasieCell

- (void)awakeFromNib {
  [_headBGView.layer setMasksToBounds:YES];
  [_headBGView.layer setCornerRadius:20.0f];
  [_headBGView.layer setBorderWidth:0.5f];
  [_headBGView.layer setBorderColor:[Globle colorFromHexRGB:Color_Border].CGColor];

  [_userHeadImageView.layer setMasksToBounds:YES];
  [_userHeadImageView.layer setCornerRadius:18.0f];

  //分界线
  [CellBottomLinesView addBottomLinesToCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}
- (void)bindPraiseList:(PraiseList *)item {
  //设置头像
  [self.headBGView bindUserListItem:item.writer];
  //用户评级控件
  self.userGradeView.width = WIDTH_OF_SCREEN - 112;
  [self.userGradeView bindUserListItem:item.writer isOriginalPoster:NO];
}

@end
