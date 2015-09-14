//
//  AboutWeIntroductionView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/8/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
@class TopDividingLineView;

@interface AboutWeIntroductionView : UIView<TTTAttributedLabelDelegate>
/** 版本号 */
@property (weak, nonatomic) IBOutlet UILabel *versionNumberLabel;
/** web */
@property (weak, nonatomic) IBOutlet UIWebView *aboutWeWebView;
/** 协议控件 */
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *attributedLabel;
/** 电话点击Button */
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
/** 电话号码 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

/** 对外初始化 */
+(AboutWeIntroductionView *)showAboutWeIntroductionView;

@end
