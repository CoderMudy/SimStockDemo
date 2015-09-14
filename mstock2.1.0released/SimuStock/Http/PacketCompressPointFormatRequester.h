//
//  CompressPointStreamFormatRequester.h
//  SimuStock
//
//  Created by Mac on 14-10-31.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequester.h"
#import "NSDataCategory.h"
#import "NSStringCategory.h"
/*
 *说明：逐点压缩packet请求
 */
@interface PacketCompressPointFormatRequester : BaseRequester

/** 将二进制文件转化为table数组 */
+ (NSMutableArray *)parseComPointPackageTables:(NSData *)data;

@end
