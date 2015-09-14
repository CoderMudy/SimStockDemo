//
//  CompetitionCycleView.h
//  SimuStock
//
//  Created by moulin wang on 14-5-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimuCompetitionMillionCycleData.h"

@protocol CompetitionCycleViewDelegate <NSObject>
//可实现
@optional
////移除视图
//- (void)removeCompetitionCycleView;
//请求参加参赛扣除钻石
- (void)requestParticipatingDeductionDiamond:(NSInteger)type;
//充值
- (void)rechargeDataRequest;
//立即购买
- (void)buyNowProductId:(NSString *)productId;

//兑换->兑换按钮回调
- (void)diamondExchangeFundsToBuyCards:(NSString *)_productID;
//详情->兑换按钮触发方法
- (void)detailsButtonToTriggerTheConversionMethod;
//兑换->充值按钮回调
- (void)conversionTipRechargeButtonMethod;

@end

/*
 *  钻石购买页面
 */
@interface CompetitionCycleView
    : UIView <UITableViewDataSource, UITableViewDelegate> {
  //参赛周期视图
  UIView *cycleView;
  //提醒参赛视图
  UIView *maskView;
  //钻石不足警告视图
  UIView *warningView;
  //购买钻石视图
  UIView *buyDiamondsView;
  //存储数据
  NSMutableArray *dataArr;
  //判断是参赛周期视图还是购买钻石视图
  NSInteger judge;
  //选中状态
  NSInteger selectRow;
  //参赛钻石数量
  NSInteger diaNumber;
  //参赛钻石卡类型
  NSInteger typeInt;
  //商品编号
  NSString *productId;
  //兑换 主窗体
  UIView *exchangeView;
}
@property(weak, nonatomic) id<CompetitionCycleViewDelegate> delegate;
@property(strong, nonatomic) UIView *cycleView;
@property(strong, nonatomic) UIView *warningView;
@property(strong, nonatomic) UIView *buyDiamondsView;
@property(strong, nonatomic) UIView *exchangeView;
@property(copy, nonatomic) NSString *productId;
//连续点击判断
@property(nonatomic) BOOL evenPointBool;

//参赛周期视图
- (void)competitionCycleView:(SimuCompetitionMillionCycleData *)cycleData
                       title:(NSString *)name;
//钻石不足警告视图
- (void)diamondInadequateWarningsView;
//购买钻石视图
- (void)buyDiamondsView:(NSMutableArray *)arr
       rightButtonColor:(UIColor *)rightcolor;
/*商城弹出框方法
 取消按钮tag=5002（已在程序中写出）
  1.title为“兑换”
  说明:
  右侧按钮名字为“兑换”  tag=5101
  右侧按钮名字为“充值”  tag=5102

  2.title为“详情”
  说明:
  右侧按钮名字为“兑换”  tag=5103
 */
- (void)mallExchangeViewTitle:(NSString *)title
                      message:(NSString *)message
               rightButtonTag:(NSInteger)tag
              rightButtonName:(NSString *)rightName
                WithproductId:(NSString *)_productId;
//钻石不足视图
- (void)diamondInadequateWarningsView:(NSString *)message
                      withButtonTitle:(NSString *)buttonTitle;

@end
