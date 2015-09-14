//
//  ApplyForActualTradingBottomView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"
typedef void (^AgreementButtonClickBlock)(BOOL btnState);//当按钮被点击时，block返回

@interface ApplyActualTradingBottomView : UIView
/** 同意协议按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *haveReadBtn;
/** 协议按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *protocolBtn;
/** 立即支付按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *payBtn;

@property(copy, nonatomic) AgreementButtonClickBlock block;
/** 通过ApplyActualTradingBottomView.xib创建选项视图 */
+ (ApplyActualTradingBottomView *)applyActulTradingBottomView;

@end
