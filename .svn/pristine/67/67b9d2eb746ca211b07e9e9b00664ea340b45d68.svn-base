//
//  simuProgressView.m
//  SimuStock
//
//  Created by Mac on 14-7-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuProgressView.h"
#import "SimuUtil.h"

@implementation SimuProgressView

- (id)initWithFrame:(CGRect)frame
           ColerStr:(NSString *)m_color
        ProgressStr:(NSString *)m_progress {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    //设置颜色
    if (m_color == nil || [m_color length] == 0) {
      spv_color = Color_Gray;
      self.backgroundColor = [UIColor clearColor];
    } else {
      spv_color = m_color;
      self.backgroundColor = [Globle colorFromHexRGB:spv_color];
    }
    //设置进度
    if (m_progress == nil || [m_progress length] == 0) {
      spv_progress = @"0";
    } else {
      spv_progress = m_progress;
    }
    lengthFloat = self.bounds.size.width;
  }
  return self;
}
- (void)resetItemContent:(NSString *)m_color
             ProgressStr:(NSString *)m_progress {
  //设置颜色
  if (m_color == nil || [m_color length] == 0) {
    spv_color = Color_Gray;
  } else {
    spv_color = m_color;
  }
  //设置进度
  if (m_progress == nil || [m_progress length] == 0) {
    spv_progress = @"0";
  } else {
    spv_progress = m_progress;
  }
  NSLog(@"spv_progress:%@", spv_progress);
  //设置北京颜色
  self.backgroundColor = [Globle colorFromHexRGB:spv_color];
  //设置长度
  float m_progrss = [spv_progress floatValue];
  NSLog(@"self.bounds.size.width:%f", self.bounds.size.width);
  if (lengthFloat * (1.0 - m_progrss) <= 7.0) {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            lengthFloat * m_progrss, self.frame.size.height);
  } else {
    self.frame =
        CGRectMake(self.frame.origin.x, self.frame.origin.y,
                   lengthFloat * m_progrss + 7.0, self.frame.size.height);
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
