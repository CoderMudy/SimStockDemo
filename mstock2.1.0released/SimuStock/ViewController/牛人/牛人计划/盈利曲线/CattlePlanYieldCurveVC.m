//
//  CattlePlanYieldCurveVC.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CattlePlanYieldCurveVC.h"
#import "CPYieldCurveView.h"
#import "CPYieldCurve.h"

@implementation CattlePlanYieldCurveVC

- (instancetype)initWithPlanId:(NSString *)planID
                  andTargetUID:(NSString *)targetUID
                  andStartDate:(NSString *)startDate {
  self = [super init];
  if (self) {
    self.planID = planID;
    self.targetUID = targetUID;
    self.startDate = startDate;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor redColor];
  self.startDateLabel.text = self.startDate;
  [self inquireYieldCurveData];
}

- (void)refreshData {
  [self inquireYieldCurveData];
}

/// 查询收益曲线数据
- (void)inquireYieldCurveData {
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak CattlePlanYieldCurveVC *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    CattlePlanYieldCurveVC *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.yieldCurveView.yieldCurveData = (CPYieldCurveData *)obj;
      NSString *endDateStr = [SimuUtil
          getDayDateFromCtime:@([strongSelf.yieldCurveView.yieldCurveData
                                      .endDate longLongValue])];
      endDateStr = [endDateStr stringByReplacingOccurrencesOfString:@"-"
                                                         withString:@""];
      strongSelf.endDateLabel.text = endDateStr;
      if (!strongSelf.yieldCurveView.yieldCurveData.isBind) {
        return;
      }
      [strongSelf.yieldCurveView setNeedsDisplay];
      if (self.yieldCurveView.yieldCurveData.isChanged) {
        CGFloat max =
            ceil(strongSelf.yieldCurveView.yieldCurveData.maxOrdinate * 10000) /
            10000;
        strongSelf.highYieldLabel.text =
            [NSString stringWithFormat:@"%.2f%%", max / 2 * 100];
        strongSelf.highestYieldLabel.text =
            [NSString stringWithFormat:@"%.2f%%", max * 100];
        strongSelf.lowYieldLabel.text =
            [NSString stringWithFormat:@"-%.2f%%", max / 2 * 100];
        strongSelf.lowestYieldLabel.text =
            [NSString stringWithFormat:@"-%.2f%%", max * 100];
      }
    }
  };

  /// 屏蔽默认实现，不打印错误信息
  callback.onFailed = ^{
  };

  [CPYieldCurve getCPYieldCurveDataWithPlanID:self.planID
                                 andTargetUID:self.targetUID
                                  andCallback:callback];
}

@end