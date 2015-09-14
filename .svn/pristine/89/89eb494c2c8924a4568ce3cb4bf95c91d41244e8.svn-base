//
//  NewOnlineViewCell.m
//  SimuStock
//
//  Created by Jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "NewOnlineViewCell.h"
#import "UIButton+Hightlighted.h"
#import "ComposeInterfaceUtil.h"
#import "NetLoadingWaitView.h"

@implementation NewOnlineViewCell

- (void)awakeFromNib {
  //设置cell的子控件
  [self setHeadImageViewStyle];

  // Initialization code
}
//设置cell子控件
- (void)setHeadImageViewStyle {
  //创建头像
  self.headImageView.clipsToBounds = YES;
  self.headImageView.backgroundColor = [Globle colorFromHexRGB:@"87c8f1"];
  self.headImageView.layer.cornerRadius =
      self.headImageView.bounds.size.width / 2.0f;
  self.headImageView.clipsToBounds = YES;

  self.followButton.clipsToBounds = YES;
  self.followButton.layer.cornerRadius = self.followButton.height / 2;
  planItem = [[NewOnlineInfoData alloc] init];

  ///内容根据label大小自动缩小
  self.planName.adjustsFontSizeToFitWidth = YES;
  self.stopLossLineLabel.adjustsFontSizeToFitWidth = YES;
  self.goalProfitLabel.adjustsFontSizeToFitWidth = YES;
  self.serviceCostLabel.adjustsFontSizeToFitWidth = YES;
  self.descUpLabel.adjustsFontSizeToFitWidth = YES;
  self.goalMonthsLabel.adjustsFontSizeToFitWidth = YES;
}

/** 根据状态判断右侧追踪按钮的样式 */
- (void)setFollowButtonStyle:(NSString *)buystatus {
  /// 购买状态 1：已购买 ，0：可购买， 2：售完
  if ([buystatus isEqualToString:@"0"]) {
    self.followButton.userInteractionEnabled = YES;
    [self.followButton buttonWithTitle:@"追踪"
                    andNormaltextcolor:Color_White
              andHightlightedTextColor:Color_White];
    [self.followButton buttonWithNormal:@"F45145"
                   andHightlightedColor:@"#cc473e"];
  } else if ([buystatus isEqualToString:@"1"]) {
    self.followButton.userInteractionEnabled = NO;
    [self.followButton buttonWithNormal:Color_White
                   andHightlightedColor:Color_White];
    [self.followButton buttonWithTitle:@"已购买"
                    andNormaltextcolor:@"#f45145"
              andHightlightedTextColor:@"#f45145"];
    self.followButton.backgroundColor = [UIColor clearColor];
  } else if ([buystatus isEqualToString:@"2"]) {
    self.followButton.userInteractionEnabled = NO;
    [self.followButton buttonWithTitle:@"售罄"
                    andNormaltextcolor:Color_White
              andHightlightedTextColor:Color_White];
    [self.followButton buttonWithNormal:Color_Gray
                   andHightlightedColor:@"#686868"];
  }  
  [self.followButton addTarget:self action:@selector(buttonStatusIsCanBuyPlan) forControlEvents:UIControlEventTouchUpInside];
  
}
///可以购买追踪
- (void)buttonStatusIsCanBuyPlan {
  __weak NewOnlineViewCell *weakSelf = self;
  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) {
        NewOnlineViewCell *strongSelf = weakSelf;
        if (strongSelf) {

          if ([planItem.buystatus isEqualToString:@"0"]) {
            ///判断是否是本人购买本人计划
            if ([planItem.uid isEqualToString:[SimuUtil getUserID]]) {
              [NewShowLabel setMessageContent:@"无法追踪自己计划"];
            } else {
              [strongSelf inquireCurrentBalance];
            }
          } else if ([planItem.buystatus isEqualToString:@"1"]) {
            [NewShowLabel setMessageContent:@"已经购买牛人计划"];
          }
        }
      }];
}
/** 查询账户余额网络接口 */
- (void)inquireCurrentBalance {
    [NetLoadingWaitView startAnimating];
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [NetLoadingWaitView stopAnimating];
    return;
  }
  //服务费
  NSString *moneyCountStr = planItem.price;
  __weak NewOnlineViewCell *weakSelf = self;
  [WFPayUtil masterPlanCheckAccountBalanceWithOwner:self
      andCleanCallBack:^{
        [NetLoadingWaitView stopAnimating];
      }
      andSurePayCallBack:^{
        [weakSelf openTrace];
      }
      andTotalAmountCent:moneyCountStr];
}
- (void)openTrace {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak NewOnlineViewCell *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    NewOnlineViewCell *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    NewOnlineViewCell *strongSelf = weakSelf;
    if (strongSelf) {
      /// 购买成功，发送通知进行刷新
      [[NSNotificationCenter defaultCenter]
          postNotificationName:Notification_Refresh_NewOnlie
                        object:self];
      [NewShowLabel setMessageContent:@"购买牛人计划成功"];
    }
  };
  [NewOnlineInfoItem newOnlinePlanOpenTraceWithAccountId:planItem.accountId
                                           withTargetUid:planItem.uid
                                            withCallback:callback];
}

- (void)bindNewOnlineCellData:(NewOnlineInfoData *)item {
  planItem = item;
  //用户头像
  [self.headImageView bindUserListItem:item.userListItem];
  //设置按钮的状态
  NSString *btnStatus = item.buystatus;
  [self setFollowButtonStyle:btnStatus];
  //计划名称
  self.planName.text = item.name;
  //描述
  self.descUpLabel.text = item.slogan;
  self.descUpLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
  //设置计划期限x
  self.goalMonthsLabel.text =
      [item.goalMonths stringByAppendingString:@"个" @"月"];
  //服务费
  self.serviceCostLabel.text = [@"￥" stringByAppendingString:item.price];
  //目标收益getColorByChangePercent
  NSString *goalProfit = [NSString
      stringWithFormat:@"%.0f%%",
                       [@([item.goalProfit floatValue] * 100) floatValue]];
  self.goalProfitLabel.text = goalProfit;
  self.goalProfitLabel.textColor = [Globle colorFromHexRGB:Color_Red];

  //止损线
  NSString *stopLossLine = [NSString
      stringWithFormat:@"%.0f%%",
                       [@([item.stopLossLine floatValue] * 100) floatValue]];
  self.stopLossLineLabel.text = stopLossLine;
  self.stopLossLineLabel.textColor = [Globle colorFromHexRGB:Color_Green];

  //截止时间（转换成时间格式）
  self.stopTimelabel.text =
      [SimuUtil getFullDateFromCtimeWithMMddHHmm:
                    [NSNumber numberWithFloat:[item.buyStopTime floatValue]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

@end
