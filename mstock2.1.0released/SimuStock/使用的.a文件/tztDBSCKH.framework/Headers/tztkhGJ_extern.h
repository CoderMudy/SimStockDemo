//
//  tztkhGJ_extern.h
//  tztphonekh
//
//  Created by yangares on 14-1-23.
//  Copyright (c) 2014年 yangares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tztkhWebView.h"
@interface tztkhUILabel : UILabel
{
    UIEdgeInsets _insets;
}
- (void)setUIEdgeInsets:(UIEdgeInsets)insets;
@end

@interface tztkhGJ_extern : NSObject
//31000 返回的BINDATA 解析处理 KEY值就是接口文档中的字段
+(NSDictionary *)DealBindData:(NSString *)strData;
//31001 通用发送
+(void)onSendDataAction:(NSString *)strAction withDictValue:(NSMutableDictionary *)sendvalue;
@end


@interface tztkhWebView (GJ_extern)
//视频预约
-(void)ChangeToYuYueView;
-(void)ChangeToYuYueSuccess;
-(void)ChangeToVideoFail;
@end


@interface tztHTTPData (GJ_extern)
#ifndef tzt_KHSDK
- (NSString *)getlocalValueExten:(NSString*)strKey withJyLoginInfo:(id)logininfo;
#endif
-(id)tztReplaceData:(NSMutableDictionary*)pDict;
@end

#ifndef tzt_KHSDK
@interface tztMoblieStockComm (GJ_extern)
- (void)addTztCommHead:(NSMutableDictionary*)sendValue;
+ (void)AddCommHead:(NSMutableDictionary*)sendValue;
@end
#endif