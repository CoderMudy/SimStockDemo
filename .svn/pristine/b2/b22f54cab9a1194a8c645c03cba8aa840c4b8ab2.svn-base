//
//  MyGoldTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyGoldTableViewCell.h"
#import "UIImage+ColorTransformToImage.h"
#import "MyInfoViewController.h"
#import "AccountsViewController.h"
#import "FillInInvitationCodeClientVC.h"
#import "MarketHomeContainerVC.h"
#import "TrendViewController.h"
#import "simuRealTradeVC.h"

@implementation MyGoldTableViewCell {
  TaskListItem *_taskListItem;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)bindTaskListItem:(TaskListItem *)item {
  _taskListItem = item;
  _descriptionLab.text = item.descrip;

  _nameLab.text = item.name;
  _goldNumberLab.text = [NSString stringWithFormat:@"X%@", [@([item.goldNum integerValue]) stringValue]];
  [_taskTextBtn setTitle:item.taskText forState:UIControlStateNormal];
  [_taskTextBtn sizeToFit];

  _taskTextBtn.layer.borderWidth = 1.0f;
  [_taskTextBtn addTarget:self
                   action:@selector(showVC)
         forControlEvents:UIControlEventTouchUpInside];

  switch ([item.taskStatus integerValue]) {

  case STATE_DoTask: {
    if ([item.taskId isEqualToString:TASK_SIGNIN]) {
      [_taskTextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [_taskTextBtn setBackgroundColor:[Globle colorFromHexRGB:@"#50b0f1"]];
      _taskTextBtn.layer.cornerRadius = _taskTextBtn.bounds.size.height / 2;
      [_taskTextBtn.layer setMasksToBounds:YES];
      _taskTextBtn.layer.borderWidth = 0.0f;

    } else {
      [_taskTextBtn setTitleColor:[Globle colorFromHexRGB:@"#29D1FF"]
                         forState:UIControlStateNormal];
      [_taskTextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
      _taskTextBtn.layer.borderColor = [[Globle colorFromHexRGB:@"#29D1FF"] CGColor];
      UIImage *taskBtnBackgroundImage = [UIImage imageFromView:_taskTextBtn
                                           withBackgroundColor:[Globle colorFromHexRGB:@"#29D1FF"]];
      [_taskTextBtn setBackgroundImage:taskBtnBackgroundImage forState:UIControlStateHighlighted];
    }

  } break;

  case STATE_ReceiveGold: {

    [_taskTextBtn setTitleColor:[Globle colorFromHexRGB:@"#ff8686"] forState:UIControlStateNormal];
    [_taskTextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _taskTextBtn.layer.borderColor = [[Globle colorFromHexRGB:@"#ff8686"] CGColor];
    UIImage *taskBtnBackgroundImage = [UIImage imageFromView:_taskTextBtn
                                         withBackgroundColor:[Globle colorFromHexRGB:@"#ff8686"]];
    [_taskTextBtn setBackgroundImage:taskBtnBackgroundImage forState:UIControlStateHighlighted];

  } break;

  case STATE_ToDo:
  case STATE_TodayAlreadyReceived:
  case STATE_AlreadyReceived: {
    if ([item.taskId isEqualToString:TASK_DELETE_BY_ADMIN]) {
      _taskTextBtn.hidden = YES;
      _specialLabel.hidden = NO;
      _specialLabel.text = item.descrip;
      _descriptionLab.hidden = YES;
    }
    [_taskTextBtn setTitleColor:[Globle colorFromHexRGB:@"#959595"] forState:UIControlStateNormal];
    _taskTextBtn.layer.borderColor = [[Globle colorFromHexRGB:@"#959595"] CGColor];
    _taskTextBtn.userInteractionEnabled = NO;
  } break;

  default:
    break;
  }
}

- (void)bindGetGold:(GetGoldWrapper *)getGold {
  [_taskTextBtn setTitle:getGold.taskText forState:UIControlStateNormal];
  [_taskTextBtn sizeToFit];

  _taskTextBtn.layer.borderWidth = 1.0f;
  _taskListItem.taskStatus = getGold.taskStatus;
  _taskListItem.taskText = getGold.taskText;

  switch ([getGold.taskStatus integerValue]) {

  case STATE_DoTask: {
    [_taskTextBtn setTitleColor:[Globle colorFromHexRGB:@"#29D1FF"] forState:UIControlStateNormal];
    [_taskTextBtn setTitleColor:[Globle colorFromHexRGB:@"29D1FF"]
                       forState:UIControlStateHighlighted];
    _taskTextBtn.layer.borderColor = [[Globle colorFromHexRGB:@"#29D1FF"] CGColor];
    UIImage *taskBtnBackgroundImage = [UIImage imageFromView:_taskTextBtn
                                         withBackgroundColor:[Globle colorFromHexRGB:@"#29D1FF"]];
    [_taskTextBtn setBackgroundImage:taskBtnBackgroundImage forState:UIControlStateHighlighted];
  } break;

  case STATE_ReceiveGold: {

    [_taskTextBtn setBackgroundColor:nil];
    _taskTextBtn.layer.cornerRadius = 0.0f;
    [_taskTextBtn setTitleColor:[Globle colorFromHexRGB:@"#ff8686"] forState:UIControlStateNormal];
    _taskTextBtn.layer.borderColor = [[Globle colorFromHexRGB:@"#ff8686"] CGColor];
    UIImage *taskBtnBackgroundImage = [UIImage imageFromView:_taskTextBtn
                                         withBackgroundColor:[Globle colorFromHexRGB:@"#ff8686"]];
    [_taskTextBtn setBackgroundImage:taskBtnBackgroundImage forState:UIControlStateHighlighted];

  } break;

  case STATE_ToDo:
  case STATE_TodayAlreadyReceived:
  case STATE_AlreadyReceived: {
    [_taskTextBtn setTitleColor:[Globle colorFromHexRGB:@"#959595"] forState:UIControlStateNormal];
    _taskTextBtn.layer.borderColor = [[Globle colorFromHexRGB:@"#959595"] CGColor];
    _taskTextBtn.userInteractionEnabled = NO;
  } break;

  default:
    break;
  }
}

///点击作任务按钮跳转到置顶VC
- (void)showVC {
  if ([_taskListItem.taskId isEqualToString:TASK_BUY_SELL] ||
      [_taskListItem.taskId isEqualToString:TASK_SHOW_ENTRUST]) { //模拟交易买或卖，模拟盘晒委托

    if ([_taskListItem.taskStatus integerValue] == STATE_ReceiveGold) {
      [self getGoldRequest];
    } else if ([_taskListItem.taskStatus integerValue] == STATE_DoTask) {
      //跳转首页
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [AppDelegate popToViewController:app.viewController aminited:NO];
        [app.viewController.mainVC moveToMainView];
        [app.viewController.mainVC resetShowChangeView:0];
      }];
    }

  } else if ([_taskListItem.taskId isEqualToString:TASK_INVITE_OTHERS] ||
             [_taskListItem.taskId isEqualToString:TASK_PERSONAL_INFO]) { //完善个人信息
    if ([_taskListItem.taskStatus integerValue] == STATE_ReceiveGold) {
      [self getGoldRequest];
    } else if ([_taskListItem.taskStatus integerValue] == STATE_DoTask) {
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        //跳转个人信息
        [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
          MyInfoViewController *infoVC = [[MyInfoViewController alloc] initWithTaskId:_taskListItem.taskId];
          [AppDelegate pushViewControllerFromRight:infoVC];
        }];
      }];
    }
  } else if ([_taskListItem.taskId isEqualToString:TASK_REAL_BUY_SELL] ||
             [_taskListItem.taskId isEqualToString:TASK_REAL_TRADE_SHOW_OFF]) { //实盘交易买或卖，实盘晒单
    if ([_taskListItem.taskStatus integerValue] == STATE_DoTask) {
      __weak MyGoldTableViewCell *weakSelf = self;
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        if (isLogined) {
          if ([[SimuUtil getStockFirmFlag] isEqualToString:@"1"]) {
            [AccountsViewController checkLogonRealTradeAndDoBlock:^(BOOL logined) {
              [weakSelf openRealTradeMainPage];
            }];
          } else {
            //跳转交易登录
            AccountsViewController *stockBarVC = [[AccountsViewController alloc] initWithPageTitle:@"交易登录"
                                                                                   withCompanyName:nil
                                                                                   onLoginCallBack:NULL];
            [AppDelegate pushViewControllerFromRight:stockBarVC];
          }
        }
      }];
    } else if ([_taskListItem.taskStatus integerValue] == STATE_ReceiveGold) {
      [self getGoldRequest];
    }
  } else if ([_taskListItem.taskId isEqualToString:TASK_TALK_COMMENT] ||
             [_taskListItem.taskId isEqualToString:TASK_SHARE] ||
             [_taskListItem.taskId isEqualToString:TASK_FIRST_SHARE]) { //发聊股及评论聊股，分享，首次分享

    if ([_taskListItem.taskStatus integerValue] == STATE_ReceiveGold) {
      [self getGoldRequest];
    } else if ([_taskListItem.taskStatus integerValue] == STATE_DoTask) {
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        //跳转到聊股吧首页
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [AppDelegate popToViewController:app.viewController aminited:NO];
        [app.viewController.mainVC moveToMainView];
        [app.viewController.mainVC resetShowChangeView:4];
      }];
    }

  } else if ([_taskListItem.taskId isEqualToString:TASK_FIRST_FOCUS]) {
    if ([_taskListItem.taskStatus integerValue] == STATE_ReceiveGold) { //首次关注他人
      [self getGoldRequest];
    } else if ([_taskListItem.taskStatus integerValue] == STATE_DoTask) {
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        //跳转到牛人交易
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [AppDelegate popToViewController:app.viewController aminited:NO];
        [app.viewController.mainVC moveToMainView];
        [app.viewController.mainVC resetShowChangeView:1];
      }];
    }

  } else if ([_taskListItem.taskId isEqualToString:TASK_FIRST_CUSTOM_STOCK] ||
             [_taskListItem.taskId isEqualToString:TASK_FIRST_ALARMED]) { //首次添加自选股
    if ([_taskListItem.taskStatus integerValue] == STATE_ReceiveGold) {
      [self getGoldRequest];
    } else if ([_taskListItem.taskStatus integerValue] == STATE_DoTask) {
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        //跳转到行情主页
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [AppDelegate popToViewController:app.viewController aminited:NO];
        [app.viewController.mainVC moveToMainView];
        [app.viewController.mainVC resetShowChangeView:2];

        //通知跳转到行情自选股页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToMaketHomeContainerVC"
                                                            object:nil];
      }];
    }
  } else if ([_taskListItem.taskId isEqualToString:TASK_REGIST]) { //注册
    [self getGoldRequest];
  } else if ([_taskListItem.taskId isEqualToString:TASK_SIGNIN]) { //签到
    if ([_taskListItem.type integerValue] == TYPE_Registration &&
        [_taskListItem.taskStatus integerValue] != STATE_ReceiveGold) {
      [self doTaskRequest];
    } else {
      [self getGoldRequest];
    }
  } else if ([_taskListItem.taskId isEqualToString:TASK_INVITATION_CODE]) { //邀请好友
    [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
      //跳转交易登录
      FillInInvitationCodeClientVC *stockBarVC = [[FillInInvitationCodeClientVC alloc] init];
      [AppDelegate pushViewControllerFromRight:stockBarVC];
    }];
  } else if ([_taskListItem.taskId isEqualToString:TASK_VOTE]) {
    if ([_taskListItem.taskStatus integerValue] == STATE_ReceiveGold) {
      [self getGoldRequest];
    } else if ([_taskListItem.taskStatus integerValue] == STATE_DoTask) {
      //跳转到上证指数页面
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        [TrendViewController showDetailWithStockCode:@"10000001"
                                       withStockName:@"上证指数"
                                       withFirstType:FIRST_TYPE_INDEX
                                         withMatchId:@"1"];
      }];
    }
  }
}

///直接登录实盘主页
- (void)openRealTradeMainPage {
  //重新记录时间
  [SimuUser setUserFirmLogonSuccessTime:[NSDate timeIntervalSinceReferenceDate]];
  [AppDelegate pushViewControllerFromRight:[[simuRealTradeVC alloc] initWithDictionary:nil]];
  NSLog(@"跳转到实盘交易界面");
}

///做任务请求
- (void)doTaskRequest {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyGoldTableViewCell *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {

    [weakSelf bindGetGold:(GetGoldWrapper *)obj];
  };
  [GetGoldWrapper requestDoTaskWithCallback:callback andTaskId:_taskListItem.taskId];
}

///获取金币请求
- (void)getGoldRequest {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak MyGoldTableViewCell *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    MyGoldTableViewCell *strongSelf = weakSelf;
    if (strongSelf) {
      GetGoldWrapper *response = (GetGoldWrapper *)obj;
      [weakSelf bindGetGold:response];
      weakSelf.buttonClickCallBack(response);
    }
  };
  [GetGoldWrapper requestGetGoldWithCallback:callback andTaskId:_taskListItem.taskId];
}

@end
