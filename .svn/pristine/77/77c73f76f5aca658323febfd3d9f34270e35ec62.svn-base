//
//  SimuRTBottomToolBar.h
//  SimuStock
//
//  Created by Mac on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuBottomTrendBarView.h"
#import "FSExtendButtons.h"
#import "PositionData.h"
#import "GetStockFirmPositionData.h"
/**
 *类说明：实盘交易框架内底部工具栏小控件
 */
@interface SimuRTBottomToolBar : UIView<SelsctedButtonWithTagDelegate> {
  //按钮信息数组
  NSMutableArray *sbtb_infoarray;
  //按钮数组
  NSMutableArray *sbtb_buttonarray;
  //当前选中的按钮
  int sbtb_index;
}
@property(weak, nonatomic) id<simuBottomTrendBarViewDelegate> delegate;
@property(nonatomic, strong) PositionResult *posResult;
@property(strong ,nonatomic) WFfirmStockListData *stockListData;
- (id)initWithFrame:(CGRect)frame ContenArray:(NSArray *)array;

/** 也是 指定跳转到 tag 等于多少 的button */
-(void)buttonPressDownWithNum:(NSInteger)num;

/** 指定 选中的button */
- (void)buttonpressdown:(UIButton *)button;

/** 选中button的 状态 */
- (void)resetinterface:(NSInteger)index;

@end
