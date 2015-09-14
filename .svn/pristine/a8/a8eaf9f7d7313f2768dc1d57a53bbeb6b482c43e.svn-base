//
//  ExpertOneScreenView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/9/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESConditionInterval;

@interface ExpertOneScreenView : UIView

/** 标题Label */
@property(weak, nonatomic) IBOutlet UILabel *tittleLabel;
/** 滚动条最大值Label */
@property(weak, nonatomic) IBOutlet UILabel *maxLabel;
/** 滚动条当前位置对应值Label */
@property(weak, nonatomic) IBOutlet UILabel *selectedConditionLabel;
/** 滚动条Slider */
@property(weak, nonatomic) IBOutlet UISlider *slider;

/** 筛选条件是小数 */
@property(assign, nonatomic) BOOL conditionIsFloat;

/** 当前选中的调条件值 */
@property(strong, nonatomic) NSNumber *selectedConditon;

- (void)resetWithAConditionInterval:(ESConditionInterval *)aConditionInterval
                   conditionIsFloat:(BOOL)conditionIsFloat;

@end
