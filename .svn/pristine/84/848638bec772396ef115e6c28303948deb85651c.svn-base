//
//  UserHeadImageView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertPlanData.h"
//计划展示页面的头
@interface UserHeadImageView : UIView
/** 头像 */
@property (weak, nonatomic) IBOutlet UIView *headImageBackgroundCircleView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/** 用户名称 */
@property (weak, nonatomic) IBOutlet UILabel *userName;

/** 用户简介 */
@property (weak, nonatomic) IBOutlet UILabel *briefIntroductionOne;
/** 已购买人数 牛人视角 可见 */
@property (weak, nonatomic) IBOutlet UILabel *purchasedNumber;

/** 花 */
@property (weak, nonatomic) IBOutlet UIImageView *flowerImageView;
/** 送花数目 */
@property (weak, nonatomic) IBOutlet UILabel *flowerNumber;


/** 请教问题 */
@property (weak, nonatomic) IBOutlet UIButton *consultButton;

/** 送花按钮 */
@property (weak, nonatomic) IBOutlet UIButton *sendFlowerButton;

/** 上期收益 */
@property (weak, nonatomic) IBOutlet UILabel *previousProfitLabel;

/** 历史计划 */
@property (weak, nonatomic) IBOutlet UILabel *historyPlanLable;

/** 成功计划 */
@property (weak, nonatomic) IBOutlet UILabel *successPlanLable;

/** 成功率 */
@property (weak, nonatomic) IBOutlet UILabel *successRateLabel;

//对外初始化
+(UserHeadImageView *)createHeadImagView;

/** 重新绑定数据 */
-(void)bindUserInfo:(UserHeadData *)userHeade;

@end
