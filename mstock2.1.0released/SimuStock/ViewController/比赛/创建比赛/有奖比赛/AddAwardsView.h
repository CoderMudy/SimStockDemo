//
//  AddAwardsView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomDividingLineView.h"

/** 点击添加奖项block */
typedef void(^AddAwardsBlock)();

@interface AddAwardsView : UIView

@property(copy, nonatomic) AddAwardsBlock addAwardsBlock;
@property (weak, nonatomic) IBOutlet BottomDividingLineView *line;

@end
