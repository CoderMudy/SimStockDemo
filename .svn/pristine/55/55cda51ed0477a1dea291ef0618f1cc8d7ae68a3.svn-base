//
//  AwardsSetUpView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopDividingLineView.h"
#import "BottomDividingLineView.h"

/** 菊花加载 */
typedef void(^AwardsIndicatorStart)();

/** 菊花停止 */
typedef void(^AwardsIndicatorStop)();

/** 开关开起状态的block */
typedef void (^AwardsSwitchOn)();
/** 开关关闭 状态的block */
typedef void (^AwardsSwitchOff)();

@interface AwardsSetUpView : UIView

/** 疑问button */
@property(weak, nonatomic) IBOutlet UIButton *doubtButton;
/** 开关 */
@property(weak, nonatomic) IBOutlet UISwitch *awardsSwitch;
@property (weak, nonatomic) IBOutlet TopDividingLineView *topLine;
@property (weak, nonatomic) IBOutlet BottomDividingLineView *bottomLine;
@property (weak, nonatomic) IBOutlet BottomDividingLineView *bottomLine2;
/** 底部线距离 左边的 宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHorizontalSpace;

@property(copy, nonatomic) AwardsIndicatorStart startIndicatorBlock;
@property(copy, nonatomic) AwardsIndicatorStop stopIndicatorBlock;

@property(copy, nonatomic) AwardsSwitchOn awardsSwitchOnBlock;
@property(copy, nonatomic) AwardsSwitchOff awardsSwitchOffBlock;

@end
