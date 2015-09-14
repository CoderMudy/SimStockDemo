//
//  UniversityInformationViewController.h
//  SimuStock
//
//  Created by jhss on 15/8/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuBlockDefine.h"

@class MatchCreateUniversityInfo;
@class SimuMatchUsesData;
@class BottomDividingLineView;

/** 高校信息页面高度计算回调 */
typedef void (^UniverInfoHeightBlock)(NSNumber *, NSNumber *);
@interface UniversityInformationViewController : UIViewController

/**说明按钮*/
@property(weak, nonatomic) IBOutlet UIButton *explanationBtn;
/**高校信息开关按钮*/
@property(weak, nonatomic) IBOutlet UISwitch *universityInfoSwitch;
/**高校名字输入*/
@property(weak, nonatomic) IBOutlet UIButton *universityNameBtn;
/**用途输入*/
@property(weak, nonatomic) IBOutlet UIButton *useBtn;
/** 分割线数组 */
@property(strong, nonatomic) IBOutletCollection(BottomDividingLineView) NSArray *dividLineArray;

/** 比赛模版数据 */
@property(strong, nonatomic) SimuMatchUsesData *matchUseData;

/** 创建比赛高校信息 */
@property(strong, nonatomic) MatchCreateUniversityInfo *matchUniversityInfo;
/** 比赛信息高度回调 */
@property(copy, nonatomic) UniverInfoHeightBlock univerInfoHeightBlock;

/** 开始加载，通知父容器 */
@property(copy, nonatomic) CallBackBlock beginRefreshCallBack;

/** 结束加载，通知父容器 */
@property(copy, nonatomic) CallBackBlock endRefreshCallBack;

/** 高校比赛信息校验函数 */
- (BOOL)checkUnivserInfo;

@end
