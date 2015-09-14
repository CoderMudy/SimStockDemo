//
//  ExpertRecommendViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Block.h"
#import "GameAdvertisingViewController.h"

@interface ExpertRecommendViewController : UIViewController

/** 广告 */
@property(strong, nonatomic) GameAdvertisingViewController *advViewVC;

/**
 *  button 按键的集合数组
 */
@property(strong, nonatomic) IBOutletCollection(BGColorUIButton) NSArray *expertClassificationButtonArray;

/** 广告页面的承载View */
@property(weak, nonatomic) IBOutlet UIView *advertisingView;

/** 无网络或者无数据时 显示的小牛 */
@property(weak, nonatomic) IBOutlet UIImageView *notWorkLittleImageView;

/** 广告 承载View的 高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameAdvHeight;

@end
