//
//  JGProgressHUDManager.h
//  Naonao
//
//  Created by Richard Liu on 15/11/25.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGProgressHUD.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "JGProgressHUDRingIndicatorView.h"
#import "JGProgressHUDFadeZoomAnimation.h"

@interface JGProgressHUDManager : NSObject<JGProgressHUDDelegate>

@property (nonatomic, strong) JGProgressHUD *HUD;


- (id)initManager;

//显示文字提示
- (void)showTip:(NSString *)text;


/**
 *  HUD带菊花的系统提示
 *
 *  @param status   类型
 *  @param text     文字描述（可以为空）
 *  @param interval 显示时间
 */
- (void)showSimpleTip:(NSString *)text
             interval:(NSTimeInterval)interval;




/**
 *  HUD带图片的提示
 *
 *  @param status    类型
 *  @param imageName 图片名字
 *  @param text      文字描述
 *  @param interval  显示时间
 */
- (void)showTipWithImage:(NSString *)imageName
                captions:(NSString *)text
                interval:(NSTimeInterval)interval;



// 隐藏
- (void)hideHUD;

@end
