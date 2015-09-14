//
//  SuccessApplicantsInformationView.m
//  SimuStock
//
//  Created by Mac on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SuccessApplicantsInformationView.h"
#import "Globle.h"
@implementation SuccessApplicantsInformationView

//-(id)initWithFrame:(CGRect)frame
//{
//  self=[super initWithFrame:frame];
//  if (self)
//  {
//    self.backgroundColor=[UIColor blueColor];
//    self.imageView.layer.cornerRadius=15;
//  }
//  return self;
//}
- (void)awakeFromNib {
  self.imageView.clipsToBounds = YES;
  [self.imageView.layer setBorderWidth:0.5f];
  [self.imageView.layer
      setBorderColor:[Globle colorFromHexRGB:Color_White].CGColor];
  self.imageView.layer.cornerRadius = 12;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
