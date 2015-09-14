//
//  simuTabSelView.h
//  SimuStock
//
//  Created by Mac on 14-8-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimuTabeSelViewDelegate <NSObject>
/// tab选中
- (void)setSelectedTab:(NSInteger)index;
@end

/*
 *类说明：上方的TabSelector小控件
 *行情 咨询 F10 聊股
 */
@interface SimuTabSelelctorView : UIView {
  //标题内容
  NSMutableArray *_titleArray;
  //当前选中项目
  NSInteger _selectedIndex;
  //动画是否再运行中
  BOOL _animationIsRuning;
}

/** 按钮内容，方便外面取得具体个数从而精确计算滑动块移动 */
@property(nonatomic, strong) NSMutableArray *buttonArray;

/** 按钮下面的蓝色条 */
@property(nonatomic, strong) UIView *blueLineView;

@property(weak, nonatomic) id<SimuTabeSelViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame TitleArray:(NSArray *)array;
- (void)resetTitleArray:(NSArray *)titleArray andIndex:(NSInteger)index;
- (void)resetWidthIndex:(NSInteger)index;
- (void)resetWidthIndexNoCallBack:(NSInteger)index;

@end
