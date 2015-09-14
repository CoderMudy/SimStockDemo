//
//  simuCoverageView.m
//  SimuStock
//
//  Created by Mac on 14-9-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuCoverageView.h"

@implementation SimuCoverageView

@synthesize delegate = _delegate;

  //单例化，方便有scrollView触发侧滑
+ (instancetype)sharedCoverageView {
  static SimuCoverageView *coverageView;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    coverageView = [[SimuCoverageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  });
  return coverageView;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint pt = [[touches anyObject] locationInView:self];
  int positionX = pt.x;
  NSLog(@"touch begin pt.x=%d", positionX);
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  int test = 0;
  NSLog(@"touch Move pt.x=%d", test);
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  int test = 2;
  NSLog(@"touch end pt.x=%d", test);
  if (_delegate && [_delegate respondsToSelector:@selector(mouseTouchUp)]) {
    [_delegate mouseTouchUp];
  }
}

@end
