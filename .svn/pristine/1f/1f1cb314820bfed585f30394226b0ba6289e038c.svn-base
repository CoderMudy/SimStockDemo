//
//  LittleCattleView.h
//  SimuStock
//
//  Created by Yuemeng on 14-10-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**小牛图标加文字(贱笑牛或泪奔牛)*/
@interface LittleCattleView : UIView

@property(nonatomic) BOOL isCry;
/**⭐️默认是贱笑牛（无持仓）。通过方法isCry:(BOOL)切换小牛视图和文字。information可以传nil*/
- (id)initWithFrame:(CGRect)frame information:(NSString*)information;
/**输入YES显示为泪奔牛(无网络），NO为贱笑牛（无持仓）。文字自动替换，且自定义文字会被保存*/
- (void)isCry:(BOOL)isCry;
/**修改贱笑牛文字信息*/
- (void)setInformation:(NSString*)information;
/**修改贱笑牛文字信息*/
- (void)setInformation:(NSString*)information detailInfo:(NSString*)detailInfo;
/**重新设置小牛的位置*/
- (void)resetFrame:(CGRect)frame;
/** 重设小牛高度 */
- (void)resetOffsetY:(CGFloat)offsetY;
/** 显示哭牛及提示内容 */
- (void)showCryCattleWithContent:(NSString*)content;

/** 无数据小牛 */
- (void)isNOData:(NSString*)noData;


/** 从新设置 小牛和文字位置 */
-(void)resetCryInformationFrame;


@end
