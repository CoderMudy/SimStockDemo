//
//  GameAdvertisingViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-6-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "GameAdvertisingViewController.h"
#import "BaseRequester.h"
#import "UIImageView+WebCache.h"
#import "WBImageView.h"
#import "YouguuSchema.h"
#import "GameWebViewController.h"
#import "ShareStatic.h"
#import "CacheUtil.h"

@implementation GameAdvertisingViewController

- (void)dealloc {
  if (gameScrollView) {
    [gameScrollView recyleResource];
  }
}

- (id)initWithAdListType:(AdListType)imageAdListType {
  if (self = [super init]) {

    CGFloat factor = WIDTH_OF_SCREEN / 320;

    adListType = imageAdListType;
    switch (adListType) {
    case AdListTypeCompetion:
      advHeight = competionAdvHeight * factor;
      break;
    case AdListTypeStockBar:
      advHeight = stockBarAdvHeight * factor;
      break;
    case AdListTypeOpenStockAccount:
      advHeight = openAccountAdvHeight * factor;
      break;
    case AdListTypeAdvanceVIP:
      advHeight = vipAdvHeight * factor;
      break;
    case AdListTypeFollowManster:
      advHeight = expertAdvHeight * factor;
    default:
      break;
    }
    dataArray = [[DataArray alloc] init];
    viewArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}

#pragma mark
#pragma mark 网络请求链接

- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}

- (void)requestFailed {
  if (_delegate && [_delegate respondsToSelector:@selector(advertisingPageJudgment:intg:)]) {
    [_delegate advertisingPageJudgment:NO intg:0];
  }
}

- (void)requestImageAdvertiseList {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    return;
  }
  GameAdvertisingData *adVertisingData;
  if (!dataArray.dataBinded) {
    adVertisingData = [CacheUtil loadMncgBanner];
    if (adVertisingData && [adVertisingData.dataArray count] > 0) {
      //是有缓存的
      [self bindGameAdvertisingData:adVertisingData saveToCache:NO];
    }
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak GameAdvertisingViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    GameAdvertisingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    GameAdvertisingViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindGameAdvertisingData:(GameAdvertisingData *)obj saveToCache:YES];
    }
  };
  callback.onFailed = ^{
    [weakSelf requestFailed];
    [weakSelf setNoNetwork];
  };
  if (adListType == AdListTypeOpenStockAccount) {
    [GameAdvertisingData requestOpenAccountAdvDataWithCallback:callback];
  } else if (adListType == AdListTypeStockBar) {
    [GameAdvertisingData requeststockBarAdvertisingDataAdWallWithCallback:callback];
  } else if (adListType == AdListTypeCompetion) {
    [GameAdvertisingData requestGameAdvertisingDataAdWallWithCallback:callback];
  } else if (adListType == AdListTypeAdvanceVIP) {
    [GameAdvertisingData requestAdvanceVIPAdvertisingDataAdWallWithCallback:callback];
  } else if (adListType == AdListTypeFollowManster) {
    [GameAdvertisingData requestFollowMasterBannerDataAdWallWithCallback:callback];
  }
}
- (void)bindGameAdvertisingData:(GameAdvertisingData *)adDataList {
  [self bindGameAdvertisingData:adDataList saveToCache:YES];
}
- (void)bindGameAdvertisingData:(GameAdvertisingData *)adDataList saveToCache:(BOOL)saveToCache {
  if (saveToCache) {
    [CacheUtil saveMncgBanner:adDataList withAdType:adListType];
  }
  dataArray.dataBinded = YES;
  [dataArray.array removeAllObjects];
  for (GameAdvertisingData *adData in adDataList.dataArray) {
    //只显示图片广告
    if ([adData.type isEqualToString:@"2501"]) { // 2501：图片广告
      [dataArray.array addObject:adData];
    }
  }
  if ([dataArray.array count] > 0) {
    [self createScrollView];
  }
  if (_delegate && [_delegate respondsToSelector:@selector(advertisingPageJudgment:intg:)]) {
    [_delegate advertisingPageJudgment:[dataArray.array count] > 0 intg:[dataArray.array count]];
  }
}
- (UIView *)addImageWithIndex:(int)index andFrame:(CGRect)frame {
  CGRect adViewFrame = CGRectMake(0.0, 0.0, whiteView.bounds.size.width, advHeight);
  CGRect imageButtonFrame = CGRectMake(0, 0,adViewFrame.size.width, adViewFrame.size.height);
  UIView *adView =
      [[UIView alloc] initWithFrame:imageButtonFrame];
  GameAdvertisingData *adData = dataArray.array[index];
  UIButton *imageButton =
      [[UIButton alloc] initWithFrame:CGRectMake(0, 0, adView.bounds.size.width, adView.bounds.size.height)];
  imageButton.backgroundColor = [Globle colorFromHexRGB:Color_White];
  UIImage *image =
      [ImageUtil loadImageFromUrl:adData.adImage
              withOnReadyCallback:^(UIImage *downloadImage, NSString *imageUrl) {
                [imageButton setBackgroundImage:downloadImage forState:UIControlStateNormal];
              }];
  if (image) {
    [imageButton setBackgroundImage:image forState:UIControlStateNormal];
  }
  imageButton.contentMode = UIViewContentModeScaleToFill;
  imageButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
  imageButton.tag = 1000 + index;
  [imageButton addTarget:self
                  action:@selector(pictureButtonMethod:)
        forControlEvents:UIControlEventTouchUpInside];
  [adView addSubview:imageButton];
  return adView;
}

#pragma mark------ UIScrollView -------
- (void)createScrollView {
  if (!whiteView) {
    whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [Globle colorFromHexRGB:Color_White];
    whiteView.userInteractionEnabled = YES;
    CGRect whiteViewFrame = CGRectMake(0, 0, self.view.width, advHeight);
    whiteView.frame = whiteViewFrame;
    [self.view addSubview:whiteView];
  }
  [whiteView removeAllSubviews];
  NSInteger adImageCount = [dataArray.array count];
  if (adImageCount <= 1) {
    [whiteView addSubview:[self addImageWithIndex:0 andFrame:whiteView.bounds]];
  } else {
    if (gameScrollView == nil) {
      gameScrollView = [[CycleScrollView alloc] initWithFrame:whiteView.bounds
                                                  pageInteger:adImageCount
                                            animationDuration:3];
      gameScrollView.userInteractionEnabled = YES;
    }
    [whiteView addSubview:gameScrollView];

    //显示内容
    [viewArray removeAllObjects];
    for (int i = 0; i < adImageCount; i++) {
      [viewArray addObject:[self addImageWithIndex:i andFrame:gameScrollView.bounds]];
    }
    if (adImageCount == 2) {
      for (int i = 0; i < adImageCount; i++) {
        [viewArray addObject:[self addImageWithIndex:i andFrame:gameScrollView.bounds]];
      }
    }
    //显示各广告页
    __weak NSMutableArray *weakViewArray = viewArray;
    gameScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex) {
      NSMutableArray *strongViewArray = weakViewArray;
      if (strongViewArray) {
        return strongViewArray[pageIndex];
      } else {
        return nil;
      }
    };
    //广告页数
    gameScrollView.totalPagesCount = ^NSInteger(void) {
      NSMutableArray *strongViewArray = weakViewArray;
      if (strongViewArray) {
        return [strongViewArray count];
      } else {
        return 0;
      }
    };
  };
}
#pragma mark UIBotton 方法

///图片上透明按钮:广告内容页跳转
- (void)pictureButtonMethod:(UIButton *)btn {
  GameAdvertisingData *adData = dataArray.array[btn.tag - 1000];
  [self touchAdvertise:adData];
}

- (void)touchAdvertise:(GameAdvertisingData *)adData {
  if ([adData.forwardUrl rangeOfString:@"http://"].length > 0) {
    GameWebViewController *webVC =
        [[GameWebViewController alloc] initWithNameTitle:adData.title andPath:adData.forwardUrl];
    webVC.urlType = ShareModuleTypeStaticWap;
    //切换
    [AppDelegate pushViewControllerFromRight:webVC];
    return;
  } else if ([adData.forwardUrl rangeOfString:@"youguu://"].length > 0) {
    [YouguuSchema handleYouguuUrl:[NSURL URLWithString:[adData.forwardUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    return;
  }
}

@end
