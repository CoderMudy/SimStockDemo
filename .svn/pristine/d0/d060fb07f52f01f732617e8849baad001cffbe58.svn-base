//
//  ShareStatic.h
//  SimuStock
//
//  Created by Mac on 15/3/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>



/** 分享模块类型 */
typedef NS_ENUM(NSUInteger, ShareModuleType) {
  /** 交易 */
  ShareModuleTypeTrade = 1,

  /** 主页 */
  ShareModuleTypeHomePage = 2,

  /** 聊股 */
  ShareModuleTypeWeibo = 3,

  /** 行情 */
  ShareModuleTypeMarket = 4,

  /** 比赛邀请 */
  ShareModuleTypeStockMatch = 5,

  /** 静态网页 */
  ShareModuleTypeStaticWap = 6,

  /** 好友邀请 */
  ShareModuleTypeInviteFriends = 7,

  /** 默认登录分享*/
  ShareModuleTypeAuto = 8,

  /** 用户评测 */
  ShareModuleTypeUserEvaluating = 9,
  
  /** 比赛排行 */
  ShareModuleTypeStockMatchRank = 100,
  
  /** 创建比赛 */
  ShareModuleTypeStockMatchCreate = 101,
};

@interface ShareStatic : NSObject

//发送分享成功统计数据给服务端
+ (void)sendShareSuccessToServerWithShareType:(ShareType)type
                                   withModule:(ShareModuleType)module;

@end
