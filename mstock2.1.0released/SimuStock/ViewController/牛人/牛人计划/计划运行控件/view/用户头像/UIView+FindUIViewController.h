//
//  UIView+FindUIViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FindUIViewController)

- (UIViewController *)firstAvailableUIViewController;
- (id)traverseResponderChainForUIViewController;

@end
