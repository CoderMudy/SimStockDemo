//
//  GameWebViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-6-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SchollWebViewController.h"

/** 链接模块分类 */
typedef NS_ENUM(NSUInteger, AdvUrlModuleType){
  /** 比赛报名 */
  AdvUrlModuleTypeMatchApply = 1,
  
  /** 个人主页_用户交易评级 */
  AdvUrlMOduleTypeTradeEvaluating = 2,
  
  /** 牛人战报 */
  AdvUrlModuleTypeMasterApply = 3,
  
  /** 系统消息 */
  AdvUrlModuleTypeSystemInfo = 4,
  
  /** 开户广告 */
  AdvUrlModuleTypeAccount = 5,
  
  /** 比赛广告图链接 */
  AdvUrlModuleTypeMatchAdv = 6,
  
  /** 首页弹窗图片链接 */
  AdvUrlModuleTypeFirstPage = 7,
  
};

@interface GameWebViewController : SchollWebViewController

@property (nonatomic, assign) AdvUrlModuleType urlType;

/** 显示用户评级报告*/
+(void)showUserGradeReportWithUserId:(NSString*) userid;

@end
