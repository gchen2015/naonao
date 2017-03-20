//
//  STPopupView.h
//  Naonao
//
//  Created by 刘敏 on 16/7/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserCenterViewController;

@interface STPopupView : UIView

@property (nonatomic, strong) IBOutlet UIView *innerView;
@property (nonatomic, weak) UserCenterViewController *parentVC;

@property (nonatomic, strong) NSArray *dataArray;

+ (instancetype)defaultPopupView;

@end
