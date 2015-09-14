//
//  MyInfoTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15/7/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellBottomLinesView.h"
#import "MyInfomationItem.h"
@interface MyInfoTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet CellBottomLinesView *topSplitView;
/**名称*/
@property(weak, nonatomic) IBOutlet UILabel *rowNameLabel;
/**手机号*/
@property(weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**名称对应内容*/
@property(weak, nonatomic) IBOutlet UILabel *rowContentLabel;
/**箭头*/
@property(weak, nonatomic) IBOutlet UIImageView *arrowImageView;
/**头像*/
@property(weak, nonatomic) IBOutlet UIImageView *headImageView;
/**底部分割线*/
@property (weak, nonatomic) IBOutlet CellBottomLinesView *bottomSplitView;


- (void)bindUserInfo:(MyInfomationItem *)item
           withIndexPath:(NSIndexPath *)indexPath
    withRowToBindTypeDic:(NSDictionary *)rowToBindTypeDic;
@end
