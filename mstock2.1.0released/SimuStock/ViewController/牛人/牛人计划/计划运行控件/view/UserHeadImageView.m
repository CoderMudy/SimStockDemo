//
//  UserHeadImageView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UserHeadImageView.h"
#import "Globle.h"
#import "UIImageView+WebCache.h"
#import "ProcessInputData.h"
#import "StockUtil.h"
#import "CPInquireCattleNumData.h"
#import "SendCattleToolTip.h"
#import "CPSendCattleResult.h"
#import "SendCattleButton.h"
#import "UIView+FindUIViewController.h"

#define Default_Send_Num 1

@implementation UserHeadImageView

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (UserHeadImageView *)createHeadImagView {
  NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserHeadImageView" owner:nil options:nil];
  return [array lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView =
        [[[UINib nibWithNibName:@"UserHeadImageView" bundle:nil] instantiateWithOwner:self
                                                                              options:nil] objectAtIndex:0];
    CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}

- (void)awakeFromNib {
  if (_headImageView == nil) {
  }
  //设置头像
  //牛人视角的 已购买框 先隐藏
  _purchasedNumber.hidden = YES;
  //设置头像背景圈
  [self headImageDrawCircle];

  self.sendFlowerButton.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.7f].CGColor;
  [self.sendFlowerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.sendFlowerButton setTitleColor:[UIColor colorWithWhite:1.f alpha:0.5f]
                              forState:UIControlStateHighlighted];
  [self.sendFlowerButton
      setImage:[self image:[UIImage imageNamed:@"小牛头_非彩色.png"] ByApplyingAlpha:0.5f]
      forState:UIControlStateHighlighted];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loginAndRefreshSuccess)
                                               name:Notification_CP_SendCattle_RefreshSuccess
                                             object:nil];
}

- (void)loginAndRefreshSuccess {
  [self sendCattle:self.sendFlowerButton];
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
  self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.height * 0.5;
  self.headImageView.layer.masksToBounds = YES;
}

/** 头像绑定数据 */
- (void)bindUserInfo:(UserHeadData *)userHeade {

  if (userHeade.state == ExpertPerspectiveState) {
    _purchasedNumber.hidden = NO;
    _purchasedNumber.alpha = 0.5;

    _purchasedNumber.text = [NSString stringWithFormat:@"已购买: %ld人", (long)userHeade.purchasedNum];
    _sendFlowerButton.hidden = YES;
  } else {
    _sendFlowerButton.hidden = NO;
    _purchasedNumber.hidden = YES;
  }

  //头像
  NSURL *urlStr = [NSURL URLWithString:userHeade.headImage];
  [_headImageView setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"用"
                                                                              @"户默认头像"]];

  //牛头数
  if (userHeade.receive_cow_num <= 0) {
    self.flowerNumber.text = @"0";
  } else {
    // label的宽度
    self.flowerNumber.text = [ProcessInputData digitalFormatNumber:userHeade.receive_cow_num];
    [SimuUtil widthOfLabel:self.flowerNumber font:Font_Height_10_0];
    if (self.flowerNumber.bounds.size.width < self.flowerHeight.constant) {
      self.flowerNumber.frame = CGRectMake(self.flowerNumber.origin.x, self.flowerNumber.origin.y,
                                           self.flowerHeight.constant, self.flowerNumber.bounds.size.height);
    } else {
      self.flowerHeight.constant = self.flowerNumber.bounds.size.width;
    }
  }

  //名称
  _userName.text = userHeade.nickname;
  //简介
  CGSize size =
      [SimuUtil labelContentSizeWithContent:userHeade.desc
                                   withFont:Font_Height_11_0
                                   withSize:CGSizeMake(self.briefIntroductionOne.bounds.size.width, 9999)];
  self.briefHeight.constant = size.height;
  _briefIntroductionOne.numberOfLines = 0;
  _briefIntroductionOne.text = userHeade.desc;

  //目前收益
  UIColor *color = [StockUtil getColorByFloat:userHeade.lastPlanProfit];
  if (userHeade.sucRate < 0) {
    _previousProfitLabel.textColor = color;
    _previousProfitLabel.text = @"--";
    _historyPlanLable.text = @"--";
    _successPlanLable.text = @"--";
    _successRateLabel.text = @"--";
  } else {

    NSString *string = [NSString stringWithFormat:@"%0.2f%%", userHeade.lastPlanProfit * 100];
    [ProcessInputData attributedTextWithString:string
                                     withColor:color
                                   withUILabel:_previousProfitLabel];
    _historyPlanLable.text = [NSString stringWithFormat:@"%ld", (long)userHeade.closePlans];
    _successPlanLable.text = [NSString stringWithFormat:@"%ld", (long)userHeade.sucPlans];
    //成功率 颜色待定
    NSString *successRate = [NSString stringWithFormat:@"%0.2f%%", userHeade.sucRate * 100];
    UIColor *successRateColor = _successRateLabel.textColor;
    [ProcessInputData attributedTextWithString:successRate
                                     withColor:successRateColor
                                   withUILabel:_successRateLabel];
    _successRateLabel.adjustsFontSizeToFitWidth = YES;
  }
  self.receivedID = [NSString stringWithFormat:@"%ld", (long)userHeade.targetUid];
}

//送牛
- (IBAction)sendCattle:(UIButton *)sender {
  __weak UserHeadImageView *weakSelf = self;
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    if (!isLogined) {
      /// 先刷新再送牛
      [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CP_SendCattle_LoginSuccess
                                                          object:self
                                                        userInfo:nil];
    } else {
      [weakSelf inquireCattleNum];
    }
  }];
}

- (void)refresh {
  [self inquireCattleNum];
}

- (void)inquireCattleNum {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak UserHeadImageView *weakSelf = self;

  callback.onCheckQuitOrStopProgressBar = ^{
    UserHeadImageView *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    CPInquireCattleNumData *cattleNum = (CPInquireCattleNumData *)obj;
    [SendCattleToolTip showTipWithOwnNum:cattleNum.cowNum
        andDefautSendNum:Default_Send_Num
        andOKBlock:^(NSString *sendNum) {
          [weakSelf sendCattleWithNum:sendNum];
        }
        andCancleBlock:^{
        }
        andBuySuccessBlock:^{
          UIViewController *vc = [weakSelf firstAvailableUIViewController];
          [vc.navigationController popViewControllerAnimated:NO];
          [weakSelf sendCattle:weakSelf.sendFlowerButton];
        }];
  };

  [CPInquireCattleNumRequest requestCPSendCattleWithCallback:callback];
}

- (void)sendCattleWithNum:(NSString *)sendNum {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak UserHeadImageView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    UserHeadImageView *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    UserHeadImageView *strongSelf = weakSelf;
    if (strongSelf) {
      [NewShowLabel setMessageContent:@"送牛成功"];
      NSInteger cattleNum;
      NSString *lastChar =
          [strongSelf.flowerNumber.text substringWithRange:NSMakeRange(strongSelf.flowerNumber.text.length - 1, 1)];
      if ([lastChar isEqualToString:@"万"]) {
        NSString *num =
            [strongSelf.flowerNumber.text substringWithRange:NSMakeRange(0, strongSelf.flowerNumber.text.length - 1)];
        cattleNum = [num floatValue] * 10000;
        cattleNum += [sendNum integerValue];
        strongSelf.flowerNumber.text = [ProcessInputData digitalFormatNumber:cattleNum];
      } else {
        cattleNum = [strongSelf.flowerNumber.text integerValue];
        cattleNum += [sendNum integerValue];
        strongSelf.flowerNumber.text = [ProcessInputData digitalFormatNumber:cattleNum];
      }
      if (strongSelf.sendSuccessBlock) {
        strongSelf.sendSuccessBlock();
      }
    }
  };

  [CPSendCattleRequest requestCPSendCattleWithReceiverId:self.receivedID
                                               andCowNum:sendNum
                                             andCallback:callback];
}

- (UIImage *)image:(UIImage *)srcImage ByApplyingAlpha:(CGFloat)alpha {
  UIGraphicsBeginImageContextWithOptions(srcImage.size, NO, 0.0f);

  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect area = CGRectMake(0, 0, srcImage.size.width, srcImage.size.height);

  CGContextScaleCTM(ctx, 1, -1);
  CGContextTranslateCTM(ctx, 0, -area.size.height);

  CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

  CGContextSetAlpha(ctx, alpha);

  CGContextDrawImage(ctx, area, srcImage.CGImage);

  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  return newImage;
}

@end
