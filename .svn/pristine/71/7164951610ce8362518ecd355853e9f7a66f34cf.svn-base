//
//  StockPositionSwitchButtonsView.h
//  SimuStock
//
//  Created by Yuemeng on 14/11/4.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**切换按钮回调block，参数： YES：持仓， NO：清仓*/
typedef void (^switchButtonsClickBlock)(BOOL isPosition);

/**股票持仓页面 持仓与清仓切换按钮*/
@interface StockPositionSwitchButtonsView : UIView
/**切换按钮回调block，参数： YES：持仓， NO：清仓*/
@property(copy, nonatomic) switchButtonsClickBlock switchButtonsClickBlock;

/**设置按钮标题*/
- (void)setButtonsTitleWithPositionNumber:(NSString *)positionNumber
                              clearNumber:(NSString *)clearNumber;
/**单独设置持仓按钮标题*/
- (void)setPositonButtonTitle:(NSString *)positionNumber;
/**单独设置清仓按钮标题*/
- (void)setClearPositonButtonTitle:(NSString *)clearNumber;

@end
