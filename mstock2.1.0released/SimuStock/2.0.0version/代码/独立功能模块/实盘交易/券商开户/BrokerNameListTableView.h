//
//  BrokerNameListTableView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/6/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataArray.h"
#import "RealTradeSecuritiesCompanyList.h"

/** 券商下载开户APP 类型 */
typedef NS_ENUM(NSInteger, BrokersDownloadType) {
  BrokerExternalDownloadAPP = 1, /** 下载app */
  BrokerEmbeddedApp = 5,         /** 内嵌 */
  BrokerWebAPP = 4,              /** web 广发特有 */
  BrokerHTM5 = 6                 /** HTM5开户 */
};

//枚举 区分券商开户 和 券商登录
typedef NS_ENUM(NSInteger, BrokerOpenLogin) {
  BrokerOpenAccount = 0, //开户
  BrokerLoginStock       //登录
};

/** 点击Cell用于回调 */
typedef void (^BrokerCompanyListBlock)(RealTradeSecuritiesCompany *,
                                       BrokerOpenLogin, NSDictionary *,
                                       BrokersDownloadType);

/** 当请求失败 或者 错误 数据没有绑定 */
typedef void(^RequestFailedOrError)();

/** 存放券商列表的类 */
@interface BrokerNameListTableView : UITableViewController {
  /** 记录已选中cell */
  NSInteger selectedCellIndex;
  ///传入参数：指定的券商，在selectedCellIndex= -1 时有效
  NSString *_selectedCompanyName;
}
// block
@property(copy, nonatomic) BrokerCompanyListBlock brokerCompanyListBlock;

@property(copy, nonatomic) RequestFailedOrError failedOrErrorBlock;

/** 证券列表数据 */
@property(strong, nonatomic) DataArray *stockListsArray;

/** 券商列表 */
@property(nonatomic, strong) RealTradeSecuritiesCompanyList *companyList;
/** 当前公司 */
@property(nonatomic, strong) RealTradeSecuritiesCompany *currentCompany;
/** 当前开户类型 */
@property(nonatomic, strong) RealTradeSecuritiesAccountType *currentAccountType;

@property(assign, nonatomic) BrokersDownloadType brokerDownloadType;

@property(nonatomic, strong) NSDictionary *secNoDic;

/** 重新init 判断是 开户还是登录 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
           withStirng:(BrokerOpenLogin)openAccountOrLogin;

/** 获取数据源 网络请求 */
- (void)getStockAccountsCompanyList;

@end
