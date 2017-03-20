//
//  BaseTextViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/4/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "DaiDodgeKeyboard.h"


@interface BaseTextViewController : STChildViewController<UITextFieldDelegate>

@property (nonatomic, strong) RegisterParam* reParam;

- (void)initToolBar;

- (UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder;
- (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color;
- (UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;
@end
