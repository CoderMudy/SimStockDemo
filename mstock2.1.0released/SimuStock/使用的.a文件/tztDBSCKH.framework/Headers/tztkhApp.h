//
//  tztkhApp.h
//  tztphonekh_gjsc
//
//  Created by yangares on 14-1-24.
//  Copyright (c) 2014年 yangares. All rights reserved.
//
#ifndef __TZTAPP__H__
#define __TZTAPP__H__

#import <Foundation/Foundation.h>

@interface tztkhApp : NSObject
{
    BOOL _bFreeALL; //释放所有
    UINavigationController* _khnavigationController;
}
@property BOOL bFreeALL;
@property (nonatomic,retain)UINavigationController* khnavigationController;
//初始化开户对象
+ (id)getShareInstance;
//释放开户对象
+ (void)freeShare;
+ (NSString*)GetSDKVersion;
+ (UINavigationController *)getNavigationController;
//退出开户流程
- (void)closekhApp;
//调用开户功能
- (NSInteger)callService:(NSDictionary*)params withDelegate:(id)delegate;
//设置终端标识
-(void)SetTerminal:(NSString *)nsTerminal;
//设置UI标识 0或空－默认蓝黑 1-蓝白 2-红白
-(void)SetUISign:(int)nType;
- (void)setMenuBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end
#endif
