//
//  WFBankInfoData.h
//  SimuStock
//
//  Created by moulin wang on 15/4/21.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
#import "DataArray.h"
@class HttpRequestCallBack;

@interface WFBankData : JsonRequestObject

/** 银行名称 */
@property(copy, nonatomic) NSString *bankName;
/** logo */
@property(copy, nonatomic) NSString *bankLogo;
/** 银行标识 */
@property(copy, nonatomic) NSString *bankNameAbbr;
/** 银行头字母 */
@property(copy, nonatomic) NSString *bankNameChar;
/** id */
@property(copy, nonatomic) NSString *bankID;

//保存数据
@property(strong, nonatomic) DataArray *dataArray;

@end

@interface WFBankInfoData : NSObject

+ (void)requestBankInfoWithCallbackWithType:(NSString *)type
                               withCallback:(HttpRequestCallBack *)callback;

@end
