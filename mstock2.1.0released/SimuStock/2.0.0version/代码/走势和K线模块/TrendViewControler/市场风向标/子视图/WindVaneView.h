//
//  MarketWindIndicatorView.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  市场风向标
 */
@interface WindVaneView : UIView

///看涨百分比
@property (strong, nonatomic) IBOutlet UILabel *risePercentLabel;
///看跌百分比
@property (strong, nonatomic) IBOutlet UILabel *fallPercentLabel;
///牛和看涨数字
@property (strong, nonatomic) IBOutlet UIButton *riseNumButton;
///熊和看跌数字
@property (strong, nonatomic) IBOutlet UIButton *fallNumButton;
///投涨按钮
@property (strong, nonatomic) IBOutlet UIButton *voteRiseButton;
///投跌按钮
@property (strong, nonatomic) IBOutlet UIButton *voteFallButton;
///涨菊花
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *riseIndicatorView;
///跌菊花
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *fallIndicatorView;

//对外请求网络方法
- (void)requestDataFromNet;

@end
