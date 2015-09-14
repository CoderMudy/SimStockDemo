//
//  PanicBuyingView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Notification_CP_BuyPlan_LoginSuccess                                   \
  @"Notification_CP_BuyPlan_LoginSuccess"
#define Notification_CP_BuyPlan_RefreshSuccess                                 \
  @"Notification_CP_BuyPlan_RefreshSuccess"
#define Notification_CP_BuyPlanSuccess @"Notification_CP_BuyPlanSuccess"

typedef void (^BuySuccessCallBack)();

@interface PanicBuyingView : UIView
/** 追踪价格 */
@property(weak, nonatomic) IBOutlet UILabel *tractPriceLabel;

/** 可用余额 */
@property(weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;

/** 抢购按钮 */
@property(weak, nonatomic) IBOutlet UIButton *buyBtn;

/** 单击抢购按钮响应函数 */
- (IBAction)clickOnBuyBtn:(UIButton *)sender;

/** 牛人计划ID */
@property(copy, nonatomic) NSString *accountId;
/** 目标用户ID */
@property(copy, nonatomic) NSString *targetUid;

/** 账户余额（单位：分） */
@property(copy, nonatomic) NSString *balanceStr;
/** 购买价格（单位：分） */
@property(copy, nonatomic) NSString *priceStr;

//初始化
+ (PanicBuyingView *)createPanicBuyingView;

///绑定追踪价格 和 按钮状态
- (void)bingDataForPanicBuying:(NSDictionary *)dic;

///绑定账号余额
-(void)bindAccountBalance:(NSInteger)balanc;

@end
