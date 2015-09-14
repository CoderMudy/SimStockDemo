//
//  RealTradeSecuritiesCompanyList.h
//  获取券商列表
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"


@class HttpRequestCallBack;

@interface RealTradeSecuritiesAccountType : BaseRequestObject2 <ParseJson>

/**券商类型名 */
@property(nonatomic, strong) NSString *name;
/**类型序号 */
@property(nonatomic, assign) NSInteger type;

/** 实盘客服电话简介 */
@property(nonatomic, strong) NSString *des;

/** main */
@property (copy, nonatomic) NSString *brokerMain;

@end


/** 实盘证券帮助链接 */
@interface RealTradeSecuritiesCompanyHelp : BaseRequestObject2<ParseJson>
/** 帮助简述 */
@property(nonatomic, strong) NSString *des;
/** 帮助标题 */
@property(nonatomic, strong) NSString *title;
@end


/** 实盘证券商客服电话 */
@interface RealTradeSecuritiesCompanyPhone : BaseRequestObject2 <ParseJson>
/** 实盘客服电话简介 */
@property(nonatomic, strong) NSString *des;
/** 实盘客服电话标题 */
@property(nonatomic, strong) NSString *title;
@end


/** 实盘证券券商信息简介 */
@interface RealTradeSecuritiesCompanyDes : BaseRequestObject2 <ParseJson>
//新的接口 该内容改为 内容简介 有title 和 content
/** 实盘客服电话简介 */
@property(nonatomic, strong) NSString *content;
/** 实盘客服电话标题 */
@property(nonatomic, strong) NSString *title;
@end


/** 开户方式 */
@interface RealTradeSecuritiesOpenType : BaseRequestObject2 <ParseJson>
/** 实盘客服电话简介 */
@property(nonatomic, strong) NSString *des;
/** 实盘客服电话标题 */
@property(nonatomic, strong) NSString *type;

@end



/** ios 下载链接 或者 公司链接 */
@interface BrokerDownloadPackage : BaseRequestObject2<ParseJson>

/** 苹果商店id */
@property(copy, nonatomic) NSString *appID;
/** 检查本地是否存在开户包 */
@property(copy, nonatomic) NSString *customurl;
/** web公司包 */
@property(copy, nonatomic) NSString *download;

@end


/** 券商信息类  */
@interface RealTradeSecuritiesCompany : BaseRequestObject2 <ParseJson>
/** 区分开户 或者 登录 */
@property(assign, nonatomic) BOOL isOpenLogin;


/** 广告 */
@property(nonatomic, strong) NSMutableArray *advArray;
/** 券商简述 */
@property(nonatomic, strong) NSMutableArray *openAccountArr;
/** 开户方式 */
@property(nonatomic, strong) RealTradeSecuritiesOpenType *des;
/**券商名称 */
@property(nonatomic, strong) NSString *name;
/** logo */
@property(nonatomic, strong) NSString *logo;
/**券商编号（登录） */
@property(nonatomic, strong) NSString *num;

/** 开户帮助 */
@property(nonatomic, strong) RealTradeSecuritiesCompanyHelp *openHelp;
/** 开户客服信息 */
@property(nonatomic, strong) RealTradeSecuritiesCompanyPhone *openPhone;
/** 开户方式 */
@property(nonatomic, strong) RealTradeSecuritiesAccountType *openType;


/**券商账户类型 */
@property(nonatomic, strong) NSMutableArray *accountTypes;
/** ak */
@property(nonatomic, strong) NSString *ak;
/** funcs */
@property(nonatomic, strong) NSString *funcs;

/** 帮助类 */
@property(nonatomic, strong) RealTradeSecuritiesCompanyHelp *help;

/**POST/GET method 请求方式*/
@property(nonatomic, strong) NSString *method;
/** 电话 */
@property(nonatomic, strong) RealTradeSecuritiesCompanyPhone *phone;

/**验证码地址 */
@property(nonatomic, strong) NSString *randUrl;
/** 标题 */
@property(nonatomic, strong) NSString *title;
/**type */
@property(nonatomic, assign) NSInteger type;

/** 登录方式 1 老的登录方式 2 web页登录 */
@property(nonatomic, assign) NSInteger oldNewTypeLogin;

/**访问地址 */
@property(nonatomic, strong) NSString *url;

/** 券商唯一标示符 */
@property(nonatomic, assign) NSInteger secNo;

/*******************************************/
/** ios */
@property(nonatomic, strong) BrokerDownloadPackage *downloadIOS;
@end

/**
 *  券商信息网络请求类
 */
@interface RealTradeSecuritiesCompanyList : JsonRequestObject

@property(nonatomic, strong) NSMutableArray *result;

@property(nonatomic, assign) BOOL openLogin;

/** 新增券商列表 国联证券 财富证券 */
+(void)loadNewBrokerageOpenAccountWithCallback:(HttpRequestCallBack *)callback;
/** 新券商交易登录接口 */
+(void)stockLoginList:(HttpRequestCallBack *)callback;
@end




