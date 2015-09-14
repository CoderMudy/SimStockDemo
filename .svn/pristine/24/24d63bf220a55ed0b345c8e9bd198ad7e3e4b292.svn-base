//
//  Warning_boxes.m
//  优顾理财
//
//  Created by moulin wang on 13-10-9.
//  Copyright (c) 2013年 Ling YU. All rights reserved.
//

#import "Warning_boxes.h"

@implementation Warning_boxes

@synthesize image_view, title_alter;
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self start];
  }
  return self;
}
- (id)init {
  self = [super init];
  if (self) {
    // Initialization code
    [self start];
  }
  return self;
}
- (void)start {
  self.hidden = YES;
  CGRect frame = self.frame;
  // self.alpha=0.6;
  self.frame = CGRectMake(WIDTH_OF_SCREEN, frame.size.height / 2 - 40, 100, 50);
  self.backgroundColor =
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
  //先去掉了图片
  // image_view=[[UIImageView alloc]initWithFrame:CGRectMake(50, 5, 50, 50)];
  //[self addSubview:image_view];
  if (title_alter == nil) {
    title_alter = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 100, 16)];
  } else {
    return;
  }
  title_alter.textAlignment = NSTextAlignmentCenter;
  title_alter.textColor = [UIColor whiteColor];
  title_alter.backgroundColor = [UIColor clearColor];
  title_alter.font = [UIFont systemFontOfSize:Font_Height_12_0];
  title_alter.numberOfLines = 1;
  [self addSubview:title_alter];
}

//正在发送 的动画提示
- (void)loading_animation {
  self.center = CGPointMake(270, 240);

  self.hidden = NO;
  [self animationStart];
  // image_view.hidden=YES;
  self.hidden = NO;

  title_alter.text = @"提交中...";
}
//动画效果
- (void)animationStart {
  // self.center=CGPointMake(WIDTH_OF_SCREEN+50, 240);
  CGSize strSize = [self widthForString:title_alter.text fontSize:15];
  CGFloat strLength = strSize.width / 2;
  if (strLength < 50)
    strLength = 50;
  self.hidden = NO;
  // lq 向左偏移24点
  self.frame = CGRectMake(WIDTH_OF_SCREEN, 220, strLength * 2 + 24, 50);
  title_alter.frame = CGRectMake(12, 19, strLength * 2, 12);
  //中心坐标移动
  CGPoint p1 = CGPointMake(WIDTH_OF_SCREEN + strLength + 12, 240);
  CGPoint p2 = CGPointMake(WIDTH_OF_SCREEN - strLength - 12, 240);
  CGPoint p3 = CGPointMake(WIDTH_OF_SCREEN - strLength - 12, 240);
  CGPoint p4 = CGPointMake(WIDTH_OF_SCREEN + strLength + 12, 240);
  NSArray *values =
      @[[NSValue valueWithCGPoint:p1],
          [NSValue valueWithCGPoint:p2],
          [NSValue valueWithCGPoint:p3],
          [NSValue valueWithCGPoint:p4]];
  CAKeyframeAnimation *animation =
      [CAKeyframeAnimation animationWithKeyPath:@"position"];
  [animation setValues:values];
  [animation setDuration:2.8];
  //隐藏的代理函数
  animation.delegate = self;
  //    [animation setAutoreverses:YES];
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [animation setCalculationMode:kCAAnimationLinear];
  [animation
      setKeyTimes:@[[NSNumber numberWithFloat:1.0 / 7.0],
          [NSNumber numberWithFloat:14.0 / 28.0],
          [NSNumber numberWithFloat:24.0 / 28.0],
          @1.0F]];
  //[self animationDidStop:animation finished:YES];
  [self.layer addAnimation:animation forKey:NULL];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (flag) {
    self.hidden = YES;
  } else {
    self.hidden = NO;
  }
}

//计算字符串长度
- (CGSize)widthForString:(NSString *)value
                fontSize:(float)fontSize // andHeight:(float)height
{
  return [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
           constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
               lineBreakMode:NSLineBreakByWordWrapping];
  //此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
}

@end
