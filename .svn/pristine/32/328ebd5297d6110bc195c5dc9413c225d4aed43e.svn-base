//
//  OpenAccountViewController.h
//  SimuStock
//
//  Created by Mac on 15-3-4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameAdvertisingViewController.h"
#import "RealTradeSecuritiesCompanyList.h"
#import "Image_TextButton.h"
#import "BrokerNameListTableView.h"

@interface OpenAccountViewController
    : UIViewController <UITableViewDataSource, UITableViewDelegate,
                        GameAdvertisingDelegate> {
  /** 开户信息显示 */
  UITableView *accountTableview;
  /** 开户信息数据 */
  NSMutableArray *accountArray;
  /** 开户源数据 */
  NSMutableArray *originalArray;
  /**广告信息数据*/
  NSMutableArray *advArray;
  /** 广告数据类 */
  GameAdvertisingData *advData;
  /** 广告对象 */
  GameAdvertisingViewController *advViewVC;
  /** 客服电话 */
  RealTradeSecuritiesCompanyPhone *openPhone;
  /** 客户指引 */
  RealTradeSecuritiesCompanyHelp *openHelp;
  //客服电话
  Image_TextButton *sevicesBtn;
  //开户指引
  Image_TextButton *accoutGuideBtn;
  //开户按钮
  UIButton *openAccountBtn;
  //当前证券
  NSString *currentAccountCompany;

  /** ios下载 */
  BrokerDownloadPackage *brokerDownload;
  /** 下载类型 */
  RealTradeSecuritiesAccountType *brokerAccountType;

  /** 券商信息 */
  RealTradeSecuritiesCompany *currentBrokerInfo;

  NSDictionary *_setNoMutableDic;
}
/** 券商下载开户APP 类型 */
@property(assign, nonatomic) BrokersDownloadType brokerDownloadT;

/** 当没有数据 没有缓存数据时 有数据为 YES */
@property(assign, nonatomic) BOOL noDataOrNoCache;

/** 刷新当前界面 */
- (void)refreshOpenAccountInfo:(RealTradeSecuritiesCompany *)obj;

/** 得到券商唯一数组 */
- (void)getBrokerSetNo:(NSDictionary *)setNoDic
   withBrokerSetNoType:(BrokersDownloadType)brokerDownloadType;

@end
