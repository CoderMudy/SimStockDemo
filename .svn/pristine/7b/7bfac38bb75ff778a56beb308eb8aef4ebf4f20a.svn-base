//
//  event_view_log.h
//  DDMenuController
//
//  Created by moulin wang on 13-9-7.
//ss
//

#import <Foundation/Foundation.h>
#import "FMDatabaseAdditions.h"
#import "FMDatabase.h"
#import "SimuUtil.h"
/*
 *类说明：日记纪录类
 */
@interface logEventItem : NSObject
{
    //事件类型
    NSInteger lei_Type;
    //功能点编码
    NSString * lei_Codes;
}

@property (assign,nonatomic) NSInteger Type;
@property (copy,nonatomic) NSString * Codes;
@end
/*
 *日志事件种类
 */
typedef enum
{
    //app启动事件
    Log_Type_StartApp=99,
    //app在线时长事件
    Log_Type_OnLineTime,
    //app展示事件
    Log_Type_PV,
    //按钮点击事件
    Log_Type_Button,
    //登录事件
    Log_Type_Loginstart,
    
}Log_Type;

@interface event_view_log : NSObject
{
    
    FMDatabase * _db;
    NSString * _name;
    //事件数组
    NSMutableArray * eventItemArray;
    NSTimer * logTimer;
    
}

+(event_view_log *)sharedManager;
+(id)alloc;
-(id)init;


/*
 *功能：app启动事件写到日志中
 *参数：isFirstAC YES 安装后第一次启动 NO 安装后非第一次启动
 */
-(void)addAppStartEventToLog:(BOOL)isFirstAC;
/*
 *功能：登录事件写的日志中
 */
-(void)addLoginEventToLog;
/*
 *功能：在线时长事件写到日志中，当用户退出程序或者退出登录的时候，调用
 */
-(void)addOnLineEventToLog;
/*
 *功能：pv和按钮事件写到日志中
 *参数：event_type 区分是pv事件还是按钮事件 pv事件使用：Log_Type_PV 按钮事件使用：Log_Type_Button
 *参数：codes 标志是哪个pv和按钮 按照相关表格文档填写
 */
-(void)addPVAndButtonEventToLog:(Log_Type) event_type andCode:(NSString *)codes;

/** 首次激活调用此方法，上传用户唯一id：idfa(>=7.0) mac(<7.0);
  本地首次激活的判断标准：读取参数信息，如果该参数不存在，则为首次激活；
  服务端首次激活的判断标准：通过idfv过滤重复用户，对于idfv相同的用户，只能算一个用户；
 */
+(void) requestActivateNotify;

/** 首次注册调用此方法，上传用户唯一id：idfa(>=7.0) mac(<7.0);
 本地首次注册的判断标准：读取参数信息，如果该参数不存在，则为首次注册；
 服务端首次注册的判断标准：通过idfv过滤重复用户，对于idfv相同的用户，只能算一个用户；
 */
+(void) requestRegisterNotify;

@end
