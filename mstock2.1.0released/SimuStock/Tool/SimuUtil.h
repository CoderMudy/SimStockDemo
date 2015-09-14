//
//  SimuUtil.h
//  SimuStock
//
//  Created by Mac on 13-8-12.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
/*
 *类说明：常用工具函数
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>
#import "MyInfomationItem.h"
#import "AppDelegate.h"

@class FTCoreTextView;
@class StockFunds;

///游客的用户ID
static NSString *const TouristUserId = @"-1";
static NSString *const CurrentShowedGroupID = @"CurrentShowedGroupID";

@interface DynamicAk : JsonRequestObject

@property(nonatomic, strong) NSNumber *replace;
@property(nonatomic, strong) NSString *ak;

@end

@interface SimuUtil : NSObject

#pragma mark
#pragma mark---------WebView_Agent(带信息)---------
+ (void)WebViewUserAgent:(UIWebView *)webview;
#pragma end

#pragma mark
#pragma mark---------推送开关是否开启---------
+ (BOOL)hasNotificationsEnabled;
#pragma end

+ (NSString *)appid;

/** 获取手机唯一标识符，uuid */
+ (NSString *)getUUID;

/** 获取手机蓝牙地址，并md5加密 */
+ (NSString *)getMacAdressAndMd5;

/** 获取手机别名（用户自自定义手机名称） */
/** +(NSString *) getUserUIDeviceName; */

/** 获取设备名称 */
+ (NSString *)getDevicesName;

/** 获取手机系统版本 */
+ (NSString *)getsystemVersions;

/** 获取手机型号 */
+ (NSString *)getDevicesModel;

/** 获取地方型号  （国际化区域名称） */
+ (NSString *)getLocalDeviceModel;

/** 获取应用程序名称 */
+ (NSString *)getAppName;

/** 得到当前应用程序的版本号 */
+ (NSString *)getAppVersions;

/** 得到当前应用程序的版本号(int 类型) */
+ (int)getAppVersionsWithInt;

/** 得到屏幕分辨率 */
+ (NSString *)getScreenScol;

/** 得到当前的联网方式 */
+ (NSString *)getNetWorkType;

/** 获取当前运营商 */
+ (NSString *)checkCarrier;

/** 有无网络判断 */
+ (BOOL)isExistNetwork;

/**  是否wifi */
+ (BOOL)IsEnableWIFI;

/**  是否3G */
+ (BOOL)IsEnable3G;

/** 获取手机程序是否第一次启动 */
+ (BOOL)isAppFirstStart;
/** 获取当前时间 */
+ (NSString *)getCorTime;

/** 保存登录时间,登录时调用 */
+ (void)setLoginTime;
/** 得到登录时间 */
+ (NSString *)getLoginTime;

/** 得到当前的userid */
+ (NSString *)getUserID;
/** 得到当前的恒生ID */
+ (NSString *)getHsUserID;
+ (NSString *)getUserPassword;

+ (void)setUserPassword:(NSString *)password;

/** 返回当前是否已经登录 */
+ (BOOL)isLogined;

///用户认证姓名
+ (void)setUserCertName:(NSString *)user_certname;
///用户实名认证姓名
+ (NSString *)getUserCertName;
///高校列表版本
+ (NSString *)getMatchUniversionListVersion;

///用户认证身份证
+ (void)setUserCertNo:(NSString *)user_certno;
///用户实名认证身份证号
+ (NSString *)getUserCertNo;

/** 设置当前的userid */
+ (void)setUserID:(NSString *)user_id;
/** 设置当前的恒生ID */
+ (void)setHsUserID:(NSString *)hsUser_id;
///比赛高校列表版本
+ (void)setMatchListVersion:(NSString *)version;

/** 得到当前的会话id */
+ (NSString *)getSesionID;

/** 设置当前的会话id */
+ (void)setSesionID:(NSString *)sesion_id;

/** 得到当前用户昵称 */
+ (NSString *)getUserNickName;
/** 设置当前用户昵称 */
+ (void)setUserNiceName:(NSString *)nick_name;

/** 得到当前用户名称 */
+ (NSString *)getUserName;
/** 设置当前用户名称 */
+ (void)setUserName:(NSString *)username;
/** 获得vip等级 */
+ (NSString *)getUserVipType;
/** 存取vip等级 */
+ (void)setUserVipType:(NSString *)vipType;
/** 获得stockFirmFlag */
+ (NSString *)getStockFirmFlag;
/** 存取stockFirmFlag */
+ (void)setStockFirmFlag:(NSString *)stockFirmFlag;

/** 得到当前用户个人签名 */
+ (NSString *)getUserSignature;
/** 设置当前用户个人签名 */
+ (void)setUserSignature:(NSString *)signature;
/** 设置行情刷新时间 */
+ (void)setMarketRefreshTime:(NSString *)refreshTime;
/** 获得行情刷新时间 */
+ (NSString *)getMarketRefreshTime;

/** 设置当前用户手机 */
+ (void)setUserPhone:(NSString *)phone;

/** 获取当前用户绑定的手机 */
+ (NSString *)getUserPhone;

/** 得到当前用户总资产 */
+ (NSString *)getCorUserFound;
/** 设置当前用户总资产 */
+ (void)setCorUserFound:(NSString *)founds;

/** 得到当前的用户头像 */
+ (NSString *)getUserImageURL;
/** 设置头像 */
+ (void)setUserImageURL:(NSString *)headImageUrl;

/** 得到ak */
+ (NSString *)getAK;

#pragma mark 领取金币任务
//完善个人资料
+ (void)setPersonalInfo:(NSString *)taskId;
//完善个人资料任务ID
+ (NSString *)getPersonalInfo;
/** 首次添加自选股 */
+ (void)setFirstSetAddSelfStock:(NSString *)taskId;
/**获取添加自选股任务ID*/
+ (NSString *)getFirstSetAddSelfStock;
/** 首次设置股价预警 */
+ (void)setFirstSetStockAlarm:(NSString *)taskId;
/** 获取设置股价预警任务ID */
+ (NSString *)getFirstSetStockAlarm;
//首次分享
+ (void)setFirstShare:(NSString *)taskId;
//获取首次分享任务ID
+ (NSString *)getFirstShare;

//首次关注他人
+ (void)setAttentionOthers:(NSString *)taskId;
//获取首次关注他人任务ID
+ (NSString *)getAttentionOthers;

#pragma mark 三方token

+ (void)setBaiduUserId:(NSString *)baiduUserId;

+ (NSString *)getBaiduUserId;

/*
 *功能：int*1000 ，得到四舍五入的小数字符串
 *参数：data 成一1000后的值 count 保留位数
 */
+ (NSString *)formatDecimal:(NSInteger)data
                 ForDeciNum:(NSInteger)count
                    ForSign:(BOOL)msign;

/** 把数字换算成带有亿，万等单位得字符串，并带有两位小数 */
+ (NSString *)change64iNTtoStringWithUnit:(int64_t)inputnum;

/** 得到当前刷新率 */
+ (NSInteger)getCorRefreshTime;
/** 设置当前刷新率 */
+ (BOOL)setCorRefreshTime:(NSString *)refreshTime;

#pragma mark
#pragma mark 历史搜索相关函数
/** 加入搜索纪录 */
+ (BOOL)addSearchHistryStockContent:(NSString *)stockCode;
/** 得到搜索纪录 */
+ (NSString *)getSearchHistryStockContent;

/** 设定搜索 */
+ (BOOL)setSearchHistryStockContent:(NSString *)stockCode;

/** 把nil，或者nsnumber null等转换成字符串 数据解析时使用 */
+ (NSString *)changeIDtoStr:(id)inputstr;
/** 绝对时间，转换成相对时间 比如一分钟内，转换成刚刚 */
+ (NSString *)changeAbsuluteTimeToRelativeTime:(NSString *)absolutetime;
+ (UIImage *)getPhotoFromName:(NSString *)name;

/**
 保存用户属性，对于传入的key，自动附加用户id，这样每个用户的属性保存在不同地方，不互相冲突
 */
+ (void)saveUserPreferenceObject:(NSObject *)object forKey:(NSString *)key;

/**
 返回用户属性值，对于传入的key，自动附加用户id，这样每个用户的属性保存在不同地方，不互相冲突
 */
+ (id)getUserPreferenceObjectForKey:(NSString *)key;

/** 传入ctime(毫秒级）*/
+ (NSString *)getDateFromCtime:(NSNumber *)ctime;
/** 传入ctime(毫秒级）,转换为yyyy-MM-dd HH:mm */
+ (NSString *)getFullDateFromCtime:(NSNumber *)ctime;
/** 传入ctime(毫秒级）,转换为yyyy-MM-dd */
+ (NSString *)getDayDateFromCtime:(NSNumber *)ctime;
/** 返回服务器0时区时间，格式：2015-05-15 12:02:57 UTC +0000*/
+ (NSDate *)serverDateUTC0;

// NSDateFormatter格式高效单例
/** HH：mm */
+ (NSDateFormatter *)shareNSDateFormatterWithHHmm;
/** 昨天 HH:mm */
+ (NSDateFormatter *)shareNSDateFormatterWithYesterdayHHmm;
/** 前天 HH:mm */
+ (NSDateFormatter *)shareNSDateFormatterWith2DayAgoHHmm;
/** MM月dd日 HH:mm */
+ (NSDateFormatter *)shareNSDateFormatterWithMMddHHmm;
+ (NSString *)getFullDateFromCtimeWithMMddHHmm:(NSNumber *)ctime;
/** yyyy-MM-dd HH:mm */
+ (NSDateFormatter *)shareNSDateFormatterWithyyyyMMddHHmm;

/** 颜色转图片方法，创建纯色图片 */
+ (UIImage *)imageFromColor:(NSString *)color;
/** 颜色转图片方法，创建纯色图片，指定透明度 */
+ (UIImage *)imageFromColor:(NSString *)color alpha:(CGFloat)alpha;
/** 颜色转图片方法，创建纯色图片，指定透明度，指定大小 */
+ (UIImage *)imageFromColor:(NSString *)color
                      alpha:(CGFloat)alpha
                      width:(CGFloat)width
                     height:(CGFloat)height;

/** 去除首尾空格换行及中间换行 */
+ (NSString *)stringReplaceSpaceAndNewlinew:(NSString *)string;
/** 仅去除首伟空格及换行 */
+ (NSString *)stringReplaceSpace:(NSString *)string;

/// YuLing字符串是否为空和都是空格
+ (BOOL)isBlankString:(NSString *)string;

/**延迟指定的秒数，执行block代码块 */
+ (void)performBlockOnMainThread:(void (^)())block
                withDelaySeconds:(float)delayInSeconds;
+ (void)performBlockOnGlobalThread:(void (^)())block
                  withDelaySeconds:(float)delayInSeconds;

/** pragma mark - 获取动态字符串 */
+ (NSAttributedString *)attributedString:(NSString *)string
                                   color:(UIColor *)color
                                   range:(NSRange)range;

///计算字段的大小
+ (CGSize)sizeCalculatedFieldfsize:(CGSize)fsize
                              font:(UIFont *)font
                               str:(NSString *)str;

/** UIView转UIImage */
+ (UIImage *)imageWithUIView:(UIView *)view;
@end

/** 根据控件内容和字体大小自动调整其宽度的方法 */
@interface SimuUtil (Width)
/** 计算宽度并设置字体，FTCoreTextView宽度 */
+ (void)widthOfFTCoreTextView:(FTCoreTextView *)view
                      content:(NSString *)content
                         font:(CGFloat)font;
/** 计算宽度 */
+ (CGFloat)suggestWidthOfLabel:(UILabel *)label;
/** 计算宽度并设置字体，Label宽度 */
+ (void)widthOfLabel:(UILabel *)label font:(CGFloat)font;
/** 计算label的高度 参数 内容 + 字体大小 + size 只能在 7.0上使用 */
+ (CGSize)boundingRectWithSize:(NSString *)string
                      withFont:(float)font
                      withSize:(CGSize)labelSize;

/** 计算label内容的宽高 支持6.0系统的 */
+ (CGSize)labelContentSizeWithContent:(NSString *)string
                             withFont:(float)font
                             withSize:(CGSize)labelSize;

+ (CGFloat)widthNeededOfLabel:(UILabel *)label font:(CGFloat)font;
/** 根据字体和内容重设button宽度 */
+ (void)widthOfButton:(UIButton *)button
                title:(NSString *)title
           titleColor:(UIColor *)color
                 font:(CGFloat)font;

///指定位小数转为NSString
+ (NSString *)stringFromFloat:(float)number bits:(unsigned int)bits;
///取指定位小数
+ (float)getFloatWithFloat:(float)number bits:(unsigned int)bits;
/** 获得当前的IP地址 */
+ (NSString *)getCurrentIP;

@end

#pragma 自选股相关
@interface SimuUtil (SelfGroup)

+ (NSString *)currentSelectedSelfGroupID;
+ (void)saveCurrentSelectedSelfGroupID:(NSString *)groupID;

@end
