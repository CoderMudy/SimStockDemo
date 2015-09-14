//
//  BaseRequester.m
//  SimuStock
//
//  Created by Mac on 14-8-27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequester.h"
#import "NSString+Java.h"
#import "NSString+MD5Addition.h"

@implementation JhssPostFile

@end

@implementation JhssPostData

@end

@implementation HttpRequestCallBack

+ (id)initWithOwner:(NSObject *)owner cleanCallback:(CleanAction)clearAction {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  __weak NSObject *weakObj = owner;
  callback.onCheckQuitOrStopProgressBar = ^{
    NSObject *strongObj = weakObj;
    if (strongObj) {
      return NO;
    } else {
      return YES;
    }
  };
  callback.onError = ^(BaseRequestObject *err, NSException *ex) {
    clearAction();
    [BaseRequester defaultErrorHandler](err, ex);
  };
  callback.onFailed = ^{
    clearAction();
    [BaseRequester defaultFailedHandler]();
  };
  return callback;
}

@end

@implementation BaseRequester {
}

static NSMutableArray *requestCache = nil;
+ (NSMutableArray *)getRequestCache {
  if (!requestCache) {
    requestCache = [[NSMutableArray alloc] init];
  }
  return requestCache;
}

static ASINetworkQueue *httpQueue = nil;
static const int DefaultTimeoutSeconds = 60;

+ (ASINetworkQueue *)sharedQueue {
  if (!httpQueue) {
    httpQueue = [[ASINetworkQueue alloc] init];

    //设置最大并发数
    httpQueue.maxConcurrentOperationCount = 20;

    //禁用此特性：当ASINetworkQueue中的一个request失败时，默认情况下，ASINetworkQueue会取消所有其他的request
    [httpQueue setShouldCancelAllRequestsOnFailure:NO];
  }
  return httpQueue;
}

- (id)init {
  if (self = [super init]) {
    _timeoutSeconds = DefaultTimeoutSeconds;
  }
  return self;
}

- (NSMutableDictionary *)createHttpHeaders {
  //设定http头
  NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
  //设定ak
  NSString *AK = [SimuUtil getAK];
  [headers setValue:AK forKey:@"ak"];
  //加入时间
  NSString *m_time = [SimuUtil getCorTime];
  if ([SimuUtil isLogined]) {
    //设定会话id
    [headers setValue:[SimuUtil getSesionID] forKey:@"sessionid"];
    //用户id
    [headers setValue:[SimuUtil getUserID] forKey:@"userid"];
    [headers setValue:[m_time stringByAppendingString:[SimuUtil getUserID]]
               forKey:@"ts"];
  } else {
    [headers setValue:@"0110001" forKey:@"sessionid"];
    [headers setValue:@"-1" forKey:@"userid"];
    [headers setValue:m_time forKey:@"ts"];
  }

  if ([self.url rangeOfString:@"jhss/member/doupdate"].length > 0) {
    // TODO:首次激活,给请求头添加fa和did,用于统计后台PV数.
    // TODO: move to doupdata接口
    //    //
    //    if (UserInfoUtil.getInstanse().isActivated()) {
    //      // 已经激活，需要传IMEI，为后台统计ＵＶ
    //      headers.add(new BasicHeader("did", PhoneUtils.getPhoneImei()));
    //      headers.add(new BasicHeader("am", PhoneUtils.getNetType()));
    //    } else {
    //      headers.add(new BasicHeader("did", PhoneUtils.getPhoneImei()));
    //      headers.add(new BasicHeader("fa", "1"));
    //      headers.add(new BasicHeader("am", PhoneUtils.getNetType()));
    //    }
  }

  return headers;
};

- (NSString *)createRequestUrl:(NSString *)requestUrl {
  //生成全地址
  NSMutableString *baseUrl = [NSMutableString stringWithString:requestUrl];
  if (self.requestParameters) {
    [self.requestParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj,
                                                                BOOL *stop) {
      if ([key isKindOfClass:[NSString class]] &&
          [obj isKindOfClass:[NSString class]]) {
        NSString *key2 =
            [[@"{" stringByAppendingString:key] stringByAppendingString:@"}"];
        [self replaceWithKey:key2 withValue:obj inString:baseUrl];
      }
    }];
  }
  NSString *akEncoded = [CommonFunc base64StringFromText:[SimuUtil getAK]];
  NSString *sidEncoded =
      [CommonFunc base64StringFromText:[SimuUtil getSesionID]];
  NSString *userIDEncoded =
      [CommonFunc base64StringFromText:[SimuUtil getUserID]];
  NSString *userNameEncoded =
      [CommonFunc base64StringFromText:[SimuUtil getUserName]];

  [self replaceWithKey:@"{ak}" withValue:akEncoded inString:baseUrl];
  [self replaceWithKey:@"{sid}" withValue:sidEncoded inString:baseUrl];
  [self replaceWithKey:@"{userid}" withValue:userIDEncoded inString:baseUrl];
  [self replaceWithKey:@"{uname}" withValue:userNameEncoded inString:baseUrl];

  return [baseUrl
      stringByAppendingString:
          [self youguuRandomWithParams:[baseUrl indexOfString:@"?"] != -1]];
}

- (NSString *)youguuRandomWithParams:(BOOL)hasParams {
  NSString *random = [[NSString
      stringWithFormat:@"%@%f", [SimuUtil getUserID],
                       [[NSDate date] timeIntervalSince1970]] stringFromMD5];
  return [NSString
      stringWithFormat:@"%@youguu_random=%@", hasParams ? @"&" : @"?", random];
}

- (void)replaceWithKey:(NSString *)key
             withValue:(NSString *)value
              inString:(NSMutableString *)baseUrl {
  NSRange range = [baseUrl rangeOfString:key];
  if (range.length == 0) {
    return;
  }
  [baseUrl replaceCharactersInRange:range withString:value];
}

- (void)configHTTPRequest:(ASIHTTPRequest *)request {
  if (_url && [_url hasPrefix:@"https"]) {
    request.shouldAttemptPersistentConnection = NO;
    [request
        setValidatesSecureCertificate:NO]; //请求https的时候，就要设置这个属性
  }
}

- (void)asynExecuteWithRequestUrl:(NSString *)requestUrl
                WithRequestMethod:(NSString *)requestMethod
            withRequestParameters:(NSDictionary *)parameters
           withRequestObjectClass:(Class)requestClass
          withHttpRequestCallBack:(HttpRequestCallBack *)httpRequestCallback {

  [self asynExecuteWithRequestUrl:requestUrl
                WithRequestMethod:requestMethod
            withRequestParameters:parameters
           withRequestObjectClass:requestClass
          withHttpRequestCallBack:httpRequestCallback
                 withNetworkQueue:nil];
}

- (void)asynExecuteWithRequestUrl:(NSString *)requestUrl
                WithRequestMethod:(NSString *)requestMethod
            withRequestParameters:(NSDictionary *)parameters
           withRequestObjectClass:(Class)requestClass
          withHttpRequestCallBack:(HttpRequestCallBack *)httpRequestCallback
                 withNetworkQueue:(ASINetworkQueue *)queue {
  if (requestUrl == nil || [@"" isEqualToString:requestUrl]) {
    [NewShowLabel
        setMessageContent:@"not implement method: getBaseUrl, please fix it"];
    return;
  }
  [self createHttpRequestWithUrl:requestUrl
               WithRequestMethod:requestMethod
           withRequestParameters:parameters];
  self.requestObjectClass = requestClass;
  self.httpRequestCallback = httpRequestCallback;
  [[BaseRequester getRequestCache] addObject:self];
  NSLog(@"net_URL: %@", self.url);
  ASINetworkQueue *networkQueue = queue ? queue : [BaseRequester sharedQueue];
  [networkQueue addOperation:self.httpRequest];
  [networkQueue go];
}

- (void)createHttpRequestWithUrl:(NSString *)requestUrl
               WithRequestMethod:(NSString *)requestMethod
           withRequestParameters:(NSDictionary *)parameters {
  if (requestUrl == nil || [@"" isEqualToString:requestUrl]) {
    [NewShowLabel
        setMessageContent:@"not implement method: getBaseUrl, please fix it"];
    return;
  }
  self.requestParameters = parameters;

  self.url = [self createRequestUrl:requestUrl];

  //生成Request
  ASIHTTPRequest *request;
  if ([@"GET" isEqualToString:requestMethod]) {
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.url]];
  } else if ([requestMethod hasPrefix:@"POST"]) {
    ASIFormDataRequest *request2 =
        [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.url]];
    if ([requestMethod isEqualToString:@"POST"]) {
      [request2 setPostFormat:ASIURLEncodedPostFormat];
    } else {
      [request2 setPostFormat:ASIMultipartFormDataPostFormat];
    }
    [request2 setStringEncoding:NSUTF8StringEncoding];
    [request2 setRequestMethod:@"POST"];
    request = request2;
    if (self.requestParameters) {
      [self.requestParameters
          enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([key isKindOfClass:[NSString class]]) {
              if ([obj isKindOfClass:[NSString class]]) {
                [request2 addPostValue:obj forKey:key];
              } else if ([obj isKindOfClass:[JhssPostFile class]]) {
                [request2 addFile:[obj filepath]
                      withFileName:[obj filename]
                    andContentType:[obj contentType]
                            forKey:key];
              } else if ([obj isKindOfClass:[JhssPostData class]]) {
                [request2 addData:[obj data]
                      withFileName:[obj filename]
                    andContentType:[obj contentType]
                            forKey:key];
              }
            }
          }];
    }
  } else {
    @throw([NSException
        exceptionWithName:@"not support parameters"
                   reason:[@"not support parameters: "
                              stringByAppendingString:requestMethod]
                 userInfo:nil]);
  }

  //添加Header
  request.requestHeaders = [self createHttpHeaders];
  //执行请求
  [request setTimeOutSeconds:60];
  [request setDelegate:self];
  [request setDidFinishSelector:@selector(requestFinished:)];
  [request setDidFailSelector:@selector(requestFailed:)];
  [self configHTTPRequest:request];

  self.httpRequest = request;
}

- (void)requestFinished:(ASIHTTPRequest *)request{

                        };

- (void)requestFailed:(ASIHTTPRequest *)request {
  [self handleFailed];
  return;
};

- (void)handleSaveCache:(NSData *)dic {
  if (self.saveToCache) {
    self.saveToCache(dic);
  }
}

- (void)handleSuccess:(NSObject *)obj {
  if (self.httpRequestCallback.onCheckQuitOrStopProgressBar) {
    BOOL shouldQuit = self.httpRequestCallback.onCheckQuitOrStopProgressBar();
    if (shouldQuit) {
      return;
    }
  }
  self.httpRequestCallback.onSuccess(obj);
}
#pragma mark----------错误处理----------
- (void)handleError:(BaseRequestObject *)requestObject
        orException:(NSException *)ex {
  if (self.httpRequestCallback.onCheckQuitOrStopProgressBar) {
    BOOL shouldQuit = self.httpRequestCallback.onCheckQuitOrStopProgressBar();
    if (shouldQuit) {
      return;
    }
  }

  if (self.httpRequestCallback.onError) {
    [self.httpRequestCallback onError](requestObject, ex);
  } else {
    [BaseRequester defaultErrorHandler](requestObject, ex);
  }
}

- (void)handleFailed {
  if (self.httpRequestCallback.onCheckQuitOrStopProgressBar) {
    BOOL shouldQuit = self.httpRequestCallback.onCheckQuitOrStopProgressBar();
    if (shouldQuit) {
      return;
    }
  }
  if (self.httpRequestCallback.onFailed) {
    [self.httpRequestCallback onFailed]();
  } else {
    [BaseRequester defaultFailedHandler]();
  }
}

/**
 返回默认的错误处理
 */
+ (onError)defaultErrorHandler {
  return ^(BaseRequestObject *error, NSException *ex) {
    if (error) {
      //实盘交易:实盘长时间未操作
      if ([[error status] isEqualToString:@"0801"]) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:illegal_Logon_realtrade
                          object:error.message];

        return;
      }
      if ([error.status isEqualToString:@"0101"]) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:Illegal_Logon_SimuStock
                          object:nil];
      } else {
        [NewShowLabel setMessageContent:error.message];
      }
      return;
    }
    if (ex) {
      NSLog(@"👉⚠️❌%@", ex);
    }
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
  };
};

/**
 返回默认的请求失败处理
 */
+ (onFailed)defaultFailedHandler {
  return ^() {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
  };
};

@end
