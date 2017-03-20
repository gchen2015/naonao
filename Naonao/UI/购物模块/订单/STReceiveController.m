//
//  STReceiveController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/25.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STReceiveController.h"

@interface STReceiveController ()

@end

@implementation STReceiveController

- (void)viewDidLoad {
    
    //待收货，说明已经支付
    self.orderType = KOrder_PaySuccess;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
