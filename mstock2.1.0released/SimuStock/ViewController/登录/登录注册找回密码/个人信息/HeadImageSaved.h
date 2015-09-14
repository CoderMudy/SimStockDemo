//
//  HeadImageSaved.h
//  SimuStock
//
//  Created by jhss on 14-10-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeadImageSaved : NSObject
+ (HeadImageSaved *)shareManager;
//图片以文件的形式保存在本地
- (BOOL)setPhotoToPath:(UIImage *)image isName:(NSString *)name;
//删除本地图片
- (BOOL)deleteFromName:(NSString *)name;
@end
