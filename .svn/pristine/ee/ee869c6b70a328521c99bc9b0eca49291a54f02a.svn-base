//
//  RealTradeSpecialTradeViewController.h
//  SimuStock
//
//  Created by Mac on 14-9-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RealTradeSpecifiedTransaction.h"


/**
 指定交易View
 */
@interface RTSpecialTradeViewHolder : NSObject

/**股东代码 */
@property(nonatomic, strong) UILabel *txtStockHolderCode;

/**股东姓名 */
@property(nonatomic, strong) UILabel *txtStockHolderName;

/**市场类别 */
@property(nonatomic, strong) UILabel *txtMarketType;

/**指定交易 */
@property(nonatomic, strong) BGColorUIButton *btnSpecialTrade;

/**初始化 */
- (instancetype)initWithParentView:(UIView *)parent;

/** 隐藏显示的控件 */
- (void)hideUIs:(BOOL)hidden;

/** 数据绑定 */
- (void)bindSpecifiedTransaction:(RealTradeSpecifiedTransaction *)result;

@end

/**
 指定交易页面
 */
@interface RTSpecialTradeVC : BaseViewController

@property(nonatomic, strong) RTSpecialTradeViewHolder *viewContainer;

@property(nonatomic, strong) UIButton *btnTradeRule;

@end
