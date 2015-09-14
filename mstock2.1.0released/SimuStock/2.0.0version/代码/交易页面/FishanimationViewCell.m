//
//  FishanimationViewCell.m
//  SimuStock
//
//  Created by Mac on 15/4/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FishanimationViewCell.h"
//#import "animationView.h"
#import "SimuUtil.h"
@implementation FishanimationViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.clipsToBounds = YES;
  // Initialization code
  //  [self StartCreatAnimation];
  //设置动画帧
  _fishImageView.animationImages = @[
    [UIImage imageNamed:@"小鱼01"],
    [UIImage imageNamed:@"小鱼02"],
    [UIImage imageNamed:@"小鱼03"],
    [UIImage imageNamed:@"小鱼04"]
  ];

  //设置动画总时间
  _fishImageView.animationDuration = 1.5;
  //设置重复次数，0表示不重复
  _fishImageView.animationRepeatCount = -1;
  //开始动画
  [_fishImageView startAnimating];
}

- (IBAction)FishanimationButton:(UIButton *)sender {
  if ([[SimuUtil getUserID] isEqualToString:@"-1"]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:WFLogonNotification object:nil];
  }
}

@end
