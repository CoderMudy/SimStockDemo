//
//  AuthOptionsDelegate.m
//  SimuStock
//
//  Created by jhss on 14-7-3.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "AuthOptionsDelegate.h"
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/NSString+Common.h>
#import "AppDelegate.h"

@implementation AuthOptionsDelegate
#pragma mark - ISSShareViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController
                shareType:(ShareType)shareType {
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    CGRect frame = viewController.navigationController.navigationBar.frame;
    viewController.navigationController.navigationBar.frame =
        CGRectMake(0, 0, frame.size.width, frame.size.height + 20);

    viewController.view.frame =
        CGRectMake(0, viewController.view.frame.origin.y + 20,
                   viewController.view.bounds.size.width,
                   viewController.view.bounds.size.height);
  }
  AppDelegate *myApp =
      (AppDelegate *)[UIApplication sharedApplication].delegate;
  myApp.window.frame = [[UIScreen mainScreen] bounds];
  CGRect frame = viewController.navigationController.navigationBar.frame;
  viewController.navigationController.navigationBar.frame =
      CGRectMake(0, 20, frame.size.width, frame.size.height);
  if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] !=
      NSOrderedAscending) {
    UIButton *leftBtn =
        (UIButton *)viewController.navigationItem.leftBarButtonItem.customView;
    UIButton *rightBtn =
        (UIButton *)viewController.navigationItem.rightBarButtonItem.customView;
    if ([leftBtn respondsToSelector:@selector(setTitleColor:forState:)]) {
      [leftBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    }
    if ([rightBtn respondsToSelector:@selector(setTitleColor:forState:)]) {
      [rightBtn setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = viewController.title;
    label.font = [UIFont boldSystemFontOfSize:18];
    [label sizeToFit];

    viewController.navigationItem.titleView = label;
  }
  //扩展导航条
  UIImage *navgationBarImage = [UIImage imageNamed:@"SST_BN_background.png"];
  navgationBarImage = [navgationBarImage
      resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 10, 20)];
  //背景色
  viewController.view.backgroundColor = [UIColor whiteColor];
  if ([UIDevice currentDevice].isPad) {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:22];
    viewController.navigationItem.titleView = label;
    label.text = viewController.title;
    [label sizeToFit];

    if (UIInterfaceOrientationIsLandscape(
            viewController.interfaceOrientation)) {
      [viewController.navigationController.navigationBar
          setBackgroundImage:
              [UIImage imageNamed:@"iPadLandscapeNavigationBarBG.png"]];
    } else {
      [viewController.navigationController.navigationBar
          setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
    }
  } else {
    if (UIInterfaceOrientationIsLandscape(
            viewController.interfaceOrientation)) {
      if ([[UIDevice currentDevice] isPhone5]) {
        [viewController.navigationController.navigationBar
            setBackgroundImage:navgationBarImage];
      } else {
        [viewController.navigationController.navigationBar
            setBackgroundImage:navgationBarImage];
      }
    } else {
      [viewController.navigationController.navigationBar
          setBackgroundImage:navgationBarImage];
    }
  }
}
//取消
- (void)viewOnWillDismiss:(UIViewController *)viewController
                shareType:(ShareType)shareType {
}

@end
