//
//  HomePopupsViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-6-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HomePopupsViewController.h"
#import "SimuUtil.h"
#import "BaseRequester.h"
#import "GameWebViewController.h"
#import "YouguuSchema.h"

@implementation HomePopupsViewController

+ (void)requestAdDataWithViewController:(ViewController *)viewController {
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  __weak ViewController *weakViewController = viewController;

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
      GameAdvertisingData *gameAdData = (GameAdvertisingData *)obj;
      DataArray *dataArray = [[DataArray alloc] init];
      for (GameAdvertisingData *adData in gameAdData.dataArray) {
        if ([adData.type isEqualToString:@"2501"]) {
          [dataArray.array addObject:adData];
        }
      }

      if ([dataArray.array count] == 0) {
        return;
      }

      //检查是否已经显示过
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      NSArray *array = [userDefaults objectForKey:@"ADID"];
      NSMutableArray *userArr = [array mutableCopy];
      GameAdvertisingData *adData = dataArray.array[0];
      if (userArr) {
        for (NSString *ADID in userArr) {
          if ([ADID isEqualToString:adData.ADid]) {
            return;
          }
        }
      } else {
        userArr = [[NSMutableArray alloc] init];
      }
      [userArr addObject:adData.ADid];
      [userDefaults setObject:userArr forKey:@"ADID"];
    
      //没有显示，则显示广告
      HomePopupsViewController *popupWindow = [[HomePopupsViewController alloc]
          initWithViewController:weakViewController
                      withAdData:dataArray];
      popupWindow.view.autoresizingMask = YES;
      popupWindow.view.frame =
          CGRectMake(0, 0, popupWindow.delegate.view.bounds.size.width,
                     popupWindow.delegate.view.bounds.size.height);
      [popupWindow.delegate addChildViewController:popupWindow];
      [popupWindow.delegate.view addSubview:popupWindow.view];
  };

  [GameAdvertisingData
      requestGameAdvertisingDataPopWindowWithCallback:callback];
}

- (id)initWithViewController:(ViewController *)viewController
                  withAdData:(DataArray *)adData {
  if (self = [super init]) {
    dataArray = adData;
    self.delegate = viewController;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor =
      [[UIColor blackColor] colorWithAlphaComponent:0.5];

  //加载弹出框
  [self createDisplayView];
}

//创建显示的视图
- (void)createDisplayView {
  GameAdvertisingData *adData = dataArray.array[0];
  NSString *fileName = [NSString stringWithFormat:@"%@", adData.adImage];
  imagev = [[UIImageView alloc]
      initWithFrame:CGRectMake(20, (self.view.bounds.size.height - 286.0) / 2,
                               self.view.bounds.size.width - 40, 286.0)];
  imagev.tag = 3200;
  imagev.backgroundColor = [Globle colorFromHexRGB:@"#fdd51f"];
  [self performSelectorInBackground:@selector(loadImageFromUrl:)
                         withObject:fileName];
  [self.view addSubview:imagev];

  UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
  imageButton.backgroundColor = [UIColor clearColor];
  imageButton.frame = CGRectMake(20, (self.view.bounds.size.height - 286.0) / 2,
                                 self.view.bounds.size.width - 40, 286.0);
  imageButton.tag = 4001;
  [imageButton addTarget:self
                  action:@selector(pictureButtonMethod:)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:imageButton];

  //取消按钮
  UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelBtn.frame =
      CGRectMake(imageButton.bounds.size.width - 40.0 + 20 + 3.5,
                 (self.view.bounds.size.height - 286.0) / 2 + 1.5, 35.0, 35.0);
  cancelBtn.backgroundColor = [UIColor colorWithRed:223.0 / 255.0
                                              green:120.0 / 255.0
                                               blue:34.0 / 255.0
                                              alpha:1.0];
  cancelBtn.layer.cornerRadius = 35.0 / 2;
  [cancelBtn setImage:[UIImage imageNamed:@"首页弹窗关闭"]
             forState:UIControlStateNormal];
  cancelBtn.tag = 4002;
  [cancelBtn addTarget:self
                action:@selector(pictureButtonMethod:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:cancelBtn];
}

//异步请求图片（不添加缓存）
- (void)loadImageFromUrl:(NSString *)url {
  NSURL *imageUrl = [NSURL URLWithString:url];
  NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
  [self performSelectorOnMainThread:@selector(updateImageView:)
                         withObject:imageData
                      waitUntilDone:NO];
}

- (void)updateImageView:(NSData *)data {
  UIImageView *imageView = (UIImageView *)[self.view viewWithTag:3200];
  imageView.image = [UIImage imageWithData:data];
}
/** 图片点击函数 */
- (void)pictureButtonMethod:(UIButton *)btn {
  GameAdvertisingData *gameAdData = dataArray.array[0];

  NSInteger tag = btn.tag;
  if (tag == 4002) {
    [self.view removeFromSuperview];
  } else if (tag == 4001) {
    if ([gameAdData.forwardUrl rangeOfString:@"http://"].length > 0) {
      GameWebViewController *gameWebWebVC =
          [[GameWebViewController alloc] initWithNameTitle:gameAdData.title andPath:gameAdData.forwardUrl];
      gameWebWebVC.urlType = AdvUrlModuleTypeFirstPage;
      //切换
      [AppDelegate pushViewControllerFromRight:gameWebWebVC];
      return;
    } else if ([gameAdData.forwardUrl rangeOfString:@"youguu://"].length > 0) {
      [YouguuSchema handleYouguuUrl:[NSURL URLWithString:[gameAdData.forwardUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
      return;
    }
  }
}

@end
