//
//  AppointmentView.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppointmentViewDelegate <NSObject>

- (void)didClickOnSureButton:(BOOL)isTure;

@end



@interface AppointmentView : UIView

- (instancetype) initWithTitle:(NSString *)title
                      delegate:(id<AppointmentViewDelegate>)delegate
                       message:(NSString *)message
                  instructions:(NSString *)instructions
               leftButtonTitle:(NSString *)leftTitle
              rightButtonTitle:(NSString *)rightTitle;

- (void)showInView:(UIView *)view;

@end
