//
//  ShortLineExpertRankViewController.m
//  SimuStock
//
//  Created by Jhss on 15/5/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ShortLineExpertRankViewController.h"

@interface ShortLineExpertRankViewController ()

@end

@implementation ShortLineExpertRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
   [self.topToolBar resetContentAndFlage:@"短线牛人榜" Mode:TTBM_Mode_Sideslip];
  
  
  [self backNetwork];
  
    // Do any additional setup after loading the view.
}

-(void)backNetwork
{
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack * callBack = [[HttpRequestCallBack alloc]init];
  __weak ShortLineExpertRankViewController *weakSelf= self;
  callBack.onSuccess = ^(NSObject *obj){
    ShortLineExpertRankViewController *strongSelf = weakSelf;
    if (strongSelf) {
      ShortLineExpertDataModel * shortLinerequest =(ShortLineExpertDataModel *)obj;
    }
  };
  callBack.onError = ^(BaseRequestObject *obj,NSException *exc){
    ShortLineExpertRankViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultErrorHandler];
    }
  };
  callBack.onFailed = ^{
    ShortLineExpertRankViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultFailedHandler];
    }
  };
  [ShortLineExpertRequest conductShortLineExpertRequestWithReqNum:@"20" WithFromId:@"1" WithCallback:callBack];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
