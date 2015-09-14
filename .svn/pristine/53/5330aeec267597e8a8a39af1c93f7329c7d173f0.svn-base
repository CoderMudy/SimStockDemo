//
//  SelfStockTableHeaderView.m
//  SimuStock
//
//  Created by Mac on 15/5/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SelfStockTableHeaderView.h"
#import "FullScreenLogonViewController.h"
#import "LoginLogoutNotification.h"
#import "SimuUtil.h"

static float const space = 3.5f;
static float const ArrowWidth = 9;

#define GROUP_TABLE_HEADER_WIDTH_MAX WIDTH_OF_SCREEN / 3.f - 10

@implementation SelfStockTableHeaderView

- (void)awakeFromNib {
  [super awakeFromNib];
  _btnLogin.normalBGColor = [UIColor clearColor];
  _btnLogin.highlightBGColor = [Globle colorFromHexRGB:@"9be5f2"];

  _btnSort.normalBGColor = [UIColor clearColor];
  _btnSort.highlightBGColor = [Globle colorFromHexRGB:@"#333333" alpha:0.12f];

  [_groupButton setBackgroundImage:[SimuUtil imageFromColor:@"#333333" alpha:0.12f]
                          forState:UIControlStateHighlighted];

  [_btnLogin setOnButtonPressedHandler:^{
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined){
        // TODO

    }];
  }];
}

- (void)bindGroup:(NSString *)groupName {
  self.lblGroup.text = groupName;
  CGSize size = [self.lblGroup sizeThatFits:CGSizeMake(WIDTH_OF_SCREEN, 30)];
  if ([SimuUtil isLogined]) {
    self.imgSwitchGroup.hidden = NO;
    self.groupButton.hidden = NO;
    _arrowWidth.constant = ArrowWidth;

    CGFloat computeWidth = size.width + space + ArrowWidth;

    if (computeWidth > GROUP_TABLE_HEADER_WIDTH_MAX) {
      self.groupWidth.constant = GROUP_TABLE_HEADER_WIDTH_MAX;
      self.lblGroup.adjustsFontSizeToFitWidth = YES;
    } else {
      self.groupWidth.constant = computeWidth;
    }
  } else {
    self.imgSwitchGroup.hidden = YES;
    self.groupButton.hidden = YES;
    _arrowWidth.constant = 0.f;
    self.groupWidth.constant = size.width + space + space;
  }
}

@end
