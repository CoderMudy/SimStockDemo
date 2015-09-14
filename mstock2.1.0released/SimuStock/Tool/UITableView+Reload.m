//
//  UITableView+Reload.m
//  SimuStock
//
//  Created by Mac on 15/3/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UITableView+Reload.h"

@implementation UITableView (Reload)

- (void)reloadVisibleRowWithIndexPath:(NSIndexPath *)indexPath {
  __weak UITableView *weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    UITableView *strongSelf = weakSelf;
    if (strongSelf == nil || ![strongSelf isKindOfClass:[UITableView class]]) {
      return;
    }
    NSArray *indexes = [strongSelf indexPathsForVisibleRows];
    for (NSIndexPath *row in indexes) {
      UITableView *strongSelf = weakSelf;

      if (row.section == indexPath.section && row.row == indexPath.row) {
        [strongSelf beginUpdates];
        [strongSelf reloadRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:UITableViewRowAnimationNone];
        [strongSelf endUpdates];
        break;
      }
    }
  });
}

@end
