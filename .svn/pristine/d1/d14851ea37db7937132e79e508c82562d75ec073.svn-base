//
//  HomePopupsViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-6-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameAdvertisingData.h"
#import "DataArray.h"
#import "ViewController.h"

@interface HomePopupsViewController : UIViewController {
  DataArray *dataArray;
  UIImageView *imagev;
}
@property(nonatomic, weak) ViewController *delegate;

- (id)initWithViewController:(ViewController *)viewController
                  withAdData:(DataArray *)adData;
                  
///请求广告数据，如果没有显示，则显示广告
+ (void)requestAdDataWithViewController:(ViewController *)viewController;

@end