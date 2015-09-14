//
//  WFDataSharingCenter.h
//  SimuStock
//
//  Created by moulin wang on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFDataSharingCenter : NSObject

/** 恒生用户编号 */
@property(copy, nonatomic) NSString *hsUserId;
/** 主账号 */
@property(copy, nonatomic) NSString *homsFundAccount;
/** 子账号 */
@property(copy, nonatomic) NSString *homsCombineld;
/** 操作员编号 */
@property(copy, nonatomic) NSString *operatorNo;

/** 合约号 */
@property(copy, nonatomic) NSString *contracNo;


/** 实盘界面 客户号 */
@property(copy, nonatomic) NSString *brokerUserId;

/** 持仓数据array */
@property(strong, nonatomic)NSMutableArray *positionArray;

//保存数据
-(void)saveDataWithDataArray:(NSMutableArray *)mutableArray;


//单利传值 数据共享
+(WFDataSharingCenter *)shareDataCenter;

@end
