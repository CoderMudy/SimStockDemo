//
//  FloatWindow4KLineView.h
//  SimuStock
//
//  Created by Yuemeng on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

///k线专用浮窗
@interface FloatWindow4KLineView : UIView
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *openPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *closePriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *changePriceLabel;

- (void)setFloatWindowStyle;
@end
