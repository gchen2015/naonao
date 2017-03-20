//
//  GoodsCategoryView.h
//  Naonao
//
//  Created by 刘敏 on 16/3/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsCategoryViewDelegate <NSObject>

- (void)jumpToOrderVC;

@end

@interface GoodsCategoryView : UIView

@property (nonatomic, weak) id<GoodsCategoryViewDelegate> delegate;

- (void)updateUI;

@end
