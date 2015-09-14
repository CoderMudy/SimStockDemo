//
//  UIDevice+IdentifierAddition.h
//  SimuStock
//
//  Created by Mac on 13-8-12.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *类说明：获取蓝牙手机蓝牙地址，并用md5加密
 */
@interface UIDevice (IdentifierAddition)
/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

-(NSString *) uniqueGlobalDeviceIdentifier;

- (NSString *) macaddress;

/** 返回IDFA：广告商计费用的id*/
-(NSString *) idfa;

/** 返回IDFV: 软件商使用的ID*/
-(NSString *) idfv;


@end
