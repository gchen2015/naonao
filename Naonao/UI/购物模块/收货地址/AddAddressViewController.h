//
//  AddAddressViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/3/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "AddressInfo.h"

//订单按钮状态
typedef NS_ENUM(NSInteger, mEnter_TYPE){
    K_EDIT_TYPE     = 0,    //编辑
    K_NEW_TYPE      = 1,    //新增地址
};


@interface AddAddressViewController : STChildViewController

@property (nonatomic, strong) AddressInfo *mInfo;

@property (nonatomic, assign) NSUInteger mTYPE;

@end
