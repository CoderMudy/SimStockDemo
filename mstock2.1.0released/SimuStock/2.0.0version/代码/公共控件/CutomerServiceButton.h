//
//  CutomerServiceButton.h
//  SimuStock
//
//  Created by 刘小龙 on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SimuIndicatorView;
@class SimTopBannerView;

@interface CutomerServiceButton : UIButton
/** init 初始化  hide 是否隐藏菊花 */
- (id)initEstablisthCustomerServiceTelephonetopToolBar:
          (SimTopBannerView *)topToolBar indicatorView:
                                             (SimuIndicatorView *)inicatorView
                                                  hide:(BOOL)hide;

//单利 创建按钮
+ (CutomerServiceButton *)shareDataCenter;
- (void)
establisthCustomerServiceTelephonetopToolBar:(SimTopBannerView *)topToolBar
                               indicatorView:(SimuIndicatorView *)inicatorView
                                        hide:(BOOL)hide;

@end
