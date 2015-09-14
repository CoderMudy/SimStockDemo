//
//  NSNull+JSONSupport.m
//  SimuStock
//
//  Created by Yuemeng on 15/2/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#define NSNullObjects @[ @"", @0, @{}, @[] ]

@implementation NSNull (JSONSupport)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
  NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
  if (!signature) {
    for (NSObject *object in NSNullObjects) {
      signature = [object methodSignatureForSelector:aSelector];
      if (signature) {
        break;
      }
    }
  }
  return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
  SEL aSelector = [anInvocation selector];

  for (NSObject *object in NSNullObjects) {
    if ([object respondsToSelector:aSelector]) {
      [anInvocation invokeWithTarget:object];
      return;
    }
  }

  [self doesNotRecognizeSelector:aSelector];
}

@end
