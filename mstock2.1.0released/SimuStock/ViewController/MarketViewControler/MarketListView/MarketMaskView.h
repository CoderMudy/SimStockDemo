//
//  MarketMaskView.h
//  SimuStock
//
//  Created by Mac on 13-12-9.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MarketMaskDelegate <NSObject>

-(void)HideMenuView;

@end

/*
 *类说明：我的菜单遮罩视图
 */
@interface MarketMaskView : UIView

@property (weak,nonatomic) id delegete;

@end
