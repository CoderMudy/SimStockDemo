//
//  MatchCreateConfirmTip.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuBlockDefine.h"

@interface MatchCreateConfirmTip : UIView

/** 信息展示label */
@property(weak, nonatomic) IBOutlet UILabel *showTextLabel;
/** 信息展示label的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showLableHeight;
/** 确认按钮回调 */
@property(copy, nonatomic) CallBackBlock clickSureBtnBlock;
/** 取消按钮回调 */
@property(copy, nonatomic) CallBackBlock clickCancelBtnBlock;

/** 
 弹出提示框
 
 message：弹框内容
 sureBlcok：确认按钮回调
 cancel：取消按钮回调
 */
+ (void)showTipWithMessage:(NSString *)message
             withSureBlock:(CallBackBlock)sureBlock
           withCancelBlock:(CallBackBlock)cancelBlock;

@end
