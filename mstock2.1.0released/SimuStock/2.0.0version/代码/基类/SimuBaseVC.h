//
//  SimuBaseVC.h
//  SimuStock
//
//  Created by Mac on 14-9-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimTopBannerView.h"
#import "SimuIndicatorView.h"
/*
 *类说明：所有带toolbar的视图控制器的基类，所有该类VC都需继承该类
 */
@interface SimuBaseVC : UIViewController
{
    //顶部工具栏
     SimTopBannerView * base_topToolBar;
    //顶部联网等待菊花
     SimuIndicatorView * base_indicatorView;
    //可使用的客户区
     UIView * base_clientView;
    //工具栏高度
     float base_topTBarHeight;
}
@property (retain,nonatomic) UIView * clientView;
@property (retain,nonatomic) SimuIndicatorView  *indicatorView;

@end
