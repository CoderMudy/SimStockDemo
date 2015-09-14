//
//  TraceMessageTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TraceMessageTableViewCell.h"
#import "UIImage+ColorTransformToImage.h"
#import "FollowBuyClientVC.h"
//#import "ExpertPlanViewController.h"
#import "EPPexpertPlanViewController.h"

@implementation TraceMessageTableViewCell {
  TraceMsgData *_traceMsgData;
}

- (void)awakeFromNib {
  [_traceMessageContentCTView setTextColor:[Globle colorFromHexRGB:@"#5a5a5a"]];
}

static const CGFloat heightUserInfo = 64;
+ (int)cellHeightWithMessage:(TraceMsgData *)message
                withMsgWidth:(int)msgWidth
                withFontSize:(float)fontSize {
  CGFloat height = 0;
  CGFloat msgHeight = 0;

  if (message.des && [message.des length] > 0) {
    msgHeight = [FTCoreTextView heightWithText:message.des
                                         width:msgWidth
                                          font:fontSize];
    height = heightUserInfo + msgHeight;
  } else {
    height = heightUserInfo;
  }
  return height;
}

- (void)bindTraceMessage:(TraceMsgData *)traceMsgData {
  [_bottomSpliteView resetViewWidth:WIDTH_OF_SCREEN];
  _traceMsgData = traceMsgData;
  self.msgViewHeight.constant =
      [FTCoreTextView heightWithText:_traceMsgData.des
                               width:self.traceMessageContentCTView.width
                                font:Font_Height_14_0];
  _traceMessageContentCTView.text = traceMsgData.des;
  [_traceMessageContentCTView fitToSuggestedHeight];

  _titleLabel.text = traceMsgData.title;
  _titleLabel.adjustsFontSizeToFitWidth = YES;
  _sourceLabel.text = traceMsgData.source;

  (traceMsgData.source == nil || traceMsgData.source.length == 0)
      ? (_verticalLineView.hidden = YES)
      : (_verticalLineView.hidden = NO);

  _timeLabel.text = traceMsgData.mstrTime;
  UIImage *inviteFriendImage =
      [UIImage imageFromView:_handleBtn
          withBackgroundColor:[Globle colorFromHexRGB:@"#086dae"]];
  [_handleBtn setBackgroundImage:inviteFriendImage
                        forState:UIControlStateHighlighted];
  [_handleBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
  [_handleBtn sizeToFit];
  //跟买按钮
  _handleBtn.layer.cornerRadius = _handleBtn.bounds.size.height / 2;
  [_handleBtn.layer setMasksToBounds:YES];
  _handleBtn.layer.borderWidth = 1.0f;
  _handleBtn.layer.borderColor = [[Globle colorFromHexRGB:@"#086dae"] CGColor];
  _handleBtn.hidden = NO;

  switch ([traceMsgData.subType integerValue]) {
  case STATE_Buy:
    [_handleBtn setTitle:@"买入" forState:UIControlStateNormal];
    break;
  case STATE_Sell:
    [_handleBtn setTitle:@"卖出" forState:UIControlStateNormal];
    break;

  case STATE_MasterPlanBegin:
  case STATE_MasterPlanOver:
    [_handleBtn setTitle:@"查看" forState:UIControlStateNormal];
    break;

  case STATE_MasterPlanRefund:
    [_handleBtn setTitle:@"退款" forState:UIControlStateNormal];
    break;

  case STATE_MasterPlanShelves:
  case STATE_MasterPlanShelvesToUser:
  case STATE_MasterPlanSuccess:
  case STATE_MasterPlanFailed:
    _handleBtn.hidden = YES;
    break;

  default:
    break;
  }
}

- (IBAction)showVC:(UIButton *)sender {
  switch ([_traceMsgData.subType integerValue]) {
  case STATE_Buy: {
    FollowBuyClientVC *followVC =
        [[FollowBuyClientVC alloc] initWithStockCode:_traceMsgData.stockCode
                                       withStockName:_traceMsgData.stockName
                                           withIsBuy:YES];
    [AppDelegate pushViewControllerFromRight:followVC];
  } break;
  case STATE_Sell: {
    FollowBuyClientVC *followVC =
        [[FollowBuyClientVC alloc] initWithStockCode:_traceMsgData.stockCode
                                       withStockName:_traceMsgData.stockName
                                           withIsBuy:NO];
    [AppDelegate pushViewControllerFromRight:followVC];
  }
  //跳转到卖出界面
  break;
  case STATE_MasterPlanBegin:
  case STATE_MasterPlanOver: {
    //跳转到牛人计划首页只需要传一个AccountId
    EPPexpertPlanViewController *vc = [[EPPexpertPlanViewController alloc]
        initAccountId:_traceMsgData.accountId
        withTargetUid:_traceMsgData.superUid
        withTitleName:_traceMsgData.title];
    [AppDelegate pushViewControllerFromRight:vc];
  } break;

  case STATE_MasterPlanRefund: {
    //退款弹出框
    NSString *content = @"申" @"请"
        @"退款后，购买牛人计划所缴纳的款项将全部被退还"
        @"至优顾" @"账户中，是否申请退款？";
    [self alertShow:content];
  } break;
  default:
    break;
  }
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    //退款下单
    [self doRefundRequest];
  }
}

///作退款请求
- (void)doRefundRequest {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  __weak TraceMessageTableViewCell *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    [weakSelf resetHandleBtnState];
  };

  [TraceMessageList requestRefundWithAccoundId:_traceMsgData.accountId
                              andWithTargetUid:_traceMsgData.superUid
                                  withCallback:callback];
}

//退款成功后退款按钮置灰
- (void)resetHandleBtnState {
  [_handleBtn setTitle:@"退款" forState:UIControlStateNormal];
  [_handleBtn setTitleColor:[Globle colorFromHexRGB:@"#959595"]
                   forState:UIControlStateNormal];
  _handleBtn.layer.borderColor = [[Globle colorFromHexRGB:@"#959595"] CGColor];
  _handleBtn.userInteractionEnabled = NO;
}

- (void)alertShow:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
  [alert show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  self.contentView.backgroundColor =
      [Globle colorFromHexRGB:(selected ? @"#d9ecf2" : Color_BG_Common)
                        alpha:0.85f];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  self.contentView.backgroundColor =
      [Globle colorFromHexRGB:(highlighted ? @"#d9ecf2" : Color_BG_Common)
                        alpha:0.85f];
}

@end
