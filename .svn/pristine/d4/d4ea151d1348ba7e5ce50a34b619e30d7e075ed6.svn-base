//
//  UniversityInfoData.h
//  SimuStock
//
//  Created by Jhss on 15/8/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
#import "DataArray.h"

@class HttpRequestCallBack;

@interface UniversityInfoItem : BaseRequestObject2 <ParseJson>

/** 数据库排序Id */
@property(strong, nonatomic) NSString *orderId;

/** 学校名字 */
@property(strong, nonatomic) NSString *schoolName;

/** 学校的 */
@property(strong, nonatomic) NSString *schoolCode;
/** 学校名字的拼音 */
@property(strong, nonatomic) NSString *pinyinName;
/** 学校名字首个汉字的拼音 */
@property(strong, nonatomic) NSString *indexLetter;

@end

//版本号
@interface UniversityListVersion : JsonRequestObject

/** 学校的编码 */
@property(assign, nonatomic) NSInteger version;

/** 返回列表版本号 */
+ (void)requestMatchUniversityListVersionWithCallback:(HttpRequestCallBack *)callback;

@end

@interface UniversityInfoData : JsonRequestObject <Collectionable>

///保存数据
@property(strong, nonatomic) NSMutableArray *dataArray;
/**
 *  学校代码字典，用于增量数据去重
 */
@property(strong, nonatomic) NSMutableDictionary *codeDic;
/**
 *  保存最大的fromId,进行增量请求
 */
@property(assign, nonatomic) NSString *maxSortId;


/** 请求比赛高校名字列表 */
+ (void)requetMathSelectUniversityNameWithFromId:(NSString *)fromId
                                      withReqNum:(NSString *)reqNum
                                    withCallback:(HttpRequestCallBack *)callback;

@end
