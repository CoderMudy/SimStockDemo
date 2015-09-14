//
//  FSPositionsViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionData.h"
#import "SimuIndicatorView.h"
#import "BaseTableViewController.h"

#import "DataArray.h"

@class PositionData;
@class WFFirmHeadInfoData;

@interface FSPositionTableAdapter : BaseTableAdapter

@property(nonatomic, assign) BOOL firmOrCapital;

@end


@protocol PostitonDataDelegate <NSObject>
//将PositionData 传出去
- (void)sendToFinfomationMoreVC:(PositionData *)postitonData;

@end

/**
 *点击持仓请求可买可卖数量信息
 */
typedef void (^plancountZqdm)(NSObject *, BOOL);
/**
 *账户页面持仓请求可买可卖数量信息
 */
typedef void (^accountZqdm)(PositionData *);
/**
 *请求网络失败
 */
typedef void (^requestError)();

/**
 * 配资实盘 持仓页面头数据
 */
typedef void (^WFHeadBlock)(WFFirmHeadInfoData *);

/**实盘持仓列表*/
@interface FSPositionsViewController : BaseTableViewController{
  /** 用来做判断 给页面在那个界面显示 */
  BOOL _firmOrCapital;
  
  UIView *_header;

}

@property(nonatomic, strong) NSString *sale;
@property(nonatomic, strong) NSString *account;
@property(nonatomic, copy) plancountZqdm plancountZqdm;
@property(nonatomic, copy) accountZqdm accountZqdm;

@property(nonatomic, weak) id<PostitonDataDelegate> posDelegate;

@property(nonatomic, strong) PositionData *positionData;

//头 恒生配资
@property(copy, nonatomic) WFHeadBlock headViewData;

/**初始方法*/
- (id)initSale:(NSString *)sale
                      rect:(CGRect)rect
    withFirmOfferOrCapital:(BOOL)firmOrCapital;
/**初始方法账户 加两个参数 判断改页面在那个地方展示 实盘 还是配资 */
- (id)initAccount:(NSString *)account
                      rect:(CGRect)rect
    withFirmOfferOrCapital:(BOOL)firmOrCapital;


-(void) onSelectStockWithTableView:(UITableView *)tableView
         didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

/** 每次显示时都刷新数据 */
-(void)reloadDataWithTableView;

@end
