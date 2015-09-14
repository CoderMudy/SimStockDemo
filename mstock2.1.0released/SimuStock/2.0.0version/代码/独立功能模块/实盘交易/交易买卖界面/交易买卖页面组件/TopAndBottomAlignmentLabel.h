//
//  TopAndBottomAlignmentLabel.h
//  SimuStock
//
//  Created by Yuemeng on 14-9-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  VerticalAlignmentTop = 0,  // default
  VerticalAlignmentMiddle,
  VerticalAlignmentBottom,
} VerticalAlignment;

/** 类说明：支持上、下、居中对齐的label */
@interface TopAndBottomAlignmentLabel : UILabel
@property(nonatomic) VerticalAlignment verticalAlignment;
@end
