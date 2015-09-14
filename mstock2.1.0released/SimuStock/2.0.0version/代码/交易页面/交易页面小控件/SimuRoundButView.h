//
//  simuRoundButView.h
//  SimuStock
//
//  Created by Mac on 14-7-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimuRoundButDelegate <NSObject>

- (void)roundButPressDown:(NSInteger)index;

@end
/*
 *类说明：买入，卖出按钮
 */
@interface SimuRoundButView : UIView {
  //背景颜色
  UIView *srbv_backView;
  // tag标识
  NSInteger srbv_tag;
  //
}
- (id)initWithFrame:(CGRect)frame
          TitleName:(NSString *)title
                Tag:(NSInteger)m_tag;
@property(weak, nonatomic) id<SimuRoundButDelegate> delegate;

@end
