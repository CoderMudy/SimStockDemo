//
//  UserHeadImageView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertPlanData.h"

#define Notification_CP_SendCattle_LoginSuccess                                \
  @"Notification_CP_SendCattle_LoginSuccess"
#define Notification_CP_SendCattle_RefreshSuccess                              \
  @"Notification_CP_SendCattle_RefreshSuccess"

@class SendCattleButton;

typedef void (^SendSuccessCallBack)();

//计划展示页面的头
@interface UserHeadImageView : UIView

@property(weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
/** 头像 */
@property(weak, nonatomic) IBOutlet UIView *headImageBackgroundCircleView;
@property(weak, nonatomic) IBOutlet UIImageView *headImageView;

/** 用户名称 */
@property(weak, nonatomic) IBOutlet UILabel *userName;

/** 用户简介 */
@property(weak, nonatomic) IBOutlet UILabel *briefIntroductionOne;
/** 用户简介高度计算 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *briefHeight;

/** 已购买人数 牛人视角 可见 */
@property(weak, nonatomic) IBOutlet UILabel *purchasedNumber;

/** 牛头 */
@property(weak, nonatomic) IBOutlet UIImageView *flowerImageView;
/** 送牛数目 */
@property(weak, nonatomic) IBOutlet UILabel *flowerNumber;
/** 送牛lable的宽度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *flowerHeight;

/** 送牛按钮 */
@property(weak, nonatomic) IBOutlet SendCattleButton *sendFlowerButton;

/** 上期收益 */
@property(weak, nonatomic) IBOutlet UILabel *previousProfitLabel;

/** 历史计划 */
@property(weak, nonatomic) IBOutlet UILabel *historyPlanLable;

/** 成功计划 */
@property(weak, nonatomic) IBOutlet UILabel *successPlanLable;

/** 成功率 */
@property(weak, nonatomic) IBOutlet UILabel *successRateLabel;

/** 送牛数 */
@property(copy, nonatomic) NSString *sendCowNum;
/** 接受送牛的对象 */
@property(copy, nonatomic) NSString *receivedID;

/** 送牛成功回调 */
@property(copy, nonatomic) SendSuccessCallBack sendSuccessBlock;

//对外初始化
+ (UserHeadImageView *)createHeadImagView;

/** 重新绑定数据 */
- (void)bindUserInfo:(UserHeadData *)userHeade;

- (void)refresh;

@end
