//
//  SelectMatchInitialFundSingle.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SelectMatchInitialFundSingle.h"
#import "GoldCoinNumData.h"
#import "SimuMatchTemplateData.h"
#import "BaseRequester.h"
#import "SelectMatchInitialFundTipView.h"

@implementation SelectMatchInitialFundSingle

/** 存储唯一实例 */
static SelectMatchInitialFundSingle *_instance;

/** 分配内存时都会调用这个方法. 保证分配内存alloc时都相同 */
+ (id)allocWithZone:(struct _NSZone *)zone {
  /// 调用dispatch_once保证在多线程中也只被实例化一次
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [super allocWithZone:zone];
  });
  return _instance;
}

/** 保证init初始化时都相同 */
+ (instancetype)shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[SelectMatchInitialFundSingle alloc] init];
    _instance.isDataBinded = NO;
    _instance.isTipShown = NO;
  });
  return _instance;
}

/** 保证copy时都相同 */
- (id)copyWithZone:(NSZone *)zone {
  return _instance;
}

/** 弹出比赛初始金额选择框 */
- (void)showSelectTip {
  if (self.isTipShown) {
    NSLog(@"又想重复弹出选择金额了");
    return;
  } else if (self.isDataBinded && self.selectMatchInitialFundBlock) {
    self.isTipShown = YES;
    /// 结束编辑状态，收回键盘
    [self endEdit];
    __weak SelectMatchInitialFundSingle *weakSelf = self;
    [SelectMatchInitialFundTipView showTipWithOwnGoldCoinNum:[self.ownGoldCoin integerValue]
        matchData:self.matchData
        withSelectBlock:^(NSString *selectedTemplateID) {
          SelectMatchInitialFundSingle *strongSelf = weakSelf;
          if (strongSelf && strongSelf.selectMatchInitialFundBlock) {
            strongSelf.templateId = selectedTemplateID;
            strongSelf.selectMatchInitialFundBlock(weakSelf.templateId);
            strongSelf.isTipShown = NO;
          }
        }
        withCancelBlock:^{
          if (weakSelf) {
            weakSelf.isTipShown = NO;
          }
        }];
  } else if (!self.isDataBinded && self.selectMatchInitialFundBlock) {
    [self requestMatchTemplateList];
  }
}

/** 请求比赛模板数据 */
- (void)requestMatchTemplateList {
  if (!self.selectMatchInitialFundBlock) {
    return;
  }

  if (self.beginRefreshCallBack) {
    self.beginRefreshCallBack();
  }
  if (![SimuUtil isExistNetwork]) {
    if (self.endRefreshCallBack) {
      self.endRefreshCallBack();
    }
    [NewShowLabel showNoNetworkTip];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SelectMatchInitialFundSingle *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SelectMatchInitialFundSingle *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.endRefreshCallBack) {
        strongSelf.endRefreshCallBack();
      }
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    SelectMatchInitialFundSingle *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.matchData = (SimuMatchTemplateData *)obj;
      [strongSelf requestGoldCoinNumData];
    }
  };

  [SimuMatchTemplateData requestSimuMatchTemplateDataWithCallback:callback];
}

/** 请求用户金币数 */
- (void)requestGoldCoinNumData {
  if (!self.selectMatchInitialFundBlock) {
    return;
  }

  if (self.beginRefreshCallBack) {
    self.beginRefreshCallBack();
  }
  if (![SimuUtil isExistNetwork]) {
    if (self.endRefreshCallBack) {
      self.endRefreshCallBack();
    }
    [NewShowLabel showNoNetworkTip];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SelectMatchInitialFundSingle *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SelectMatchInitialFundSingle *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.endRefreshCallBack) {
        strongSelf.endRefreshCallBack();
      }
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    SelectMatchInitialFundSingle *strongSelf = weakSelf;
    if (strongSelf) {
      GoldCoinNumData *goldCoinNumData = (GoldCoinNumData *)obj;
      strongSelf.ownGoldCoin = goldCoinNumData.coinBalance;
      strongSelf.isDataBinded = YES;
      [strongSelf showSelectTip];
    }
  };

  [GoldCoinNumData requestGoldCoinNumWithCallback:callback];
}

/** 结束编辑状态，收回键盘 */
- (void)endEdit {
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  [mainWindow endEditing:YES];
}

@end
