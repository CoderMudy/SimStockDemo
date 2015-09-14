//
//  SimuTabView.h
//  SimuStock
//
//  Created by Mac on 13-8-28.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
@class SimuTabView;

@protocol SimuTabeViewDelegate <NSObject>
// tab修改
- (void)tabChange:(NSInteger)m_index;

@end
/*
 *类说明：交易页面tab控件
 */
#import <UIKit/UIKit.h>

@interface SimuTabView : UIView {
  //按钮在左边的框
  UIImageView *stv_leftBackImageView;
  //按钮在右边的框
  UIImageView *stv_rightBackImageView;
  //按钮右边
  UIImageView *stv_buttonBackImageView;
  //按钮左边
  UIImageView *stv_buttonBackleftImageView;
  //当前展示的tab
  NSInteger stv_corIndexTab;
}
@property(weak, nonatomic) id<SimuTabeViewDelegate> delegate;
@property(assign) NSInteger corIndexTab;

- (void)changTabwithoutAnimation:(NSInteger)index;

@end
