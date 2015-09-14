//
//  SimuTouchMoveView.h
//  SimuStock
//
//  Created by Mac on 13-12-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
/*
 *类说明：用手滑动侧滑页面视图
 */
#import <UIKit/UIKit.h>

@protocol SimuTouchMoveViewDelegate <NSObject>

- (void)TouchMoveWidth:(float)width;
- (void)TouchEnd;
- (void)TouchEndNotMove;

@end

@interface SimuTouchMoveView : UIView {
  //是否点击
  BOOL stmv_isPressDown;
  //上次位置
  CGPoint stmv_lastPos;
  //原始位置
  CGPoint stmv_initPos;
}
@property(weak, nonatomic) id<SimuTouchMoveViewDelegate> delegate;

@end
