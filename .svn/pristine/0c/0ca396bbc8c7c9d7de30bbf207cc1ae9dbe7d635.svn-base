//
//  ChangeUserInfoRequest.h
//  SimuStock
//
//  Created by jhss on 14-8-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequester.h"

@interface CustomeAvatarRequestObject : JsonRequestObject

@property(nonatomic, copy) NSString *headpic;

@end

@interface ChangeUserInfoRequest : NSObject <ASIHTTPRequestDelegate>

//修改昵称和签名
+ (void)changeNickname:(NSString *)newNickname
           withNewSignature:(NSString *)newSignature
                 withSyspic:(NSString *)syspicUrl
                withPicFile:(JhssPostData *)picFile
    withHttpRequestCallBack:(HttpRequestCallBack *)callback;

@end
