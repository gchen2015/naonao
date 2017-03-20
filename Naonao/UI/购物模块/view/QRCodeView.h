//
//  QRCodeView.h
//  Naonao
//
//  Created by 刘敏 on 16/8/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponsViewController;

@interface QRCodeView : UIView

@property (nonatomic, strong) IBOutlet UIView *innerView;
@property (nonatomic, weak) CouponsViewController *parentVC;

@property (nonatomic, strong) NSNumber *couponId;

+ (instancetype)defaultPopupView;

@end
