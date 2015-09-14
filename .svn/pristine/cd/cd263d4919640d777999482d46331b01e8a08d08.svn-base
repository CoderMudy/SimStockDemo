//
//  SimuTouchMoveView.m
//  SimuStock
//
//  Created by Mac on 13-12-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuTouchMoveView.h"

@implementation SimuTouchMoveView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    stmv_isPressDown = YES;
    self.backgroundColor = [UIColor clearColor];
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

#pragma mark
#pragma mark 点击消息回调

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  stmv_isPressDown = YES;
  stmv_initPos = stmv_lastPos = [[touches anyObject] locationInView:self];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  stmv_isPressDown = NO;
  CGPoint newPos = [[touches anyObject] locationInView:self];
  float width = newPos.x - stmv_initPos.x;
  if (_delegate) {
    [_delegate TouchMoveWidth:width];
  }
  // self.center=corpos;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (_delegate) {
    if (stmv_isPressDown == NO) {
      //移动了
      [_delegate TouchEnd];
    } else {
      //没有移动
      [_delegate TouchEndNotMove];
    }
  }
}

@end
