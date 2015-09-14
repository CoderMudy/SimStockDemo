//
//  JHSSViewDelegate.m
//  SimuStock
//
//  Created by jhss on 13-10-30.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "JHSSViewDelegate.h"
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import "AppDelegate.h"

@implementation JHSSViewDelegate
#pragma mark - ISSShareViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType {
  //修改左右按钮的文字颜色

  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    viewController.navigationController.navigationBar.barTintColor = [Globle colorFromHexRGB:Color_Blue_but];

    viewController.navigationController.navigationBar.frame =
        CGRectMake(0, 0, viewController.view.frame.size.width, 64);
    UIBarButtonItem *leftBtn = viewController.navigationItem.leftBarButtonItem;
    UIBarButtonItem *rightBtn = viewController.navigationItem.rightBarButtonItem;
    [leftBtn setTintColor:[UIColor whiteColor]];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [leftBtn setTitle:@"取消"];
    [rightBtn setTitle:@"发布"];
  } else {
    viewController.navigationController.navigationBar.tintColor = [Globle colorFromHexRGB:Color_Blue_but];

    viewController.navigationController.navigationBar.frame =
        CGRectMake(0, 0, viewController.view.frame.size.width, 64);
    UIBarButtonItem *leftBtn = viewController.navigationItem.leftBarButtonItem;
    UIBarButtonItem *rightBtn = viewController.navigationItem.rightBarButtonItem;
    [leftBtn setTintColor:[Globle colorFromHexRGB:Color_Blue_but]];
    [rightBtn setTintColor:[Globle colorFromHexRGB:Color_Blue_but]];
    [leftBtn setTitle:@"取消"];
    [rightBtn setTitle:@"发布"];
  }
  //背景色
  viewController.view.backgroundColor = [UIColor whiteColor];
  UILabel *label = [[UILabel alloc] init];
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor whiteColor];
  label.shadowColor = [UIColor grayColor];
  label.font = [UIFont systemFontOfSize:18];
  viewController.navigationItem.titleView = label;
  label.text = viewController.title;
  [label sizeToFit];
}

//取消
- (void)viewOnWillDismiss:(UIViewController *)viewController shareType:(ShareType)shareType {
}

/** 发布 */
- (id<ISSContent>)view:(UIViewController *)viewController
    willPublishContent:(id<ISSContent>)content
             shareList:(NSArray *)shareList {
  return [ShareSDK content:[NSString stringWithFormat:@"%@", [content content]]
            defaultContent:[content defaultContent]
                     image:[content image]
                     title:[content title]
                       url:[content url]
               description:[content description]
                 mediaType:[content mediaType]];
}

- (void)view:(UIViewController *)viewController
    autorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                           shareType:(ShareType)shareType {
  if ([UIDevice currentDevice].isPad) {
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
      [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadLandscapeNavigationBarBG.png"]];
    } else {
      [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
    }
  } else {
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
      if ([[UIDevice currentDevice] isPhone5]) {
        [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
      } else {
        [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
      }
    } else {
      [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
    }
  }
}

@end