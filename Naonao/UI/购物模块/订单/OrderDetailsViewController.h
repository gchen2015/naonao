//
//  OrderDetailsViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/3/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"

//入口
typedef NS_ENUM(NSInteger, EntranceType){
    KCommom  = 1,       //常规
    KPayment = 2        //支付失败进入
};


@interface OrderDetailsViewController : STChildViewController

@property (nonatomic, copy) NSNumber *orderID;
@property (nonatomic, assign) EntranceType mType;

@end
