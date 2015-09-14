//
//  ExtendContractInfoView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtendContractInfoView : UIView

/** 账户管理费 */
@property(weak, nonatomic) IBOutlet UILabel *mgrAmount;

/** 通过ExtendContractInfoView.xib创建选项视图 */
+ (ExtendContractInfoView *)extendContractInfoView;
/** 设置管理费的显示格式 */
- (void)setupManagementInfoWithManagementFee:(NSString *)managementFee;

@end
