//
//  ORAddressViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/4/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "AddressInfo.h"


@protocol ORAddressViewControllerDelegate <NSObject>

- (void)selectedAddressInfo:(AddressInfo *)addInfo;

@end


@interface ORAddressViewController : STChildViewController

@property (nonatomic, strong) AddressInfo *selectModel;

@property (nonatomic, weak) id<ORAddressViewControllerDelegate> delegate;

@end
