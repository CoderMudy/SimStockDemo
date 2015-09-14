//
//  ExplanationTipView.m
//  SimuStock
//
//  Created by jhss on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExplanationTipView.h"
#import "Globle.h"
#import "SimuUtil.h"

@implementation ExplanationTipView

+ (void)showExplanationTipView {
  ExplanationTipView *tip =
      [[[NSBundle mainBundle] loadNibNamed:@"ExplanationTipView"
                                     owner:nil
                                   options:nil] firstObject];
  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  tip.frame = mainWindow.bounds;
  [mainWindow addSubview:tip];
}
/** 有奖比赛 */
+ (void)showAwardsMatchExplantionTipViewWithMessage:(NSString *)message {
  ExplanationTipView *tip =
      [[[NSBundle mainBundle] loadNibNamed:@"ExplanationTipView"
                                     owner:nil
                                   options:nil] firstObject];
  tip.showTextLabel.text = message;

  UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
  tip.frame = mainWindow.bounds;
  [mainWindow addSubview:tip];
}
- (IBAction)buttonDown:(UIButton *)sender {
  [sender setBackgroundColor:[Globle colorFromHexRGB:Color_Blue_but]];
}

- (IBAction)buttonDownUpOutside:(UIButton *)sender {
  [sender setBackgroundColor:[Globle colorFromHexRGB:Color_TooltipSureButton]];
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
  [sender setBackgroundColor:[Globle colorFromHexRGB:Color_TooltipSureButton]];
  [self removeFromSuperview];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self removeFromSuperview];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize size = [SimuUtil
      labelContentSizeWithContent:self.showTextLabel.text
                         withFont:Font_Height_14_0
                         withSize:CGSizeMake(self.showTextLabel.size.width,
                                             9999)];
  if (size.height > self.showTextLabel.bounds.size.height) {
    self.showLableHeight.constant = size.height;
    self.showTextLabel.height = self.showLableHeight.constant;
  }
}

@end
