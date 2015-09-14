// test
//  EntranceFunctionsClass.m
//  SimuStock
//
//  Created by jhss on 14-3-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "EntranceFunctionsClass.h"
#import "MobClick.h"
#import "event_view_log.h"
#import "ReadFromFile.h"
#import "SessionIDVerificationProcess.h"
#import "UIImage+ColorTransformToImage.h"

#import "AppUpdateInfo.h"
#import "ImageUtil.h"
#import "GameAdvertisingData.h"

#define PIC_NUM 4
@implementation EntranceFunctionsClass

#pragma mark
#pragma mark----启动页---------

- (id)initWithRoot:(UIView *)showView {
  self = [super init];
  if (self) {
    rootView = showView;
    [self showStartPage];
  }
  return self;
}
- (void)verifySid {
  [SessionIDVerificationProcess shareSidVerification];
}
#pragma mark
#pragma mark-------界面-------
- (void)showStartPage {
  [MobClick beginLogPageView:@"启动页"];
  //启动页日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV
                                                   andCode:@"启动页"];
  CGRect frame = [UIScreen mainScreen].bounds;
  NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];

  if ([[myUser objectForKey:@"firstLoading"] integerValue]) {
    //日志记录用户启动
    [self performSelector:@selector(verifySid) withObject:nil afterDelay:2.0];
    [[event_view_log sharedManager] addAppStartEventToLog:NO];
    //请求广告页
    [self requestAdDataWithLoadingPage];
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(releaseStartPage)
                                   userInfo:nil
                                    repeats:NO];

  } else {
    //日志记录用户首次启动
    [[event_view_log sharedManager] addAppStartEventToLog:YES];
    [myUser setObject:@"1" forKey:@"firstLoading"];
    [myUser synchronize];
    //启动页滚动视图
    loadingScr = [[UIScrollView alloc]
        initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    loadingScr.contentSize =
        CGSizeMake(frame.size.width * PIC_NUM, frame.size.height);
    loadingScr.pagingEnabled = YES;
    loadingScr.directionalLockEnabled = NO;
    loadingScr.bounces = NO;
    loadingScr.delegate = self;
    loadingScr.clipsToBounds = YES;
    loadingScr.userInteractionEnabled = YES;
    loadingScr.showsHorizontalScrollIndicator = NO;

    //创建4张图

    for (int i = 0; i < PIC_NUM; i++) {
      //显示图片
      // 4寸-3.5寸
      NSString *imageIndex;
      if (frame.size.height > 500) {
        imageIndex = [NSString stringWithFormat:@"page%d-568h@2x.jpg", i + 1];
      } else
        imageIndex = [NSString stringWithFormat:@"page%d-568h@2x.jpg", i + 1];
      UIImageView *pageImageView = [[UIImageView alloc]
          initWithFrame:CGRectMake(i * frame.size.width, 0, frame.size.width,
                                   frame.size.height)];
      pageImageView.tag = 100 + i;
      pageImageView.image = [UIImage imageNamed:imageIndex];

      //最后一页
      if (i == PIC_NUM-1) {

        CGFloat offsetHeight;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
          // ios7.0及以上版本
          offsetHeight = 0;
        } else {
          // ios7.0版本
          offsetHeight = 10;
        }

        endButton = [UIButton buttonWithType:UIButtonTypeCustom];
        endButton.frame = CGRectMake(30, frame.size.height - 65,
                                     frame.size.width - 60, 46 - offsetHeight);
        [endButton.layer setMasksToBounds:YES];
        [endButton.layer setCornerRadius:3.0f];
        [endButton setBackgroundColor:[Globle colorFromHexRGB:@"f65d87"]];
        [endButton setTitle:@"速速启程吧" forState:UIControlStateNormal];
        [endButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
        pageImageView.userInteractionEnabled = YES;

        //绘制按下态
        UIImage *endBtnDownImage =
            [UIImage imageFromView:endButton
                withBackgroundColor:[Globle colorFromHexRGB:@"d03a63"]];
        [endButton setBackgroundImage:endBtnDownImage
                             forState:UIControlStateHighlighted];
        [endButton addTarget:self
                      action:@selector(endShow:)
            forControlEvents:UIControlEventTouchUpInside];
        [pageImageView addSubview:endButton];
      }
      [loadingScr addSubview:pageImageView];
    }
    //创建结束

    [rootView addSubview:loadingScr];

    CGFloat startY;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
      // ios7.0及以上版本
      startY = 0;
    } else {
      // ios7.0版本
      startY = 20;
    }

    //底部pageControl
    _entrancePageControl = [[DDPageControl alloc] init];
    [_entrancePageControl
        setCenter:CGPointMake(frame.size.width / 2.0,
                              frame.size.height - startY - 20)];
    [_entrancePageControl setType:DDPageControlTypeOnFullOffEmpty];
    CGFloat tempWidth = 0.0375 * frame.size.width; //固定百分比
    [_entrancePageControl setIndicatorDiameter:tempWidth];
    [_entrancePageControl setIndicatorSpace:tempWidth];
    _entrancePageControl.numberOfPages = PIC_NUM;
    _entrancePageControl.onColor = [Globle colorFromHexRGB:Color_Blue_but];
    _entrancePageControl.offColor = [Globle colorFromHexRGB:Color_Circle];
    _entrancePageControl.userInteractionEnabled = NO;
    [rootView addSubview:_entrancePageControl];
  }
}

- (void)requestAdDataWithLoadingPage {
  CGRect frame = [UIScreen mainScreen].bounds;

  if (logoImageView == nil) {
    logoImageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(47, 12.5, 226, 46)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
  }

  //界面背景
  if (headerImageView == nil || footerImageView == nil) {

    headerImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(0, 0, frame.size.width,
                                 (frame.size.height / 4) * 3)];
    headerImageView.backgroundColor = [Globle colorFromHexRGB:@"ffffff"];
  }

  if (backgroundImageView == nil || headerImageView == nil) {
    backgroundImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if (frame.size.height > 500) {
      backgroundImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    } else {
      backgroundImageView.image = [UIImage imageNamed:@"Default@2x.png"];
    }
  }
  rootView.userInteractionEnabled = NO;

  [rootView addSubview:backgroundImageView];
  [backgroundImageView addSubview:headerImageView];
  [self showDictionary];

  [dataArray.array removeAllObjects];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    GameAdvertisingData *loadingAdData = (GameAdvertisingData *)obj;
    dataArray = [[DataArray alloc] init];
    for (GameAdvertisingData *adData in loadingAdData.dataArray) {
      if ([adData.type isEqualToString:@"2501"]) {
        [dataArray.array addObject:adData];
      }
    }
    UIImage *image;
    if (dataArray.array.count > 0) {
      GameAdvertisingData *adData = [dataArray.array objectAtIndex:0];
      image = [ImageUtil
             loadImageFromUrl:adData.adImage
          withOnReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
            NSLog(@"图片下载成功!");
          }];
    }
    if (image) {
      headerImageView.image = image;
    } else {
      NSString *filePath = [[NSBundle mainBundle]
          pathForResource:[NSString stringWithFormat:@"Default"]
                   ofType:@"jpg"];
      headerImageView.image = [UIImage imageWithContentsOfFile:filePath];
    }
  };
  callback.onFailed = ^{
    NSString *filePath = [[NSBundle mainBundle]
        pathForResource:[NSString stringWithFormat:@"Default"]
                 ofType:@"jpg"];
    headerImageView.image = [UIImage imageWithContentsOfFile:filePath];
  };
  callback.onError = ^(BaseRequestObject *err, NSException *ex) {
  };

  [GameAdvertisingData
      requestGameAdvertisingDataLoadingPageWithCallback:callback];
}

- (void)loadImageFromUrl:(NSString *)url {
  NSURL *imageUrl = [NSURL URLWithString:url];
  NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
  [self performSelectorOnMainThread:@selector(updateImageView:)
                         withObject:imageData
                      waitUntilDone:NO];
}

- (void)updateImageView:(NSData *)data {
  UIImageView *imageView = (UIImageView *)[rootView viewWithTag:3200];
  imageView.image = [UIImage imageWithData:data];
}

#pragma mark - scrollView 代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  NSInteger currentIndex =
      scrollView.contentOffset.x / scrollView.frame.size.width;
  [_entrancePageControl setCurrentPage:currentIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  // 2.2为弹性最大距离
  if (scrollView.contentOffset.x >
      [[UIScreen mainScreen] bounds].size.width * (PIC_NUM-1.8)) {
    _entrancePageControl.hidden = YES;
  } else {
    _entrancePageControl.hidden = NO;
  }
}

#pragma mark-------生成加载页背景--------
- (UIImage *)createLoadingPageBackGroundImage {
  CGRect frame = [UIScreen mainScreen].bounds;
  UIGraphicsBeginImageContext(frame.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  //抗锯齿
  CGContextSetAllowsAntialiasing(context, TRUE);
  CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
  CGContextRotateCTM(context, -360.0 * M_PI / 180.0);
  CGFloat colors[] = {
      209.0 / 255.0, 87.0 / 255.0, 128.0 / 255.0, 1.0,
      209.0 / 255.0, 87.0 / 255.0, 128.0 / 255.0, 0.0,
      // 250.0/255.0, 101.0/255.0, 135.0/255.0, 0.0,
      // 42.0/255.0, 29.0/255.0, 98.0/255.0, 1.0,
  };
  CGGradientRef clearCircleGradient = CGGradientCreateWithColorComponents(
      rgb, colors, NULL, sizeof(colors) / (sizeof(colors[0]) * 4));
  CGContextDrawRadialGradient(
      context, clearCircleGradient,
      CGPointMake(frame.size.width / 2, frame.size.height + 20), 0,
      CGPointMake(frame.size.width / 2, frame.size.height + 20),
      frame.size.height, kCGGradientDrawsBeforeStartLocation);
  // create->release
  CGColorSpaceRelease(rgb);
  headerImageView.image = UIGraphicsGetImageFromCurrentImageContext();
  CGGradientRelease(clearCircleGradient);
  return UIGraphicsGetImageFromCurrentImageContext();
}
#pragma mark
#pragma mark-------自动登录过程（UI)--------
//渐隐渐现 + 释放子视图
- (void)releaseStartPage {
  [self showStatusBar];
  [self showMainView];
}

//经典语句展示
- (void)showDictionary {
  ReadFromFile *readInfo = [[ReadFromFile alloc] init];
  //读取
  NSString *oneObj = [readInfo readFromTxtFile:@"StockDictInfo"];
  //显示
  CGSize size = [oneObj sizeWithFont:[UIFont systemFontOfSize:11]
                   constrainedToSize:CGSizeMake(280, MAXFLOAT)
                       lineBreakMode:NSLineBreakByClipping];

  CGRect frame = [UIScreen mainScreen].bounds;

  // 350的起始位置，label高度加80
  showLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(20, frame.size.height - size.height - 25,
                               frame.size.width - 40, size.height)];
  if (size.height > 40) { //四行
    showLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(20, frame.size.height - size.height - 2,
                                 frame.size.width - 40, size.height)];
  } else if (size.height < 20) { //一行
    showLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(20, frame.size.height - size.height - 25,
                                 frame.size.width - 40, size.height)];
  } else if (30 < size.height && size.height < 40) { //三行
    showLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(20, frame.size.height - size.height - 11,
                                 frame.size.width - 40, size.height)];
  }
  showLabel.numberOfLines = 0;
  showLabel.text = oneObj;
  showLabel.backgroundColor = [UIColor clearColor];
  showLabel.textAlignment = NSTextAlignmentCenter;
  showLabel.font = [UIFont systemFontOfSize:11];
  showLabel.textColor = [Globle colorFromHexRGB:@"#939393"];
  [backgroundImageView addSubview:showLabel];
}

- (void)showMainView {
  [MobClick endLogPageView:@"启动页"];
  if (headerImageView) {
    //释放自动登录界面
    [headerImageView removeFromSuperview];
  }
  if (footerImageView) {
    [footerImageView removeFromSuperview];
  }
  if (loadingScr) {
    //释放滚动视图
    [loadingScr removeFromSuperview];
  }
  if (backgroundImageView) {
    [backgroundImageView removeFromSuperview];
  }
  rootView.userInteractionEnabled = YES;
  //首页弹窗
  [self showMainPageViewController];
  //释放
}
/**显示状态栏*/
- (void)showStatusBar {
  //启动状态栏出现
  [[UIApplication sharedApplication]
      setStatusBarHidden:NO
           withAnimation:UIStatusBarAnimationFade];
}
//进入主界面(首页弹窗)
- (void)showMainPageViewController {

  [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_SIMUSTOCK_VIEW
                                                      object:nil];

  NSLog(@"⭐️启动完成，开始版本检测");

  //更新检测
  [self performSelector:@selector(onCheckVersionForSevers)
             withObject:Nil
             afterDelay:1];
}
#pragma mark
#pragma mark---------首次启动过程---------
- (void)endShow:(UIButton *)button {
  [self showStatusBar];
  //放大效果
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(releaseBackground)];
  [UIView setAnimationDuration:2.0];
  loadingScr.alpha = 0;
  [UIView commitAnimations];
}
- (void)releaseBackground {
  //启动页面隐藏
  [loadingScr removeFromSuperview];
  //首页弹窗
  [self showMainPageViewController];
  //释放自己
}

/*
 *功能：版本服务器升级函数（从公司的版本服务器上，取得升级消息）
 */
#pragma mark - 更新版本检测
- (void)onCheckVersionForSevers {
  //检测上次是否点了取消
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak EntranceFunctionsClass *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    EntranceFunctionsClass *strongSelf = weakSelf;
    if (strongSelf) {
      AppUpdateInfo *appUpdateInfo = (AppUpdateInfo *)obj;
      [strongSelf bindAppUpdateInfo:appUpdateInfo];
    }
  };
  [AppUpdateInfo checkLatestAppVersion:callback];
}

#pragma mark 绑定升级信息
- (void)bindAppUpdateInfo:(AppUpdateInfo *)appUpdateInfo {
  //存储升级信息，以便提示new
  [[NSUserDefaults standardUserDefaults] setObject:appUpdateInfo.status
                                            forKey:NEWVERSION];
  //如果服务器返回需要升级
  if (![appUpdateInfo.status isEqualToString:ALREADY_LATEST_APP]) {
    //存储最新版本
    _newestVersion = appUpdateInfo.version;
    //判断用户拒绝升级的版本是否等于最新版本
    NSString *rejectVersion =
        [[NSUserDefaults standardUserDefaults] objectForKey:REJECTVERSION];

    if (![rejectVersion isEqualToString:_newestVersion]) {
      NSString *title = [NSString
          stringWithFormat:@"发现新版本%@", appUpdateInfo.version];
      UIAlertView *alert =
          [[UIAlertView alloc] initWithTitle:title
                                     message:appUpdateInfo.message
                                    delegate:self
                           cancelButtonTitle:@"下次再说"
                           otherButtonTitles:@"立即更新", nil];
      alert.tag = 10001;
      [alert show];
    } else {
      NSLog(@"⭐️用户已拒绝升级此版本：%@，不提示更新",
            _newestVersion);
    }
  }
}

#pragma mark
#pragma mark UIAlertViewDelegate 协议回调函数
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 10001) {
    if (buttonIndex == 0) {
      //取消更新
      //存储本次version，不等时再次弹出提示
      if (_newestVersion) {
        [[NSUserDefaults standardUserDefaults] setObject:_newestVersion
                                                  forKey:REJECTVERSION];
        NSLog(@"⭐️用户拒绝版本升级，版本号：%@",
              _newestVersion);
      }
    } else {
      //[[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
      NSString *urlStr = [NSString
          stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",
                           [SimuUtil appid]];
      NSURL *url = [NSURL URLWithString:urlStr];
      [[UIApplication sharedApplication] openURL:url];
    }
  }
}

@end
