//
//  MyPropsListCell.m
//  SimuStock
//
//  Created by jhss on 13-9-23.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "MyPropsListCell.h"
#import "Globle.h"
#import "UIImageView+WebCache.h"
#import "MyChestsListWrapper.h"

@implementation MyPropsListCell

- (void)awakeFromNib {
  _grayLineHeight.constant = .5f;
  _whiteLineHeight.constant = .5f;
  _numLabel.layer.borderColor = [Globle colorFromHexRGB:@"e1e1e1"].CGColor;
}

- (void)setData:(MyPropsListItem *)item {
  _nameLabel.text = item.mPboxName;
  _numLabel.text = [NSString stringWithFormat:@"%@", item.mPboxTotal];
  [_icon setImageWithURL:[NSURL URLWithString:item.mPboxPic]
        placeholderImage:[UIImage imageNamed:@"buttonPressDown"]];
  self.usingButton.hidden = [item.mPboxType isEqualToString:@"D050000"];
}

@end
