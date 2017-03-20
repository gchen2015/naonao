//
//  LeftMenuView.h
//  Naonao
//
//  Created by 刘敏 on 16/7/25.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareViewController.h"

@protocol LeftMenuViewDelegate <NSObject>

- (void)setHideMenuView;

@end


@interface LeftMenuView : UIView

@property (nonatomic, weak) id<LeftMenuViewDelegate> delegate;

- (void)showView;


@end
