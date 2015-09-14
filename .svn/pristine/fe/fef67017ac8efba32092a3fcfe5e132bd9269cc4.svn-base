//
//  SimuIndicatorView.h
//  SimuStock
//
//  Created by Mac on 14-3-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//
/*
 *类说明：联网指示器
 */
#import <UIKit/UIKit.h>
#import "Globle.h"
#import "UIButton+Block.h"

@protocol SimuIndicatorDelegate <NSObject>
//刷新按钮点击
@optional
- (void)refreshButtonPressDown;

@end


@interface SimuIndicatorView : UIView {
  //指示器
  UIActivityIndicatorView *siv_indicator;


  UIButton *siv_searchButton;
  
  //按钮是否可点击
  BOOL siv_butonIsVisible;
}
@property(weak, nonatomic) id<SimuIndicatorDelegate> delegate;
@property(assign, nonatomic) BOOL butonIsVisible;
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;


@end
