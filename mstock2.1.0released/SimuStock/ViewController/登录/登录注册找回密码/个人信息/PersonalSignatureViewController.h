//
//  PersonalSignatureViewController.h
//  SimuStock
//
//  Created by moulin wang on 13-12-2.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonalSignatureViewController
    : BaseViewController <UITextViewDelegate> {
  NSInteger remainderTextNumeber;
}
@property(nonatomic) UITextView *sigNatureText;
@property(nonatomic) UILabel *wordCountLabel;
@property(copy, nonatomic) NSString *sigNatureStr;
- (id)initWithSignature:(NSString *)signature;
@end
