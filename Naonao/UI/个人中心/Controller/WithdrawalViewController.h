//
//  WithdrawalViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/5/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"

//第三方登录方式
typedef NS_ENUM(NSInteger, WithdrawalType) {
    KWithdrawal_WX  = 1,            //微信钱包
    KWithdrawal_ZFB,                //支付宝
};


@interface WithdrawalViewController : STChildViewController

@property (nonatomic, assign) WithdrawalType mType;

@end
