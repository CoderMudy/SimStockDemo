//
//  simuCenterTabView.h
//  SimuStock
//
//  Created by Mac on 14-8-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimuCenterTabView;

@protocol SimuCenterTabViewDelegate <NSObject>

- (void)tabSelected:(NSInteger)index;

@end

/*
 *类说明：走势，日线，周线，月线小控件 居中的选择控件
 */
@interface SimuCenterTabView : UIView {
  //消息内容
  NSMutableArray *_array;
  //按钮数组
  NSMutableArray *_buttonArray;
  //当前选中的序列号码
  NSInteger _index;
}

@property(strong, nonatomic) NSMutableArray *buttonArray;

@property(weak, nonatomic) id<SimuCenterTabViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array;
//控制哪个按钮按下
- (void)buttonSelected:(NSInteger)index;
//重置按钮
- (void)resetButtons:(NSArray *)array;

/** 重新设置frame */
-(void)reSetUpFrameSimuCenterTableView;

@end
