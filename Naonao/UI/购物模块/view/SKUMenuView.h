//
//  SKUMenuView.h
//  Naonao
//
//  Created by 刘敏 on 16/3/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKUData.h"


@protocol SKUMenuViewDelegate <NSObject>
//SKU按钮点击
- (void)skuButtonTapped;

@end

@interface SKUMenuView : UIView

@property (nonatomic, weak) id<SKUMenuViewDelegate> delegate;

- (CGFloat)setMenuWithskuMenuData:(skuMenuData *)mData;

@end
