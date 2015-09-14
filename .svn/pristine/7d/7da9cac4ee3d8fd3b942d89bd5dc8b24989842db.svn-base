//
//  AwardsMatchViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/8/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AwardsSetUpView.h"

@class AddAwardsView;
@class AwardsRankingView;
@class MatchCreateAwardInfo;

/** 不管删除还是 添加 对外提供自身大小的frame */
typedef void (^ForeignProvideFrameBlock)(CGRect);

@interface AwardsMatchViewController : UIViewController
/** 有奖比赛头 */
@property(weak, nonatomic) IBOutlet AwardsSetUpView *awardsSetUpView;

/** 奖品设置 */
@property(weak, nonatomic) IBOutlet AwardsRankingView *awardsRankingView;
/** 奖品设置的 高度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *awardsRankingHeight;

/** 添加奖项 */
@property(weak, nonatomic) IBOutlet AddAwardsView *addAwardsView;
/** 添加奖项的 高度 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *addAwardsHeight;

/** 创建比赛有奖信息 */
@property(strong, nonatomic) MatchCreateAwardInfo *matchAwardInfo;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *baseAwardsHeight;
@property(weak, nonatomic) IBOutlet UIView *baseAwardsView;

@property(copy, nonatomic) AwardsIndicatorStart matchStartIndicatorBlock;
@property(copy, nonatomic) AwardsIndicatorStop matchStopIndicatorBlock;

@property(copy, nonatomic) ForeignProvideFrameBlock foreignProvideFrameBlock;
/** id */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            withFrame:(CGRect)frame;

/** 校验数据源是否正确 */
-(BOOL)checkDataSource;

/** 收键盘 */
-(void)receiveKeyboardWithAwardsVC;


@end
