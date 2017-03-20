//
//  STPopBodyView.h
//  Naonao
//
//  Created by 刘敏 on 16/7/7.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STUserInfo.h"

@class UserCenterViewController;

@interface STPopBodyView : UIView

@property (nonatomic, strong) IBOutlet UIView *innerView;
@property (nonatomic, weak) UserCenterViewController *parentVC;
@property (nonatomic, strong) STBodyStyle *body;

+ (instancetype)defaultPopupView;

@end
