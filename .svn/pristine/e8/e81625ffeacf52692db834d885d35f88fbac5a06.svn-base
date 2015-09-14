//
//  MatchCreatViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimuOpenMatchData.h"

@class MatchCreateMatchInfoVC;
@class UniversityInformationViewController;
@class AwardsMatchViewController;

@interface MatchCreateViewController : BaseViewController <UIScrollViewDelegate>

/** 滚动视图 */
@property(nonatomic, strong) UIScrollView *scrollView;
/** 主视图，放置各个信息视图 */
@property(strong, nonatomic) UIView *mainView;

/** 右上角“创建”按钮 */
@property(strong, nonatomic) UIView *createBtn;

/** 比赛信息视图 */
@property(weak, nonatomic) IBOutlet UIView *matchInfoContainerView;
/** 比赛信息视图控制器 */
@property(strong, nonatomic) MatchCreateMatchInfoVC *matchCreateMatchInfoVC;

/** 高校信息视图 */
@property(weak, nonatomic) IBOutlet UIView *schoolInfoContainerView;
/** 高校信息视图控制器 */
@property(strong, nonatomic) UniversityInformationViewController *universityInformationVC;

/** 奖项信息视图 */
@property(weak, nonatomic) IBOutlet UIView *awardContainerInfoView;

@property(weak, nonatomic) AwardsMatchViewController *awardsVC;

/** 比赛信息视图的高 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *matchInfoViewHeight;
/** 高校信息视图的高 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *schoolInfoViewHeight;
/** 奖项信息视图的高 */
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *awardInfoViewHeight;

@end
