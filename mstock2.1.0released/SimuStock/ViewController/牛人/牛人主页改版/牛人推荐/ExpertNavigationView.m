//
//  ExpertNavigationView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/9/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExpertNavigationView.h"

@implementation ExpertNavigationView
/** 初始化 */
+ (ExpertNavigationView *)showExpertNavigatView {
  return [[[NSBundle mainBundle] loadNibNamed:@"ExpertNavigationView"
                                        owner:nil
                                      options:nil] lastObject];
}

@end
