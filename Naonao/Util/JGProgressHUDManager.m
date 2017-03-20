//
//  JGProgressHUDManager.m
//  Naonao
//
//  Created by Richard Liu on 15/11/25.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "JGProgressHUDManager.h"

@implementation JGProgressHUDManager

- (id)initManager
{
    if(self = [super init]){
        
        _HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
        _HUD.userInteractionEnabled = NO;
        _HUD.delegate = self;
    }
    return self;
}

/**
 *  简单的带文字提示
 *
 *  @param text 文字
 */
- (void)showTip:(NSString *)text
{
    _HUD.textLabel.text = text;
    
    //显示位置
    _HUD.position = JGProgressHUDPositionCenter;
    _HUD.marginInsets = (UIEdgeInsets) {
        .top = 0.0f,
        .bottom = 20.0f,
        .left = 0.0f,
        .right = 0.0f,
    };
    
    [_HUD showInView:theAppDelegate.window];
    
    [_HUD dismissAfterDelay:1.5f];
}


/**
 *  HUD带菊花的系统提示
 *
 *  @param status   类型
 *  @param text     文字描述（可以为空）
 *  @param interval 显示时间
 */
- (void)showSimpleTip:(NSString *)text
             interval:(NSTimeInterval)interval
{
    _HUD.textLabel.text = text;
    [_HUD showInView:theAppDelegate.window];
    
    
    [_HUD dismissAfterDelay:interval];
}


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
                interval:(NSTimeInterval)interval
{
    
    UIImageView *errorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    _HUD.textLabel.text = text;
    JGProgressHUDIndicatorView *ind = [[JGProgressHUDIndicatorView alloc] initWithContentView:errorImageView];
    _HUD.indicatorView = ind;
    
    _HUD.square = YES;
    
    [_HUD showInView:theAppDelegate.window];
    
    [_HUD dismissAfterDelay:interval];
    
}


- (void)hideHUD
{
    [_HUD dismiss];
}




#pragma mark - JGProgressHUDDelegate
- (void)progressHUD:(JGProgressHUD *)progressHUD willPresentInView:(UIView *)view {
    CLog(@"HUD %p will present in view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didPresentInView:(UIView *)view {
    CLog(@"HUD %p did present in view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD willDismissFromView:(UIView *)view {
    CLog(@"HUD %p will dismiss from view: %p", progressHUD, view);
}

- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view {
    CLog(@"HUD %p did dismiss from view: %p", progressHUD, view);
}

@end
