//
//  RealTradeRequester.m
//  SimuStock
//
//  Created by Mac on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeRequester.h"

@implementation RealTradeAuthInfo

+ (RealTradeAuthInfo *)singleInstance {
  static RealTradeAuthInfo *sharedInstance = nil;

  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{ sharedInstance = [[self alloc] init]; });

  return sharedInstance;
}

@end

@implementation RealTradeRequester



- (void)configHTTPRequest:(ASIHTTPRequest *)request {
  request.shouldAttemptPersistentConnection = NO;
  [request
      setValidatesSecureCertificate:NO]; //请求https的时候，就要设置这个属性
}

- (NSMutableDictionary *)createHttpHeaders {
  //设定http头
  NSMutableDictionary *headers = [super createHttpHeaders];

  if ([RealTradeAuthInfo singleInstance].cookie) {
    [headers setValue:[RealTradeAuthInfo singleInstance].cookie
               forKey:@"Cookie"];
  }

  return headers;
};

- (void)handleError:(BaseRequestObject *)requestObject
        orException:(NSException *)ex {
  if (self.httpRequestCallback.onCheckQuitOrStopProgressBar) {
    BOOL shouldQuit = self.httpRequestCallback.onCheckQuitOrStopProgressBar();
    if (shouldQuit) {
      return;
    }
  }


  if (self.httpRequestCallback.onError) {
    [self.httpRequestCallback onError](requestObject, nil);
  } else {
    [BaseRequester defaultErrorHandler](requestObject, nil);
  }
}
@end

@implementation RealTradeCaptchaImageRequester

-(id) init{
  if (self = [super init]) {
    self.timeoutSeconds = 15;
  }
  return self;
}

- (void)configHTTPRequest:(ASIHTTPRequest *)request {
  request.shouldAttemptPersistentConnection = NO;
  [request
      setValidatesSecureCertificate:NO]; //请求https的时候，就要设置这个属性
}

- (void)requestFinished:(ASIHTTPRequest *)request {
  @try {
    NSData *data = [request responseData];
    if (data == nil || [data length] < 2) {
      [self handleFailed];
      return;
    }

    UIImage *image = [[UIImage alloc] initWithData:data];
    if (image) {

      //设置实盘网络接口的cookie

      NSDictionary *cookies = [request responseHeaders];
      if (cookies[@"Set-Cookie"]) {
        [RealTradeAuthInfo singleInstance].cookie = cookies[@"Set-Cookie"];
      }
      [self handleSuccess:image];
    } else {
      [self handleFailed];
    }

    return;
  }
  @catch (NSException *ex) {
    [self handleError:nil orException:ex];
  }
  @finally {
    [[BaseRequester getRequestCache] removeObject:self];
  }
};

@end
