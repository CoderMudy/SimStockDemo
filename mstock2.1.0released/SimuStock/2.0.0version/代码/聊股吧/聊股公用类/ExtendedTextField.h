//
//  ExtendedTextField.h
//  SimuStock
//
//  Created by Mac on 15-2-25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtendedTextField : UITextField {
  NSInteger textMaxLenth;
}
/** 添加长度限制 */
- (void)setMaxLength:(NSInteger)maxLength;

@end
