//
//  Flowers.h
//  SimuStock
//
//  Created by Yuemeng on 15/3/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 用户评级五色花朵🌺 */
@interface Flowers : UIView {
  NSString *_rating;
}

/** 给userGradeWidget使用的小花 */
- (instancetype)initWithRating:(NSString *)rating;
/** 牛人排行榜使用的独立大花 */
- (instancetype)initBigFlowerWithRating:(NSString *)rating
                              withFrame:(CGRect)frame;
/** 清除并重新绘制 */
- (void)resetWithRating:(NSString *)rating;
@end
