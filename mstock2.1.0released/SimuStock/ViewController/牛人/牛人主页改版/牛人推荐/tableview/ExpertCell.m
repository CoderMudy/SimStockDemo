//
//  ExpertCell.m
//  SimuStock
//
//  Created by 刘小龙 on 15/9/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertCell.h"
#import "StockUtil.h"
#import "Globle.h"
#import "FollowBuyClientVC.h"
#import "TrendViewController.h"

@implementation ExpertCell

- (void)awakeFromNib {
  //跟买按钮
  self.buyButton.layer.cornerRadius = 11.50f;
  self.buyButton.layer.masksToBounds = YES;
  self.buyButton.layer.borderColor = [Globle colorFromHexRGB:@"F89324"].CGColor;
  self.buyButton.layer.borderWidth = 0.5f;
  [self.buyButton buttonWithTitle:@"跟买"
               andNormaltextcolor:@"F89324"
         andHightlightedTextColor:Color_White];
  [self.buyButton setNormalBGColor:[Globle colorFromHexRGB:Color_White]];
  [self.buyButton setHighlightBGColor:[Globle colorFromHexRGB:@"d57e1f"]];

  __weak ExpertCell *weakSelf = self;
  [self.buyButton setOnButtonPressedHandler:^{
    ExpertCell *strongSelf = weakSelf;
    if (strongSelf) {
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        [strongSelf showFollowBuyPage];
      }];
    }
  }];

  /** 挑战个股行情 */
  [self.quotationButton setOnButtonPressedHandler:^{
    ExpertCell *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf jumpQuotationButton];
    }
  }];
}

/** 挑战行情 */
- (void)jumpQuotationButton {
  NSLog(@"将会挑战到行情页面");
  [TrendViewController showDetailWithStockCode:self.listItem.stockCode
                                 withStockName:self.listItem.stockName
                                 withFirstType:FIRST_TYPE_UNSPEC
                                   withMatchId:@"1"];
}

/** 点击跟买按钮 */
- (void)showFollowBuyPage {
  FollowBuyClientVC *followVC = [[FollowBuyClientVC alloc] initWithStockCode:self.listItem.stockCode
                                                               withStockName:self.listItem.stockName
                                                                   withIsBuy:YES];
  [AppDelegate pushViewControllerFromRight:followVC];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

#pragma mark-- 绑定数据
- (void)bindData:(ConcludesListItem *)item {

  self.notWorkHeadImage.hidden = YES;
  self.headImageView.hidden = NO;
  self.grossProfitRateLabel.hidden = NO;
  self.coreTextView.hidden = NO;
  self.buyButton.hidden = NO;
  self.nickNameView.hidden = NO;
  self.listItem = item;
  //头像数据绑定
  [_headImageView bindUserListItem:item.writer];

  //总盈利率
  //颜色色值
  UIColor *color = [StockUtil getColorByProfit:item.profitRate];
  //文字长度
  NSString *tempProfit = [NSString stringWithFormat:@"%.2f%%", [item.profitRate floatValue] * 100];
  CGSize size = [SimuUtil labelContentSizeWithContent:tempProfit
                                             withFont:Font_Height_20_0
                                             withSize:CGSizeMake(999, _grossProfitRateLabel.height)];
  _grossProfitRateWidth.constant = size.width;
  _grossProfitRateLabel.width = size.width;
  _grossProfitRateLabel.textColor = color;
  _grossProfitRateLabel.text = tempProfit;

  //昵称设定
  _nickNameView.width = WIDTH_OF_SCREEN - size.width - 86;
  [_nickNameView bindUserListItem:item.writer withFont:Font_Height_16_0 withOriginalPoster:NO];

  CGFloat tempCoreHeight =
      [FTCoreTextView heightWithText:item.content width:_coreTextView.width font:Font_Height_14_0];
  self.coreHeight.constant = tempCoreHeight;
  [_coreTextView setTextSize:Font_Height_14_0];
  _coreTextView.text = item.content;
  [_coreTextView fitToSuggestedHeight];
}

- (void)notWorkBindData {
  self.notWorkHeadImage.hidden = NO;
  self.headImageView.hidden = YES;
  self.grossProfitRateLabel.hidden = YES;
  self.coreTextView.hidden = YES;
  self.buyButton.hidden = YES;
  self.nickNameView.hidden = YES;
}

@end
