//
//  HttpRequestCallback.h
//  SimuStock
//
//  Created by Mac on 14-8-27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpRequestCallback <NSObject>

-(void) onSuccess:(NSObject*) obj;

-(void) onFailed;

-(void) onError:(NSObject*) error Exception:(NSException*) exception;
@end
