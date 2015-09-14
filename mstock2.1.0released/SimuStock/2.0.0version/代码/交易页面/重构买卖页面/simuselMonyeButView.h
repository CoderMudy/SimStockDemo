//
//  simuselMonyeButView.h
//  SimuStock
//
//  Created by Mac on 14-7-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol simuselMonyButDelegate <NSObject>

- (void)moneyButtonPressDown:(NSInteger)index;

@end
/*
 *类说明：2万，5万，10万，20万选择按钮小控件
 */
@interface simuselMonyeButView : UIView {
  //所有标签数组
  NSMutableArray *smbv_lableArray;
  //当前选中标签
  NSInteger smbv_corIndexSel;
  //当前最大可选标签
  NSInteger smbv_maxcanIndex;
  //设定当前每个lable的宽度
  float smbv_width;
  //设定当前按钮是否可点击
  BOOL smbv_buttonVasible;
  
  NSMutableArray *buttonArray;
}
@property(assign, nonatomic) NSInteger corIndexSel;
@property(assign, nonatomic) NSInteger maxcanIndex;
@property(weak, nonatomic) id<simuselMonyButDelegate> delegate;
//设定总资金量
- (void)setTotolMoney:(int64_t)totolfund;
//清除所有数据
- (void)clearAllData;

- (void)widthLabel;
@end
