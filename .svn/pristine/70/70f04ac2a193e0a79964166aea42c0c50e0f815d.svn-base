//
//  CapitalDetailViewCell.m
//  SimuStock
//
//  Created by Mac on 15/4/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CapitalDetailViewCell.h"
#import "WFHistoryFirmOfferViewController.h"
#import "AccountPageViewController.h"
#import "UIImage+colorful.h"
///手机是否绑定过了
///手机绑定界面
#import "ProcessInputData.h"
///基本类
#import "StockUtil.h"
#import "ComposeInterfaceUtil.h"
#import "NetLoadingWaitView.h"

//判断公测账号能否申请配资
#import "CapitalBetaUserList.h"

@implementation CapitalDetailViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.clipsToBounds = YES;
  // Initialization code
  UIColor *color = _FirmApplicationBtn.titleLabel.textColor;
  [_FirmApplicationBtn.layer setBorderColor:color.CGColor];
  [_FirmApplicationBtn.layer setBorderWidth:1.0f];
  _FirmApplicationBtn.layer.cornerRadius = 16;
  _FirmApplicationBtn.clipsToBounds = YES;
  _FirmApplicationBtn.normalBGColor = [UIColor clearColor];
  _FirmApplicationBtn.highlightBGColor =
      [Globle colorFromHexRGB:Color_Blue_butDown];

  [self.FirmApplicationBtn buttonWithTitle:@"申请配资"
                        andNormaltextcolor:Color_Blue_but
                  andHightlightedTextColor:Color_White];
  [_MyAmountBtn
      setBackgroundImage:
          [UIImage imageWithColor:[Globle colorFromHexRGB:Color_Gray_Edge]]
                forState:UIControlStateHighlighted];
  //  [_MyAmountBtn buttonWithNormal:nil andHightlightedColor:Color_Gray_but];

  self.FloatingLabel.textColor = [StockUtil getColorByProfit:@"0"];

  ///总资产
  [self setFontSizeThatFits:self.TotalAssetsLabel];
  ///股票市值
  [self setFontSizeThatFits:self.StockmarketLable];
  ///可用金额
  [self setFontSizeThatFits:self.AmountAvailableLabel];
  ///总保证金
  [self setFontSizeThatFits:self.TotalMarginLabel];
}
- (void)setFontSizeThatFits:(UILabel *)label {
  CGFloat fontSizeThatFits;

  [label.text sizeWithFont:label.font
               minFontSize:12.0 //最小字体
            actualFontSize:&fontSizeThatFits
                  forWidth:label.bounds.size.width
             lineBreakMode:NSLineBreakByWordWrapping];

  label.font = [label.font fontWithSize:fontSizeThatFits];
}

- (IBAction)ClickButton:(UIButton *)sender {
  if (!sender.enabled) {
    return;
  }
  sender.enabled = NO;
  NSInteger index = sender.tag;
  switch (index) {
  case 1000: {
    //跳转到历史交易页面
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          [AppDelegate pushViewControllerFromRight:
                           [[WFHistoryFirmOfferViewController alloc] init]];
          sender.enabled = YES;
        }];

  } break;
  case 1001: {
    if ([CapitalBetaUserList betaUserListName:[SimuUtil getUserID]]) {
      [FullScreenLogonViewController
          checkLoginStatusWithCallBack:^(BOOL isLogined) {
            [self applyWithFunding];
            sender.enabled = YES;
          }];
    } else {
      sender.enabled = YES;
      [NewShowLabel setMessageContent:@"您"
                                      @"非公测指定用户，无法使用此功能"];
    }
  } break;
  case 1002: {
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          [AppDelegate
              pushViewControllerFromRight:
                  [[AccountPageViewController alloc]
                      initWithFrame:CGRectMake(0.f, 0.f, WIDTH_OF_SCREEN,
                                               HEIGHT_OF_SCREEN)]];
          sender.enabled = YES;
        }];
  } break;
  default:
    break;
  }
}

- (void)applyWithFunding {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) {
        [NetLoadingWaitView startAnimating];
        [WFApplyAccountUtil applyAccountWithOwner:self
                                withCleanCallBack:^{
                                  [NetLoadingWaitView stopAnimating];
                                }];
      }];
}

///赋值
- (void)giveWithUIAssignment:(WFCurrentContractList *)object {
  if (object) {
    NSString *profit = [ProcessInputData convertMoneyString:object.totalProfit];
    self.FloatingLabel.textColor = [StockUtil getColorByProfit:profit];
    self.FloatingLabel.text = profit;
    self.TotalAssetsLabel.text =
        [ProcessInputData convertMoneyString:object.totalAsset];
    self.StockmarketLable.text =
        [ProcessInputData convertMoneyString:object.totalMarketValue];
    self.AmountAvailableLabel.text =
        [ProcessInputData convertMoneyString:object.curAmount];
    self.TotalMarginLabel.text =
        [ProcessInputData convertMoneyString:object.cashAmount];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}
@end
