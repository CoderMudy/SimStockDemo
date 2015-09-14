//
//  MakingScreenShot.h
//  SimuStock
//
//  Created by jhss on 14-6-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MakingScreenShotType_HomePage 1
#define MakingScreenShotType_TrendPage_All 2
#define MakingScreenShotType_TrendPage_Half 3
#define MakingScreenShotType_TradePage 4
@interface MakingScreenShot : NSObject {
  //截图成功与否提示
  UIAlertView *saveSuccessAlertView;
}
//截取固定大小屏幕
- (UIImage *)makingScreenShotWithFrame:(CGRect)frame
                              withView:(UIView *)view
                              withType:(NSInteger)shareType;
@end
