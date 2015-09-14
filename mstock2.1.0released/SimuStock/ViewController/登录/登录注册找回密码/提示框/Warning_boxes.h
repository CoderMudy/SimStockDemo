//
//  Warning_boxes.h
//  优顾理财
//
//  Created by moulin wang on 13-10-9.
//  Copyright (c) 2013年 Ling YU. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Warning_boxes : UIView {
  UIImageView *image_view;
  UILabel *title_alter;
}
@property(nonatomic, strong) UIImageView *image_view;
@property(nonatomic, strong) UILabel *title_alter;
//动画效果
- (void)animationStart;
- (void)loading_animation;
@end
