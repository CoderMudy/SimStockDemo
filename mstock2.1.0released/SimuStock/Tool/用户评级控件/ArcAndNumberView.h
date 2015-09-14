//
//  ArcAndNumberView.h
//  SimuStock
//
//  Created by Yuemeng on 15/3/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 用户交易评级用的画圆弧和数字的动画view */
@interface ArcAndNumberView : UIView
{
  /** 控件名 */
  NSString *_title;
  /** 评级的数字 */
  int _num;
  /** 圆和数字颜色 */
  UIColor *_color;
  /** 评级的数字Label */
  UILabel *_numlabel;
  /** 标题 */
  UILabel *_titleLabel;
  /** 起始数字 */
  int _incrementNum;
}

/** 传入控件名，数值，颜色 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withNum:(NSNumber *)num withColor:(UIColor *)color;

/** 重置信息 */
- (void)resetWithNum:(NSNumber *)num;

@end
