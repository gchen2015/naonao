//
//  SKUTagView.h
//  Naonao
//
//  Created by 刘敏 on 16/3/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKUData.h"

@protocol SKUTagViewDelegate <NSObject>
//SKU按钮点击
- (void)skuTapped;

@end


@interface SKUTagView : UIView

@property (nonatomic, weak) id<SKUTagViewDelegate> delegate;

- (CGFloat)setTags:(skuMenuData *)mData;

@end


@interface SKUTagButton : UIButton

- (instancetype)initWithTitle:(NSString *)title
                        frame:(CGRect)frame;

@end