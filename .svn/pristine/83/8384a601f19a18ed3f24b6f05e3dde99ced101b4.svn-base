//
//  ExpertOneScreenView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/9/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertOneScreenView.h"
#import "ExpertScreenConditionData.h"
#import "Globle.h"

@implementation ExpertOneScreenView

/** thumb图片的宽 */
static const CGFloat thumbImageWidth = 17.f;
/** thumb图片的高 */
static const CGFloat thumbImageHeight = 28.f;
/** thumb图片中内容与图片边上下左右的间隙 */
static const CGFloat thumbImageGap = 2.f;
/** thumb图片中线的宽度 */
static const CGFloat thumbImageLineWidth = 2.f;

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView =
        [[[UINib nibWithNibName:@"ExpertOneScreenView" bundle:nil] instantiateWithOwner:self
                                                                                options:nil] objectAtIndex:0];
    CGRect newFrame = CGRectMake(0, 0, WIDTH_OF_SCREEN, self.frame.size.height);
    containerView.frame = newFrame;
    [self.slider setThumbImage:[ExpertOneScreenView imageEllipseWithLineColor:[Globle colorFromHexRGB:@"#086DAE"]]
                      forState:UIControlStateNormal];
    [self.slider setThumbImage:[ExpertOneScreenView imageEllipseWithLineColor:[Globle colorFromHexRGB:@"#CACACA"]]
                      forState:UIControlStateDisabled];
    [self.slider setMaximumTrackImage:[[UIImage imageNamed:@"进度条_UP.PNG"] stretchableImageWithLeftCapWidth:3
                                                                                                    topCapHeight:0]
                             forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[[UIImage imageNamed:@"进度条_DOWN.PNG"] stretchableImageWithLeftCapWidth:3
                                                                                                      topCapHeight:0]
                             forState:UIControlStateNormal];
    [self addSubview:containerView];
  }
  return self;
}

- (void)resetWithAConditionInterval:(ESConditionInterval *)aConditionInterval
                   conditionIsFloat:(BOOL)conditionIsFloat {
  if (!aConditionInterval) {
    self.slider.enabled = NO;
    [self.slider setValue:self.slider.minimumValue animated:NO];
    if (conditionIsFloat) {
      /// 如果筛选条件是百分数则要转换
      self.selectedConditionLabel.text =@"0%";
    } else {
      self.selectedConditionLabel.text = @"0";
    }
    self.maxLabel.hidden = YES;
    return;
  }
  self.slider.maximumValue = aConditionInterval.rightInterval;
  self.slider.minimumValue = aConditionInterval.leftInterval;
  [self.slider setValue:aConditionInterval.defaultValue animated:NO];
  self.selectedConditon = @(self.slider.value);
  self.conditionIsFloat = conditionIsFloat;
  if (conditionIsFloat) {
    /// 如果筛选条件是百分数则要转换
    self.selectedConditionLabel.text =
        [NSString stringWithFormat:@"%ld%%", (long)[@(aConditionInterval.defaultValue * 100) integerValue]];
    self.maxLabel.text =
        [NSString stringWithFormat:@"%ld%%", (long)[@(aConditionInterval.rightInterval * 100) integerValue]];
  } else {
    self.selectedConditionLabel.text =
        [NSString stringWithFormat:@"%ld", (long)[@(aConditionInterval.defaultValue) integerValue]];
    self.maxLabel.text =
        [NSString stringWithFormat:@"%ld", (long)[@(aConditionInterval.rightInterval) integerValue]];
  }

  self.maxLabel.hidden = NO;
  self.slider.enabled = YES;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
  if (self.conditionIsFloat) {
    /// 如果筛选条件是百分数则要转换
    self.selectedConditionLabel.text =
        [NSString stringWithFormat:@"%ld%%", (long)[@(sender.value * 100) integerValue]];
  } else {
    self.selectedConditionLabel.text =
        [NSString stringWithFormat:@"%ld", (long)[@(sender.value) integerValue]];
  }
  self.selectedConditon = @(sender.value);
}

/** 绘制Slider的thumb */
+ (UIImage *)imageEllipseWithLineColor:(UIColor *)lineColor {
  UIImage *blueCircle = nil;
  CGFloat canvasWidth = thumbImageWidth + thumbImageGap;
  CGFloat canvasHeight = thumbImageHeight + thumbImageGap;
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(canvasWidth, canvasHeight), NO, 0.0f);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);

  CGContextSetLineWidth(ctx, thumbImageLineWidth);
  CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
  CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor); //线框颜色
  CGFloat drawLineGap = thumbImageGap + thumbImageLineWidth / 2;
  CGFloat radius = canvasWidth / 2 - drawLineGap;
  CGContextMoveToPoint(ctx, drawLineGap, 10.f);
  CGContextAddArcToPoint(ctx, drawLineGap, drawLineGap, 10.f, drawLineGap, radius);
  CGContextAddArcToPoint(ctx, canvasWidth - drawLineGap, drawLineGap, canvasWidth - drawLineGap,
                         canvasHeight - 10.f, radius);
  CGContextAddArcToPoint(ctx, canvasWidth - drawLineGap, canvasHeight - drawLineGap,
                         canvasWidth - 10.f, canvasHeight - drawLineGap, radius);
  CGContextAddArcToPoint(ctx, drawLineGap, canvasHeight - drawLineGap, drawLineGap, canvasHeight - 10.f, radius);
  CGContextClosePath(ctx);
  CGContextDrawPath(ctx, kCGPathFillStroke);

  CGContextRestoreGState(ctx);
  blueCircle = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return blueCircle;
}

@end
