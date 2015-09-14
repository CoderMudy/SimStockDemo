//
//  HomeAtSuperView.m
//  SimuStock
//
//  Created by Jhss on 15/7/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HomeAtSuperView.h"
#import "SpecilObjectViewController.h"
#import "FollowFriendResult.h"
#import "MyAttentionInfo.h"
#import "MasterPurchesViewController.h"
#import "StockTradeList.h"
#import "AttentionEventObserver.h"
#import "SimuConfigConst.h"
#import "NetShoppingMallBaseViewController.h"

@implementation HomeAtSuperView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView =
        [[[UINib nibWithNibName:@"HomeAtSuperView" bundle:nil]
            instantiateWithOwner:self
                         options:nil] objectAtIndex:0];
    CGRect newFrame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}

- (void)awakeFromNib {

  [self setButtonStyle];
  //隐藏菊花
  self.trackIndicatorView.hidden = YES;
  self.attentionIndicatorView.hidden = YES;
}

//设置按钮
- (void)setButtonStyle {
  [self.btnArray
      enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor =
            [[Globle colorFromHexRGB:Color_TRACK_BUTTON_BORDER] CGColor];
        btn.layer.borderWidth = 0.5f;
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        [btn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                  forState:UIControlStateNormal];
        [btn setTitleColor:[Globle colorFromHexRGB:Color_White]
                  forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_but]
                       forState:UIControlStateHighlighted];
      }];

  [self.atBtn addTarget:self
                 action:@selector(clickOnAtFriends)
       forControlEvents:UIControlEventTouchUpInside];
  [self.followBtn addTarget:self
                     action:@selector(clickOnFollowManster)
           forControlEvents:UIControlEventTouchUpInside];
  requesting = NO;
  [self.attentionBtn addTarget:self
                        action:@selector(clickOnAttentionOthers)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)bindHomeAtSuperData:(HomePageTableHeaderData *)tableHeaderData {
  self.tableInfoData = tableHeaderData;
  self.traceFlagInt = tableHeaderData.traceFlagInt;
  [self updateAttentionButton];
  //追踪状态
  [self queryTheUserToTrackTheRelationshipAuserId:tableHeaderData.userInfoData.userid
                                          matchID:tableHeaderData.matchID];
}
- (void)clickOnAtFriends {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  //@Ta发表聊股
  [self.atBtn setTitleColor:[Globle colorFromHexRGB:Color_White]
                   forState:UIControlStateNormal];
  [self.atBtn setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_but]
                        forState:UIControlStateNormal];
  __weak HomeAtSuperView *weakSelf = self;
  [self performBlock:^{
    [weakSelf.atBtn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                         forState:UIControlStateNormal];
    [weakSelf.atBtn setBackgroundImage:[SimuUtil imageFromColor:Color_White]
                              forState:UIControlStateNormal];
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {

          if (self.tableInfoData.userInfoData.nickName != nil) {
            SpecilObjectViewController *specilObjectVC =
                [[SpecilObjectViewController alloc] init];
            [specilObjectVC
                   StartAndName:self.tableInfoData.userInfoData.userListItem
                                    .nickName
                andObjectUserid:[self.tableInfoData.userInfoData.userListItem
                                        .userId stringValue]
                    andCallBack:^(TweetListItem *tweetItemObject){

                    }];
            [AppDelegate pushViewControllerFromRight:specilObjectVC];
          }
        }];

  } withDelaySeconds:0.2f];
}

- (void)clickOnFollowManster {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [self.followBtn setTitleColor:[Globle colorFromHexRGB:Color_White]
                       forState:UIControlStateNormal];
  [self.followBtn setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_but]
                            forState:UIControlStateNormal];
  [self performBlock:^{
    [self.followBtn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                         forState:UIControlStateNormal];
    [self.followBtn setBackgroundImage:[SimuUtil imageFromColor:Color_White]
                              forState:UIControlStateNormal];
    
    
    __weak HomeAtSuperView *weakSelf = self;
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          HomeAtSuperView *strongSelf = weakSelf;
          //已登录
          if (strongSelf.traceFlagInt == -3 || strongSelf.traceFlagInt == -1) {
            //-3 追踪过期 －1 未开通追踪卡
            if ([SimuConfigConst isShowPropsForReview]) {
              [AppDelegate pushViewControllerFromRight:
                               [[NetShoppingMallBaseViewController alloc]
                                   initWithPageType:Mall_Buy_Props]];
            } else {
              [AppDelegate pushViewControllerFromRight:
                               [[MasterPurchesViewController alloc] init]];
            }
          } else if (strongSelf.traceFlagInt == -2) {
            //菊花显示
            self.trackIndicatorView.hidden = NO;
            if (![strongSelf.trackIndicatorView isAnimating]) {
              [strongSelf.trackIndicatorView startAnimating];
              strongSelf.followBtn.titleLabel.layer.opacity = 0.0f;
            }
            //有追踪关系，但未追踪该人
            [strongSelf addTrace:self.tableInfoData.userInfoData.userid
                         matchID:@"1"];
          } else if (self.traceFlagInt == 1) {
            //有追踪关系，并且已经追踪该人
            UIAlertView *alert = [[UIAlertView alloc]
                    initWithTitle:@"温馨提示"
                          message:@"确定要取消追踪该牛人吗？"
                         delegate:self
                cancelButtonTitle:@"继续追踪"
                otherButtonTitles:@"取消追踪", nil];
            alert.tag = 12000;
            [alert show];

          } else if (self.traceFlagInt == 0) {
          } else if (self.traceFlagInt == 1000) {
            //尚未取得页面数据
            UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                           message:@"尚" @"未"
                                           @"取得此人数据，请取得"
                                           @"此人数据后，再追踪TA"
                                          delegate:self
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
            alert.tag = 10;
            [alert show];
          }
        }];
  } withDelaySeconds:0.3f];
}

- (void)clickOnAttentionOthers {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [self.attentionBtn setTitleColor:[Globle colorFromHexRGB:Color_White]
                          forState:UIControlStateNormal];
  [self.attentionBtn setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_but]
                               forState:UIControlStateNormal];
  __weak HomeAtSuperView *weakSelf = self;
  [self performBlock:^{
    [weakSelf.attentionBtn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                                forState:UIControlStateNormal];
    [weakSelf.attentionBtn
        setBackgroundImage:[SimuUtil imageFromColor:Color_White]
                  forState:UIControlStateNormal];
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {
          if (weakSelf.tableInfoData.userInfoData.userid != nil) {
            [weakSelf clickAttentionButton];
          }
        }];
  } withDelaySeconds:0.3f];
}
#pragma mark alertViewdelegate
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 12000) {
    //取消追踪
    if (buttonIndex == 1) {
    //菊花显示
    if (![self.trackIndicatorView isAnimating]) {
      [self.trackIndicatorView startAnimating];
      self.followBtn.titleLabel.layer.opacity = 0.0f;
    }
    [self delTrace:self.tableInfoData.userInfoData.userid matchID:@"1"];
    }
  }
}

//增加追踪
- (void)addTrace:(NSString *)userId matchID:(NSString *)matchID {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HomeAtSuperView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    HomeAtSuperView *strongSelf = weakSelf;
    if (strongSelf) {
      //追踪菊花消失
      if ([self.trackIndicatorView isAnimating]) {
        [self.trackIndicatorView stopAnimating];
        self.trackIndicatorView.hidden = YES;
        self.followBtn.titleLabel.layer.opacity = 1.0f;
      }
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    TracePCInfo *tradeInfo = (TracePCInfo *)obj;
    if (tradeInfo) {
      //追踪成功
      weakSelf.traceFlagInt = 1;
      //刷新按钮 刷到0
      [self.followBtn setTitle:@"已追踪" forState:UIControlStateNormal];
      [NewShowLabel setMessageContent:@"追踪成功"];
      //追踪数量变化，刷新主页
      if ([SimuUtil isLogined]) {
        [AttentionEventObserver postAttentionEvent];
        [[NSNotificationCenter defaultCenter]
            postNotificationName:TraceChangeNotification
                          object:nil];
      }
    }
  };
  [TracePCInfo addTrace:userId matchID:matchID withCallback:callback];
}

//取消追踪
- (void)delTrace:(NSString *)userId matchID:(NSString *)matchID {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HomeAtSuperView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    HomeAtSuperView *strongSelf = weakSelf;
    if (strongSelf) {
      if ([self.trackIndicatorView isAnimating]) {
        [self.trackIndicatorView stopAnimating];
        self.trackIndicatorView.hidden = YES;
         self.followBtn.titleLabel.layer.opacity = 1.0f;
      }
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    TracePCInfo *tradeInfo = (TracePCInfo *)obj;
    if (tradeInfo) {
      //取消追踪成功
      weakSelf.traceFlagInt = -2;
      //刷新按钮 刷到0
      [self.followBtn setTitle:@"追踪Ta" forState:UIControlStateNormal];
      [self.followBtn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                           forState:UIControlStateNormal];
      [NewShowLabel setMessageContent:@"取消追踪成功"];
      //追踪数量变化，刷新主页
      if ([SimuUtil isLogined]) {
        [AttentionEventObserver postCancelAttentionEvent];
        [[NSNotificationCenter defaultCenter]
            postNotificationName:TraceChangeNotification
                          object:nil];
      }
    }
  };
  [TracePCInfo delTrace:userId matchID:matchID withCallback:callback];
}

#pragma mark------点击关注操作------
- (void)clickAttentionButton {
  if (requesting) {
    return;
  }
  //关注了其他用户
  if ([[MyAttentionInfo sharedInstance]
          isAttentionWithUserId:self.tableInfoData.userInfoData.userid]) {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:Notification_FansNum_Reduce
                      object:self];
  } else {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:Notification_FansNum_Add
                      object:self];
  }
  //菊花显示
  self.attentionIndicatorView.hidden = NO;
  if (![self.attentionIndicatorView isAnimating]) {
    [self.attentionIndicatorView startAnimating];
    self.attentionBtn.titleLabel.layer.opacity = 0.0f;
  }
  //取反 例：0
  requesting = YES;
  [self clickAttentionButtonWithSelectedUserID:self.tableInfoData.userInfoData
                                                   .userid];
}
#pragma mark 点击关注
- (void)clickAttentionButtonWithSelectedUserID:(NSString *)selectedUserid {
  NSString *attentionStatus =
      [[MyAttentionInfo sharedInstance]
          isAttentionWithUserId:self.tableInfoData.userInfoData.userid]
          ? @"0"
          : @"1";
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HomeAtSuperView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    HomeAtSuperView *strongSelf = weakSelf;
    if (strongSelf) {
      requesting = NO;
      [strongSelf onFollowOperationFinished];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    HomeAtSuperView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf onFollowOperationFinished:(FollowFriendResult *)obj
                        withAttentionStatus:attentionStatus];
    }
  };
  [FollowFriendResult addCancleFollowWithUid:selectedUserid
                              withFollowFlag:attentionStatus
                                withCallBack:callback];
}
- (void)onFollowOperationFinished:(FollowFriendResult *)result
              withAttentionStatus:(NSString *)attentionStatus {

  //先更新下当前页面数据，再请求网络,回传的数据才刷新
  if ([attentionStatus integerValue] == 1) {
    MyAttentionInfoItem *item = [[MyAttentionInfoItem alloc] init];
    item.userListItem = self.tableInfoData.userInfoData.userListItem;
    [[MyAttentionInfo sharedInstance] addItemToAttentionArray:item];

  } else {
    [[MyAttentionInfo sharedInstance]
        deleteItemFromAttentionArray:
            [NSString stringWithFormat:@"%@",
                                       self.tableInfoData.userInfoData.userid]];
  }
  [self updateAttentionButton];
  [NewShowLabel setMessageContent:result.message];
}
- (void)updateAttentionButton {
  [self.attentionBtn
      setTitle:([[MyAttentionInfo sharedInstance]
                    isAttentionWithUserId:self.tableInfoData.userInfoData
                                              .userid]
                    ? @"已关注"
                    : @"+关注")
      forState:UIControlStateNormal];
}
- (void)onFollowOperationFinished {
  //菊花消失
  if ([self.attentionIndicatorView isAnimating]) {
    [self.attentionIndicatorView stopAnimating];
    self.attentionIndicatorView.hidden = YES;
    self.attentionBtn.titleLabel.layer.opacity = 1.0f;
  }
  [self updateAttentionButton];
}
//延迟方法
- (void)performBlock:(void (^)())block withDelaySeconds:(float)delayInSeconds {
  dispatch_time_t popTime = dispatch_time(
      DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), block);
}

#pragma mark 追踪关系
- (void)queryTheUserToTrackTheRelationshipAuserId:(NSString *)userId
                                          matchID:(NSString *)matchID {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak HomeAtSuperView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    HomeAtSuperView *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };
  
  callback.onSuccess = ^(NSObject *obj) {
    __weak HomeAtSuperView *strongSelf = weakSelf;
    if (strongSelf) {
      TracePCInfo *tradeInfo = (TracePCInfo *)obj;
      if (tradeInfo) {
        self.traceFlagInt = tradeInfo.totolCount;
        
        NSString *trackStatus;
        switch (self.traceFlagInt) {
          case 1: {
            trackStatus = @"已追踪";
          } break;
          case -3: {
            trackStatus = @"续费追踪";
          } break;
            
          default: { trackStatus = @"追踪Ta"; } break;
        }
        
        [strongSelf.followBtn setTitle:trackStatus forState:UIControlStateNormal];
      }
    }
  };
  callback.onFailed = ^() { NSLog(@"onfailed"); };
  callback.onError =
  ^(BaseRequestObject *error, NSException *ex) { NSLog(@"onerror"); };
  [TracePCInfo queryTheUserToTrackTheRelationshipAuserId:userId
                                                 matchID:matchID
                                            withCallback:callback];
}




@end
