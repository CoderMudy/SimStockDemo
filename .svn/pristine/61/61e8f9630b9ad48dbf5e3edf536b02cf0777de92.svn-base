//
//  simuCoverageView.h
//  SimuStock
//
//  Created by Mac on 14-9-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimuCoverDelegate <NSObject>
//点击抬起，且未移动
- (void)mouseTouchUp;

@end

/*
 *覆盖页面，单利化
 */
@interface SimuCoverageView : UIView

@property(weak, nonatomic) id<SimuCoverDelegate> delegate;

/** 获取单例 */
+ (instancetype)sharedCoverageView;

@end
