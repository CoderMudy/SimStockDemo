//
//  SquarePageControl.m
//  SimuStock
//
//  Created by Yuemeng on 15/8/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SquarePageControl.h"
#import "SimuUtil.h"

@implementation SquarePageControl
////⭐️
//- (void)updateDots {
//  for (NSInteger i = 0; i < self.subviews.count; i++) {
//    UIView *subView = [self.subviews objectAtIndex:i];
//    if (i == self.currentPage) {
//      subView.width = 5.0f;
//      subView.height = 5.0f;
//      subView.backgroundColor = [UIColor clearColor];
//      subView.layer.cornerRadius = subView.height * 0.5;
//      subView.layer.borderWidth = 0.5;
//      subView.layer.borderColor = [UIColor whiteColor].CGColor;
//      subView.layer.masksToBounds = YES;
//    }
////    }else{
////      subView.width = 3.0f;
////      subView.height = 3.0f;
////      subView.center = CGPointMake(subView.center.x, self.height * 0.5);
////      subView.layer.cornerRadius = subView.width * 0.5;
////      subView.layer.masksToBounds = YES;
////      subView.backgroundColor = [Globle colorFromHexRGB:Color_White alpha:0.2];
////    }
////    subView.width = 11.5f;
////    subView.height = 3.5f;
////    subView.layer.cornerRadius = 0;
////    subView.backgroundColor = (i == self.currentPage)
////                                  ? [Globle colorFromHexRGB:@"00A7E5"]
////                                  : [Globle colorFromHexRGB:@"CBCBCB"];
//    
//    
//  }
//}

//- (void)setCurrentPage:(NSInteger)currentPage {
//  [super setCurrentPage:currentPage];
//  //[self updateDots];
//}

@end
