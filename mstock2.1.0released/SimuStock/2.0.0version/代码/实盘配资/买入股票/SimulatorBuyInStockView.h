//
//  SimulatorBuyInStockView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/3/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AttributedLable;

@interface SimulatorBuyInStockView : UIView

/** 标题 */
@property(weak, nonatomic) IBOutlet UILabel *titleLable;
/** 模拟买入按钮 */
@property(weak, nonatomic) IBOutlet UIButton *simulatorBuyBtn;

/** 设置按钮的边框圆弧效果 */
- (void)setupButtonLayer;

@end
