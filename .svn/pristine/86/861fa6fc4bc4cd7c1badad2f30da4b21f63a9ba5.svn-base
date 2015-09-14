//
//  MyTranceXIBCell.m
//  SimuStock
//
//  Created by Yuemeng on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TrancingXIBCell.h"
#import "UserGradeView.h"
#import "TraceItem.h"
#import "UIImageView+WebCache.h"
#import "StockPositionViewController.h"

@implementation TrancingXIBCell

- (void)awakeFromNib {
  _grayLineHeight.constant = .5f;
  _whiteLineHeight.constant = .5f;
}

- (void)bindInfo:(TraceItem *)item {
  [_headImageView setImageWithURL:[NSURL URLWithString:item.mPhoto]
                 placeholderImage:[UIImage imageNamed:@"stockBarIcon.png"]];

  _userGradeView.width = WIDTH_OF_SCREEN - 156;
  [_userGradeView bindUserListItem:item.userListItem isOriginalPoster:NO];

  [_userButton setOnButtonPressedHandler:^{
    _userButton.backgroundColor = [Globle colorFromHexRGB:@"83888B"];
    [SimuUtil performBlockOnMainThread:^{
      _userButton.backgroundColor = [Globle colorFromHexRGB:Color_White];
      StockPositionViewController *stockPositionVC =
          [[StockPositionViewController alloc] initWithID:item.mFollowUid
                                             withNickName:item.mNick
                                              withHeadPic:item.mPhoto
                                              withMatchID:item.mFollowMid
                                              withViptype:[item.mVipType integerValue]
                                             withUserItem:item.userListItem];
      stockPositionVC.isTracing = YES;
      [AppDelegate pushViewControllerFromRight:stockPositionVC];

    } withDelaySeconds:.2f];

  }];

  NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]
      initWithString:[NSString stringWithFormat:@"总盈利率：%@", item.mProfitRate]];
  [attStr addAttribute:NSForegroundColorAttributeName
                 value:[StockUtil getColorByChangePercent:item.mProfitRate]
                 range:NSMakeRange(5, [attStr length] - 5)];
  _rateLabel.attributedText = attStr;
}

@end
