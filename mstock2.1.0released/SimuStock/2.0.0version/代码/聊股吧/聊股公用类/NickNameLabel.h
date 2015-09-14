//
//  NickNameLabel.h
//  SimuStock
//
//  Created by Mac on 15-1-23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserListItem.h"

@interface NickNameLabel : UILabel

/** 根据vip设置label的颜色 */
- (void)showVipNickNameLabel:(NSInteger)vipType withNormalColor:(NSString *)colorString;
/** 根据文本内容设置label的frame */
- (void)autoAddjustLabelFrameWithContent:(NSString *)content withFontSize:(float)fontSize;

@end
