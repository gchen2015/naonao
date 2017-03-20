//
//  CouponsViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/3/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "CouponsModel.h"


@protocol CouponsViewControllerDelegate <NSObject>

- (void)updateCouponsUI:(CouponsModel *)cModel;

@end

@interface CouponsViewController : STChildViewController

@property (nonatomic, weak) id<CouponsViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isPAY;    //是否是支付页面

@end
