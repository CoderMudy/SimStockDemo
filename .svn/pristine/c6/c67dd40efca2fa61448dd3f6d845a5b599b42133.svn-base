//
//  realTradeAccountVC.h
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuIndicatorView.h"
#import "BaseViewController.h"
#import "RealTradeFoundView.h"
#import "RTSpecialTradeVC.h"
#import "FSPositionsViewController.h"

@class InfomationDisplayView;

/*
 *类说明：实盘交易账户页面
 */
@interface RealTradeAccountVC : BaseViewController <realTradeFoundViewDelegate> {
  FSPositionsViewController *_ravc_positionView;
}

/** 账户信息 */
@property(nonatomic, strong) RealTradeFoundView *accountInfoView;

/** 创建优顾实盘信息页面 */
@property(nonatomic, strong) InfomationDisplayView *infomationDisplayView;

@property(nonatomic, strong) FSPositionsViewController *ravc_positionView;
;

//配资恒生请求数据用到的参数 四个
/** 恒生账户 */
@property(copy, nonatomic) NSString *hsUserId;
/** 主账号 */
@property(copy, nonatomic) NSString *homsFundAccount;
/** 子账号 */
@property(copy, nonatomic) NSString *homsCombineld;
/** 操作员编码 */
@property(copy, nonatomic) NSString *operatorNo;

//重写init 用来判断 导航条的title 和 显示那个账户信息页面
- (id)initWithFrame:(CGRect)frame
               withNavTitle:(NSString *)title
    withOneViewOrSecondView:(BOOL)firstOrSecond;

@end
