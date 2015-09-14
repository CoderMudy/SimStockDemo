//
//  MatchCreateSuccessViewController.h
//  SimuStock
//
//  Created by jhss on 14-8-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "JhssImageCache.h"

@class MatchCreateViewController;

typedef void (^LeftBackBlock)();

@interface MatchCreateSuccessViewController : BaseViewController {
  //网络获取背景图
  UIImageView *urlImgView;
  UIView *comDetailsView;
}
@property(copy, nonatomic) NSString *matchName;
@property(copy, nonatomic) NSString *matchCreator;
@property(copy, nonatomic) NSString *matchCreatorNickName;
@property(copy, nonatomic) NSString *matchInviteCode;
@property(copy, nonatomic) NSString *matchImageUrl;
@property(copy, nonatomic) NSString *matchDescr;
@property(copy, nonatomic) NSString *matchTime;

@property(strong, nonatomic) MatchCreateViewController *parentVC;

/** 点击左上角返回按钮回调 */
@property(copy, nonatomic) LeftBackBlock leftBackBlock;

@end
