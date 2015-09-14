//
//  MatchCreateInfoViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuBlockDefine.h"

@class DateTipView;
@class MatchCreateViewController;
@class MatchCreateMatchInfo;
@class BottomDividingLineView;
@class UIPlaceHolderTextView;

@interface MatchCreateMatchInfoVC : UIViewController <UITextViewDelegate> {
  BOOL isMatchStartTime;
}

/** 比赛名称输入框 */
@property(weak, nonatomic) IBOutlet UIPlaceHolderTextView *matchNameTextView;
/** 比赛开始时间选择按钮 */
@property(weak, nonatomic) IBOutlet UIButton *matchStartDateBtn;
/** 比赛结束时间选择按钮 */
@property(weak, nonatomic) IBOutlet UIButton *matchEndDateBtn;
/** 比赛描述输入框 */
@property(weak, nonatomic) IBOutlet UIPlaceHolderTextView *matchDescriptionTextView;
/** 比赛初始资金选择按钮 */
@property(weak, nonatomic) IBOutlet UIButton *initialFundBtn;
/** 比赛邀请码Label */
@property(weak, nonatomic) IBOutlet UILabel *invitationCodeLabel;
/** 比赛邀请码说明Label */
@property(weak, nonatomic) IBOutlet UILabel *invitationCodeInstructionLabel;
/** 邀请码是否打开切换器 */
@property(weak, nonatomic) IBOutlet UISwitch *invitationCodeSwitch;
/** 分割线数组 */
@property(strong, nonatomic) IBOutletCollection(BottomDividingLineView) NSArray *dividLineArray;
/** 比赛简介视图高度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *matchDescriptionViewHeight;

/** 比赛开始结束时间选择器 */
@property(weak, nonatomic) DateTipView *dateTipView;

/** 比赛创建金币数 */
@property(copy, nonatomic) NSString *createFee;

/** 创建比赛比赛信息 */
@property(strong, nonatomic) MatchCreateMatchInfo *matchInfo;

/** 开始加载，通知父容器 */
@property(copy, nonatomic) CallBackBlock beginRefreshCallBack;

/** 结束加载，通知父容器 */
@property(copy, nonatomic) CallBackBlock endRefreshCallBack;

/** 创建比赛比赛信息视图高度改变回调block */
@property(copy, nonatomic) CallBackBlock matchCreateMatchInfoHeightChanged;

/**区分返回的status*/
/**创建比赛*/
/*
 “0000”：请求成功，其他均为请求数据失败。
 “0212”：钻石余额不足，请充值
 “0215”：邀请码过期
 “0218”  扣钻石失败
 “0222”：金币余额不足
 “0223”：扣金币失败
 “1003”：创建人参加比赛失败
 “1001”：系统处理错误
 */
- (void)verificationStatusForCreateMatch:(NSString *)localStatus
                             withMessage:(NSString *)localMessage;

/** 缓存下数据(比赛名称，比赛描述) */
- (void)savePreviousMatchInfoWithMatchName:(NSString *)matchName
                      withMatchDescription:(NSString *)matchDescription;

/** 校验比赛信息 */
- (BOOL)checkMatchInfo;

/** 比赛邀请码获取请求 */
- (void)requestStockMatchInvitationCode;

@end
