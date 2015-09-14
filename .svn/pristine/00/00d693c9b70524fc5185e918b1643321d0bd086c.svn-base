//
//  tztAppSetting.h
//  tztphonekh
//
//  Created by yangares on 14-1-10.
//  Copyright (c) 2014年 yangares. All rights reserved.
//

#import <Foundation/Foundation.h>

#define tztKhCertlicense @"KhCertlicense"

@interface tztkhAppSetting : NSObject
{
    NSString* _strAppTitle; //软件标题
    NSString* _strKhUrl; //开户URL
    NSString* _strSysFromVer;  //服务器版本
    NSString* _strSysCFrom; //版本来源
    NSString* _strServerList;  //服务器列表
    NSString* _strServerDefault;  //默认服务器
    NSString* _strTerminal;//终端标识

    int       _nJYServerPort;//交易端口
    int       _nZXServerPort;//资讯端口
    
    NSString* _strJhServer;    //均衡服务器
	int             _nJhPort;  //均衡服务器端口
	int				_nJhOpen;  //启用均衡 0 不启用 1 启用
    int             _nVideoLoopTime;//视频请求轮询时间。默认5秒
    
    NSDictionary* _setting;
    
    BOOL             _bShowStartView;//是否有启动页
    BOOL            _bShowStartWebView;//是否有第一个web开始页
    BOOL            _bShowOnePageStartView;
    int      _nSKinType;//0或空，默认 1-蓝白 2-红白
}
@property (nonatomic,retain) NSDictionary* setting;
@property (nonatomic,retain) NSString* strAppTitle;
@property (nonatomic,retain) NSString* strKhUrl;
@property (nonatomic,retain) NSString* strSysCFrom;
@property (nonatomic,retain) NSString* strSysFromVer;
@property (nonatomic,retain) NSString* strServerList;
@property (nonatomic,retain) NSString* strServerDefault;
@property (nonatomic,retain) NSString* strTerminal;
@property (nonatomic,retain) NSString* yybid;

@property int       nJYServerPort;
@property int       nZXServerPort;
@property int       nVideoLoopTime;

@property (nonatomic,retain) NSString* strJhServer;

@property int       nJhPort;
@property int       nJhOpen;

@property BOOL      bShowStartView;
@property BOOL      bShowStartWebView;
@property BOOL      bShowOnePageStartView;

@property int       nSkinType;

- (NSString*)getValueforKey:(NSString*)strKey;
- (void)setValue:(NSString*)strValue forKey:(NSString*)strKey;
+(tztkhAppSetting*)getShareInstance;
+(void)freeShareInstance;
@end
extern NSString *tztnsTerminal;
