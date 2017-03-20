//
//  SKUHeadView.h
//  Naonao
//
//  Created by 刘敏 on 16/3/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class skuDesData;
@interface SKUHeadView : UIView

@property (nonatomic, weak) UIImageView *headV;

//更新UI
- (void)updateUIMessage:(skuDesData *)pdata;

@end
