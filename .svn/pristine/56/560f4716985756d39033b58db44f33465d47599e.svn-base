//
//  MasterTradingTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15-4-24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MasterTradingTableViewCell.h"
#import "FollowBuyClientVC.h"
#import "GameWebViewController.h"

@implementation MasterTradingTableViewCell {

  ConcludesListItem *_concludesListItem;
}

- (void)awakeFromNib {

  //跳转用户评级按钮
  [_pushWebViewBtn addTarget:self
                      action:@selector(showRightPositionInfoView)
            forControlEvents:UIControlEventTouchUpInside];

  _contentBGView.layer.cornerRadius = 5.f;
  [_contentBGView.layer setMasksToBounds:YES];

  //跟买按钮
  _followBuyBtn.layer.cornerRadius = _followBuyBtn.bounds.size.height / 2;
  [_followBuyBtn.layer setMasksToBounds:YES];
  _followBuyBtn.normalBGColor = [Globle colorFromHexRGB:Color_WFOrange_btn];
  _followBuyBtn.highlightBGColor = [Globle colorFromHexRGB:Color_WFOrange_btnDown];

  [_followBuyBtn buttonWithTitle:@"跟买"
              andNormaltextcolor:@"ffffff"
        andHightlightedTextColor:@"ffffff"];
  __weak MasterTradingTableViewCell *weakSelf = self;
  [_followBuyBtn setOnButtonPressedHandler:^{
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      [weakSelf showFollowBuyPage];
    }];
  }];
}

- (void)showFollowBuyPage {
  FollowBuyClientVC *followVC = [[FollowBuyClientVC alloc] initWithStockCode:_concludesListItem.stockCode
                                                               withStockName:_concludesListItem.stockName
                                                                   withIsBuy:YES];
  [AppDelegate pushViewControllerFromRight:followVC];
}

- (void)bindConcludesListItem:(ConcludesListItem *)item {
  _concludesListItem = item;
  //稳定性
  _stabilityLabel.text = [@([item.stability integerValue] * 2) stringValue];
  //盈利性
  _profitabilityLabel.text = [@([item.profitability integerValue] * 2) stringValue];
  //准确性
  _accuracyLabel.text = [@([item.accuracy integerValue] * 2) stringValue];

  //五日收益
  _fiveDaysPrLabel.text =
      [NSString stringWithFormat:@"%.2f%%", [@([item.fiveDaysPr floatValue] * 100) floatValue]];

  if ([item.fiveDaysPr floatValue] == 0) {
    _fiveDaysPrLabel.textColor = [Globle colorFromHexRGB:Color_Black];
  } else if ([item.fiveDaysPr floatValue] > 0) {
    _fiveDaysPrLabel.textColor = _fiveDaysPrLabel.textColor = [Globle colorFromHexRGB:Color_Red];
  } else if ([item.fiveDaysPr floatValue] < 0) {
    _fiveDaysPrLabel.textColor = _fiveDaysPrLabel.textColor = [Globle colorFromHexRGB:Color_Green];
  } else {
    _fiveDaysPrLabel.textColor = [Globle colorFromHexRGB:Color_Black];
  }

  //时间
  _timeLabel.text = [SimuUtil getDateFromCtime:item.time];
  //交易内容
  _contentCTView.text = item.content;

  UserListItem *user = _concludesListItem.writer;

  [_headImageView bindUserListItem:user];

  _nickMarks.width = WIDTH_OF_SCREEN - 152;
  [_nickMarks bindUserListItem:user isOriginalPoster:NO];
}

//弹出持仓页面
- (void)showRightPositionInfoView {
  if (!_concludesListItem.writer.userId) {
    return;
  }

  NSString *userid = [_concludesListItem.writer.userId stringValue];

  if (userid) {
    //优顾交易评级报告
    [GameWebViewController showUserGradeReportWithUserId:userid];
  }
}

@end
