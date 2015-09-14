//
//  SendCattleButton.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SendCattleButton.h"

@implementation SendCattleButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  self.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.5f].CGColor;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  [self resetNormal];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  [self resetNormal];
}

- (void)resetNormal {
  self.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.7f].CGColor;
}

@end
