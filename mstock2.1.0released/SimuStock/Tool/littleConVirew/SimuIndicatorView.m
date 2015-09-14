//
//  SimuIndicatorView.m
//  SimuStock
//
//  Created by Mac on 14-3-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuIndicatorView.h"

@implementation SimuIndicatorView

@synthesize delegate = _delegate;
@synthesize butonIsVisible = siv_butonIsVisible;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    siv_butonIsVisible = YES;
    [self creatViews];
  }
  return self;
}

#pragma mark
#pragma mark------创建控件------------------
- (void)creatViews {
  //指示器
  siv_indicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  CGPoint center =
      CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  siv_indicator.center = center;
  [self addSubview:siv_indicator];
  //按钮
  UIImage *mtvc_centerImage =
      [[UIImage imageNamed:@"导航按钮按下态效果.png"]
          resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  UIButton *searchButton = siv_searchButton =
      [UIButton buttonWithType:UIButtonTypeCustom];
  [searchButton setImage:[UIImage imageNamed:@"刷新小图标"]
                forState:UIControlStateNormal];
  [searchButton setImage:[UIImage imageNamed:@"刷新小图标"]
                forState:UIControlStateHighlighted];
  [searchButton setBackgroundImage:nil forState:UIControlStateNormal];
  [searchButton setBackgroundImage:mtvc_centerImage
                          forState:UIControlStateHighlighted];

  __weak SimuIndicatorView *weakSelf = self;

  ButtonPressed buttonPressed = ^ {
      SimuIndicatorView *strongSelf = weakSelf;
      if (strongSelf) {
        if (strongSelf.delegate &&
            [strongSelf.delegate
                respondsToSelector:@selector(refreshButtonPressDown)]) {
          [strongSelf.delegate refreshButtonPressDown];
        }
      }
  };
  [searchButton setOnButtonPressedHandler:buttonPressed];

  searchButton.frame = CGRectMake(0, 0, 40, self.bounds.size.height);
  searchButton.center = center;
  [self addSubview:searchButton];
}

- (void)setButonIsVisible:(BOOL)butonIsVisible {
  if (siv_searchButton) {
    [siv_searchButton setUserInteractionEnabled:butonIsVisible];
  }
  if (butonIsVisible == NO) {
    siv_searchButton.hidden = YES;
  }
  siv_butonIsVisible = butonIsVisible;
}

#pragma mark
#pragma mark------对外接口------------------
- (void)startAnimating {

  if (siv_indicator == Nil)
    return;
  siv_searchButton.hidden = YES;
  if (![siv_indicator isAnimating]) {
    [siv_indicator startAnimating];
  }
}
- (void)stopAnimating {
  [self performSelector:@selector(stopAnimationForDelay)
             withObject:nil
             afterDelay:0.6];
}
- (void)stopAnimationForDelay {
  if (siv_indicator == Nil)
    return;
  if ([siv_indicator isAnimating]) {
    if (siv_searchButton.userInteractionEnabled) {
      siv_searchButton.hidden = NO;
    } else {
      siv_searchButton.hidden = YES;
    }
    [siv_indicator stopAnimating];
  }
}
- (BOOL)isAnimating {
  return [siv_indicator isAnimating];
}
@end
