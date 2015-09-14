//
//  SliederBuySellView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuleftImagButtonView.h"
#import "simuselMonyeButView.h"
#import "OpeningTimeView.h"
#import "BuySellConstant.h"
#import "SimuTradeBaseData.h"
#import "StockBuySellView.h"
#import "UIButton+Block.h"

/** 按钮点击回调 */
typedef void (^ButtonDownForBuySell)(NSInteger, NSString *, NSString *);

/** 更多资金按钮选择回调block */
typedef void (^MoreFundsButtonDown)(NSInteger, NSString *);

@interface SliederBuySellView
    : UIView <SimuleftButtonDelegate, simuselMonyButDelegate,
              UIAlertViewDelegate>
//买入
/** 资金显示label */
@property(weak, nonatomic) IBOutlet UILabel *showPriceLable;

/** 资金label的靠左约束 */
@property(weak, nonatomic)
    IBOutlet NSLayoutConstraint *showPriceLabelHorizontal;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *showLableWidth;

/** 滑块 */
@property(weak, nonatomic) IBOutlet UISlider *sliderPrice;
/** 添加资金按钮 */
@property(weak, nonatomic) IBOutlet SimuleftImagButtonView *moneyButtonView;
/** 更多资金选择按钮 */
@property(weak, nonatomic) IBOutlet simuselMonyeButView *moneyButtonBuyView;
/** 时间提醒 */
@property(weak, nonatomic) IBOutlet OpeningTimeView *alarmTimeView;
/** 买入 */
@property (weak, nonatomic) IBOutlet BGColorUIButton *buyButton;

//卖出

/** 最小可卖数量 */
@property(weak, nonatomic) IBOutlet UILabel *minSellAmountLabel;
/** 最大可卖数量 */
@property(weak, nonatomic) IBOutlet UILabel *maxSellAmountLabel;
/** 滑块 */
@property(weak, nonatomic) IBOutlet UISlider *sellSlider;
/** 时间空间 */
@property(weak, nonatomic) IBOutlet OpeningTimeView *openingTimeView;
/** 卖出button */
@property (weak, nonatomic) IBOutlet BGColorUIButton *sellButton;

/** 买卖输入框 */
@property(strong, nonatomic) StockBuySellView *buySellTextField;

/** 买卖button的点击回调block */
@property(copy, nonatomic) ButtonDownForBuySell downButtonBuySell;

/** 更多资金按钮选择回调block */
@property(copy, nonatomic) MoreFundsButtonDown moreFoundButton;

/** 记录市价金额 */
@property(assign, nonatomic) NSInteger marketFoundsValue;
/** 记录限价金额 */
@property(assign, nonatomic) NSInteger fixedFoundsValue;

/** 对外初始化方法 区分 买 卖 */
+ (SliederBuySellView *)showSliederBuySellViewWithBuySellType:(BuySellType)type;

/** 给滑块贴图 区分买卖 */
- (void)sliderMapImage:(BuySellType)type;

/** 区分 市价 和 限价 必须实现*/
- (void)marketFixedAssignment:(MarketFixedPriceType)isEnd;

/** 显示不显示添加资金按钮 专门 给牛人设置的 */
- (void)showOrHiddenForMoneyButton:(BOOL)hidden;

/** 给资金显示label赋值 */
- (void)showLabelForMarketFiexd:(MarketFixedPriceType)type;

/** 绑定数据的方法 */
- (void)bindBuySellData:(SimuTradeBaseData *)data
    withSwitchRefreshSliderBool:(BOOL)isEnd;

/** 根据价格的改变来计算资金 或者 数量的改变 来重置滑块 */
- (void)priceOrAmountChangeReSetUpSliderWithPice:(NSString *)price
                                 withBuySellType:(BuySellType)type
                                        withBool:(BOOL)isEnd;

/** 清楚数据的方法 */
- (void)eliminateData;

@end
