//
//  IntroductionCattleView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation IntroductionCattleView

+(IntroductionCattleView *)createIntroductionCattleView
{
  NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"IntroductionCattleView" owner:nil options:nil];
  return [array lastObject];
}

@end
