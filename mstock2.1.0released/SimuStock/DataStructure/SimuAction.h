//
//  SimuAction.h
//  SimuStock
//
//  Created by Mac on 13-8-7.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
/*
 *类说明：事件定义，页面交互事件定义
 *
 */
#import <Foundation/Foundation.h>

@interface SimuAction : NSObject
{
    /**
	 * aciton指向代码
	 */
	NSString *_actionCode;
    /**
	 * aciton 访问网络地址
	 */
    NSString *_actionNetURL;
    /**
	 * aciton 事件变量
	 */
	NSMutableDictionary *_vars;
}
//初始化
-(id) initWithCode:(NSString *) action_code ActionURL:(NSString *) URL;
-(void)withcode:(NSString *)action_code andaction_url:(NSString *)URL;
@property(strong,nonatomic) NSString *actionCode;
@property(strong,nonatomic) NSString *actionNetURL;
@property(strong,nonatomic) NSMutableDictionary * vars;

@end
