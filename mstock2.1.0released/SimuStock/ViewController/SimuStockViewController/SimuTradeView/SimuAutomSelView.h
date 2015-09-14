//
//  SimuAutomSelView.h
//  SimuStock
//
//  Created by Mac on 13-8-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimuAutomSelView;

@protocol SimuAutomSelViewDelegate <NSObject>

- (void)automDidSelecte:(SimuAutomSelView *)automView;

@end

/*
 *类说明：数量选择小控件
 */
@interface SimuAutomSelView : UIView {
  //背景
  UIImageView *sasv_backgroundImageView;
  //前景
  UIImageView *sasv_frontImageView;
  //前景图片区域数组
  //   CGRect sasv_frontRectArray[5];
  CGPoint sasv_frontPointArray[5];
  //按钮数组
  NSMutableArray *sasv_buttonArray;
  //当前显示的按钮数量
  NSInteger sasv_corIndex;
  //当前动画是否正在显示
  BOOL sasv_isAnimateRun;
  //代理
  id<SimuAutomSelViewDelegate> __weak sasv_delegate;
}

@property(weak, nonatomic) id delegate;
@property(assign) NSInteger selectIndex;

//按钮前景色移动
- (void)frontMoveToBegin;

@end
