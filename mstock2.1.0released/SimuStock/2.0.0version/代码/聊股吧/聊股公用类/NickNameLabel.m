//
//  NickNameLabel.m
//  SimuStock
//
//  Created by Mac on 15-1-23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "NickNameLabel.h"
#import "Globle.h"

@implementation NickNameLabel

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}

- (void)showVipNickNameLabel:(NSInteger)vipType
             withNormalColor:(NSString *)colorString {
  switch (vipType) {
  case VipUser:
  case SVipUser: {
    self.textColor = [Globle colorFromHexRGB:Color_Red];
  } break;
  case NotVipType:
  case VipUserExpired: {
    self.textColor = [Globle colorFromHexRGB:colorString];
  } break;
  default:
    break;
  }
}

- (void)autoAddjustLabelFrameWithContent:(NSString *)content
                            withFontSize:(float)fontSize {
  self.backgroundColor = [UIColor clearColor];
  self.textAlignment = NSTextAlignmentLeft;
  CGSize contentSize =
      [content sizeWithFont:[UIFont systemFontOfSize:fontSize]];
  CGRect frame = self.frame;
  self.frame = CGRectMake(frame.origin.x, frame.origin.y, contentSize.width,
                          frame.size.height);
}

@end
