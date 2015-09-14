//
//  SpecilObjectViewController.h
//  SimuStock
//
//  Created by Mac on 15/1/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MessageDisplayDetailViewController.h"

@interface SpecilObjectViewController : MessageDisplayDetailViewController

///@对象 nickname和userid
@property(nonatomic, retain) YLDistributObject * yl_Object;

//+ (SpecilObjectViewController *)sharedInstance;
/// barid 所属股吧ID，发布成功后返回数据方便回调  @xxxx人，多传入一个@对象
-(void)StartAndName:(NSString *)name
    andObjectUserid:(NSString *)userid
        andCallBack:(OnReturnObject)callback;
@end
