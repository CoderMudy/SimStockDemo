//
//  GameAdvertisingViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-6-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameAdvertisingData.h"
#import "CycleScrollView.h"
#import "DataArray.h"
#import "SimTopBannerView.h"

/** 比赛广告 */
static const CGFloat competionAdvHeight = 123.7f;
/** 聊股吧广告 */
static const CGFloat stockBarAdvHeight = 123.7f;
/** 开户广告 */
static const CGFloat openAccountAdvHeight = 83.0f;
/** 高级VIP广告 */
static const CGFloat vipAdvHeight = 123.7f;
/** 牛人广告 */
static const CGFloat expertAdvHeight = 123.7f;



/** 图片广告类型 */
typedef NS_ENUM(NSUInteger, AdListType) {
  /** 比赛广告 */
  AdListTypeCompetion = 0,
  /** 聊股吧广告*/
  AdListTypeStockBar = 1,
  /** 开户广告*/
  AdListTypeOpenStockAccount = 2,
  /** 高级VIP专区*/
  AdListTypeAdvanceVIP = 3,
  /** 追踪牛人上方的广告 */
  AdListTypeFollowManster = 4,
};

@protocol GameAdvertisingDelegate <NSObject>
/** 判断有没有广告页 */
- (void)advertisingPageJudgment:(BOOL)AdBool intg:(NSInteger)intg;
@end
@interface GameAdvertisingViewController : UIViewController <SimTopBannerViewDelegate> {
  /** 滚动视图 */
  CycleScrollView *gameScrollView;
  
  /** 存放视图图片 */
  NSMutableArray *viewArray;
  /** 白色底板图 */
  UIView *whiteView;
  /** 广告高度 */
  float advHeight;
  /** 图片广告类型 */
  AdListType adListType;
}
@property(nonatomic, weak) id<GameAdvertisingDelegate> delegate;

/** 数据类 */
@property(strong, nonatomic) DataArray *dataArray;

- (id)initWithAdListType:(AdListType)imageAdListType;

/** 请求图片广告列表数据 */
- (void)requestImageAdvertiseList;
/** 广告显示 */
- (void)bindGameAdvertisingData:(GameAdvertisingData *)adDataList;

@end
