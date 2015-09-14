//
//  FSExtendButtons.h
//  SimuStock
//
//  Created by moulin wang on 15/3/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"
#import "Globle.h"
#import "NewShowLabel.h"
#import "PositionData.h"
#import "TrendViewController.h"
#import "FirmSaleViewController.h"
#import "simuRealTradeVC.h"
#import "FirmSaleBuyOrSellInputView.h"
#import "SimuBottomTrendBarView.h"

#import "GetStockFirmPositionData.h"
#import "DataArray.h"

#import "BlueViewAndArrow.h"

@class PositionResult;
//声明一个协议 用来传值 和 方法选择器
@protocol SelsctedButtonWithTagDelegate <NSObject>
- (void)selectedButtonToTagWithButton:(UIButton *)btn
                    andPositionResult:(NSObject *)positionRes
                       andFirmCapital:(BOOL)firmCapital;
@end

@interface FSExtendButtons : UIImageView {
  /** 蓝色背景框总长度 */
  CGFloat _blueWidth;
  UIButton *_button1; //行情按钮
  UIButton *_button2; //买入按钮
  UIButton *_button3; //卖出按钮
}
@property(nonatomic, weak) id<SelsctedButtonWithTagDelegate> buttonDelegate;

/** 蓝色提示三角图 */
@property(nonatomic, strong) BlueViewAndArrow *blueViewAndArrow;

//证券资料
@property(nonatomic, strong) PositionResult *posRes;
@property(nonatomic, strong) PositionData *positionData;
@property(nonatomic, strong) WFfirmStockListData *stockListData;
@property(nonatomic, strong) DataArray *capitalDataArray;

//判断 Cell在那个界面创建的
@property(nonatomic, copy) NSString *sale;

@property(nonatomic, assign) NSInteger number;
/** 蓝色气泡按钮承载View */
@property(nonatomic, strong) UIImageView *blueView;

/** 缩小消失动画 */
- (void)hideAndScaleSmall;
/** 添加按钮和事件 */
- (UIButton *)buttonMaker:(NSString *)title
                   action:(ButtonPressed)action
             andButtonTag:(int)tag;
/** 重设蓝框和箭头位置 */
- (void)resetBlueViewAndArrowsFrameWithOffsetY:(CGFloat)offsetY;
- (void)showAndScaleLarge;
/** 获取拓展按钮单例，在windows中调用一次 */
+ (FSExtendButtons *)sharedExtendButtons;
/** 点击 后添加一个扩展框 参赛：PositionData 证券资料  rect:Cell
 * 相对于View的位置 num:第几行Cell */
+ (void)showWithTweetListItem:(NSObject *)obj
                      offsetY:(CGRect)rect
                       andNum:(NSInteger)num
                      andSale:(NSString *)sale
                      andBool:(BOOL)firmCapital;

@end
