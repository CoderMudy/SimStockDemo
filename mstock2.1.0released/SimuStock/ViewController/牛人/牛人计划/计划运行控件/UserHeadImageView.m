//
//  UserHeadImageView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UserHeadImageView.h"

@implementation UserHeadImageView

+ (UserHeadImageView *)createHeadImagView {
  NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserHeadImageView"
                                                 owner:nil
                                               options:nil];
  return [array lastObject];
}

- (void)awakeFromNib {
  //设置头像
  _purchasedNumber.hidden = YES;
  [self headImageDrawCircle];
  self.consultButton.layer.borderColor = [UIColor whiteColor].CGColor;
  self.sendFlowerButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

//设置头像背景圈
- (void)headImageDrawCircle {
  self.headImageBackgroundCircleView.layer.cornerRadius =
      self.headImageBackgroundCircleView.bounds.size.height * 0.5;
  self.headImageBackgroundCircleView.layer.borderWidth = 0.5f;
  self.headImageBackgroundCircleView.layer.borderColor =
      [[Globle colorFromHexRGB:Color_BG_Common alpha:0.5f] CGColor];
  self.headImageBackgroundCircleView.layer.masksToBounds = YES;
  //头像
  self.headImageView.layer.cornerRadius =
      self.headImageView.bounds.size.height * 0.5;
  self.headImageView.layer.masksToBounds = YES;
}

-(void)bindUserInfo:(UserHeadData *)userHeade
{
  if (userHeade.state == 1) {
    _purchasedNumber.hidden = NO;
    _purchasedNumber.text = userHeade.purchasedNum;
  }else{
    _purchasedNumber.hidden = YES;
  }
  
  //头像
  NSURL *urlStr = [NSURL URLWithString:userHeade.headImage];
  [_headImageView
   setImageWithURL:urlStr
   placeholderImage:[UIImage imageNamed:@"用户默认头像"]];

  //名称
  _userName.text = userHeade.name;
  //简介
  _briefIntroductionOne.text = userHeade.desc;

  //目前收益
  _previousProfitLabel.textColor = [StockUtil getColorByFloat:[userHeade.lastPlanProfit floatValue]];
  _previousProfitLabel.text = [ProcessInputData floatingPointNumberIntoPercentage:userHeade.lastPlanProfit];
  
  _historyPlanLable.text = userHeade.closePlans;
  
  _successPlanLable.text = userHeade.sucPlans;
  
  //成功率 颜色待定
  _successRateLabel.text = [ProcessInputData floatingPointNumberIntoPercentage:userHeade.sucRate];
  
}

//没有数据时



@end
