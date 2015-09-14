//
//  WarningLineView.h
//  SimuStock
//
//  Created by Jhss on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarningLineView : UITableViewCell

/** 警戒线 */
@property(weak, nonatomic) IBOutlet UILabel *warningNumber;
/** 平仓线 */
@property(weak, nonatomic) IBOutlet UILabel *flatNumber;

/** 警戒线和平仓线的视图 */
+ (WarningLineView *)createdWarningLineView;
@end
