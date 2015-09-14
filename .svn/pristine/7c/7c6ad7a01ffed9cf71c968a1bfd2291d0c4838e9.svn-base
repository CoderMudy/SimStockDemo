//
//  SimuShowDataView.h
//  SimuStock
//
//  Created by Mac on 13-11-20.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NO_NETWORK_MESSAGE @"神啊！快给他来点儿网络吧！"

@interface SimuShowMessageDataView : UIView

{
    //背景图片
    UIImageView * smdv_backImageView;
    //展示标签
    UILabel * smdv_messageLable;
    
}
//背景图片
@property (strong,nonatomic)UIImageView * smdv_backImageView;
//设定展示消息
-(void)setMessageData:(NSString *) message;
-(id)initWithFrameNOImage:(CGRect)frame;
/**
 *显示哭泣的小牛和给定的无网络信息
 */
- (void)showNoNetworkStatusWithMessage:(NSString *)message;
/**
 *显示哭泣的小牛和“神啊！快给他来点儿网络吧！”
 */
- (void)showNoNetworkStatusWithMessage;
//比赛_我参与的（无数据）
- (void)noDataStockMatchWithImageName:(NSString *)imageName withContent:(NSString *)content;
@end
