//
//  BindSuperManTrace.h
//  SimuStock
//
//  Created by jhss on 14-2-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindSuperManTrace : NSObject <UIAlertViewDelegate>
/** 获得用户ID信息 */
- (void)getUserIDInfo:(NSString *)baiduUid withString:(NSString *)baiduChannel;
/** 绑定账号 */
- (void)userBindSever;

///给后台传送AppleToken
- (void)sendApplePushToken;

@end
