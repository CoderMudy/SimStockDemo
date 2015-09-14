//
//  SelectMatchPurposeSingle.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SelectMatchPurposeSingle.h"
#import "SelectMatchTypeTipView.h"
#import "SimuMatchUsesData.h"
#import "NewShowLabel.h"
#import "BaseRequester.h"

@implementation SelectMatchPurposeSingle

/** 存储唯一实例 */
static SelectMatchPurposeSingle *_instance;

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
    _instance = [[SelectMatchPurposeSingle alloc] init];
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
    NSLog(@"又想重复弹出比赛用途选择了");
    return;
  } else if (self.isDataBinded && self.selectMatchPurposeBlock) {
    self.isTipShown = YES;
    /// 结束编辑状态，收回键盘
    [self endEdit];
    __weak SelectMatchPurposeSingle *weakSelf = self;
    [SelectMatchTypeTipView showTipWithMatchUseData:self.matchUseData
        withSelectBlock:^(NSString *matchUse) {
          SelectMatchPurposeSingle *strongSelf = weakSelf;
          if (strongSelf && strongSelf.selectMatchPurposeBlock) {
            strongSelf.matchPurpose = matchUse;
            strongSelf.selectMatchPurposeBlock(weakSelf.matchPurpose);
            strongSelf.isTipShown = NO;
          }
        }
        withCancelBlock:^{
          if (weakSelf) {
            weakSelf.isTipShown = NO;
          }
        }];
  } else if (!self.isDataBinded && self.selectMatchPurposeBlock) {
    [self requestMatchUses];
  }
}

/**请求比赛用途接口*/
- (void)requestMatchUses {
  if (!self.selectMatchPurposeBlock) {
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
  __weak SelectMatchPurposeSingle *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^() {
    SelectMatchPurposeSingle *strongSelf = weakSelf;
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
    weakSelf.matchUseData = (SimuMatchUsesData *)obj;
    weakSelf.isDataBinded = YES;
    [weakSelf showSelectTip];
  };

  [SimuMatchUsesData requestSimuMatchUsesDataWithCallback:callback];
}

/** 结束编辑状态，收回键盘 */
- (void)endEdit {
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  [mainWindow endEditing:YES];
}

@end
