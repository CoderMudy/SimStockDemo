//  test
//  AppDelegate.h
//  SimuStock
//
//  Created by Mac on 13-8-7.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIDownloadCache.h"
#import "FullScreenLogonViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "JHSSViewDelegate.h"
#import "WXApi.h"

#import "BPush.h"

#import "EntranceFunctionsClass.h"
#import "AuthOptionsDelegate.h"
#import "WeiboSDK.h"
#import "SimuMainViewController.h"

#define AD_SYSTEM_VERSION_GREATER_THAN_7                                                           \
  ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] == NSOrderedDescending)

typedef enum {
  BPushAllExpert = 1,                            // 模拟炒股牛人数据推送（群发）
  BPushFinancialSingle = 2,                      // 理财@数据推送(单发)
  BPushTalkingStockNewsCenter = 3,               // 聊股消息中心提醒
  BPushExpertTraceMessage = 4,                   //牛人追踪消息推送
  BPushTongAccountProfitability = 5,             //账户盈利通知
  BPushStrategyPlatformNotice = 6,               //策略平台通知
  BPushStrategyPlatformEarningsAnnouncement = 7, //策略平台盈利通知
  BPushVipTransactionMessageNotification = 8,    // Vip交易消息通知
  BPushSuperVipNotification = 9,                 // 高级VIP消息通知
  BPushSoonerOrLaterTheNewspaper = 11,           //早晚报推送
  BPushTheSystemMessage = 12,                    //系统消息（单发）

  BPushStockPricesEarlyWarning = 21, //股价预警
  BPushMarketTransaction = 22,       //行情异动(智能预警)

  BPushNodePostedWarning = 31,            //结贴警报
  BPushOptimalGuXiaobianPost = 32,        //优顾小编推送帖子
  BPushAssignSomebody = 33,               //@某人
  BPushCommentPush = 34,                  //评论
  BPushRewardsPush = 35,                  //打赏
  BPushAutomaticRewardsFee = 36,          //自动打赏（扣手续费）
  BPushreplyPush = 37,                    //回复
  BPushExcellentFinancialConsulting = 38, //优顾理财理财咨询（优顾小编推送新闻）
  BPushRecommendandpurchaseProducts = 39, //推荐优购产品
  BPushPromotionActivities = 40,          //推广活动
  BPushMasterPlanMessageTrace = 41,       //牛人计划追踪消息
} BPushTypeMNCG;

@class ViewController;

@interface AppDelegate
    : UIResponder <UIApplicationDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, BPushDelegate, WXApiDelegate, UINavigationControllerDelegate> {
  // shareSDK
  enum WXScene _scene;
  //三方分享界面
  JHSSViewDelegate *_jhssViewDelegate;
  //三方授权界面
  AuthOptionsDelegate *_authOptionsDelegate;
  //启动页面展示
  EntranceFunctionsClass *entrance;
  //微信登录请求
  SendAuthReq *req;
  //登录页
  FullScreenLogonViewController *fullLogonVC;
  /*type3推送（@我）*/
  int callMeDataAt;
  /*type3推送（回复）*/
  int callMeDataReply;
  /*type3推送（关注）*/
  int callMeDataAttention;
  /*type3推送（赞）*/
  int callMeDataPraise;
}

@property(nonatomic, strong) UIWindow *window;

- (void)saveContext;

@property(nonatomic, strong) ViewController *viewController;

@property(nonatomic, strong) UINavigationController *transitionController;

@property(strong, nonatomic) NSURLCache *urlCache;
//可选择登录方式的登录页
@property(strong, nonatomic) FullScreenLogonViewController *tempViewController;

//三方分享
@property(readonly, nonatomic) JHSSViewDelegate *jhssViewDelegate;
//三方授权
@property(readonly, nonatomic) AuthOptionsDelegate *authOptionsDelegate;

//是否需要升级（最新版本不需要升级）
@property(assign, nonatomic) BOOL is_needUpData;
//是否正在弹出新窗口
@property(nonatomic) BOOL isPushing;

///推送数据
@property(nonatomic, strong) NSMutableDictionary *app_userinfo;

- (void)createHomePage;
- (void)matchNewIOSSystem;

- (BOOL)isExistNetwork;

+ (NSString *)getNetworkDescription;

/** 启动新的页面，使用从右到左的动画类型*/
+ (void)pushViewControllerFromRight:(UIViewController *)toViewController;

/** 启动新的页面，使用从下到上的动画类型*/
+ (void)pushViewControllerFromBottom:(UIViewController *)toViewController;

/** 启动新的页面，使用指定的动画类型*/
/* + (void)pushViewController:(ADTransitioningViewController *)toViewController
             withAnimation:(ADTransition *)transition;*/

/** 退出页面，自动使用反向的动画类型。例如：从右至左进入，则从左到右退出*/
+ (void)popViewController:(BOOL)animated;

/** 退出页面，向下弹出 */
+ (void)popViewControllerToBottom;

/** 退出页面，退到指定页面*/
+ (void)popToViewController:(UIViewController *)viewController aminited:(BOOL)animated;

/** 退出页面，退到基类*/
+ (void)popToRootViewController:(BOOL)animated;

+ (UIViewController *)topMostController;

+ (NSManagedObjectContext *)getManagedObjectContext;

///重置导航条取消按钮颜色
+ (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController;

@end
