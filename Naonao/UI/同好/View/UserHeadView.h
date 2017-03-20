//
//  UserHeadView.h
//  Naonao
//
//  Created by 刘敏 on 16/4/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STUserInfo.h"

@class UserHeadView;

@protocol UserHeadViewDelegate <NSObject>

@optional

- (void)updateUserHeadView;

- (void)userHeadView:(UserHeadView *)mView indexWithBtn:(NSUInteger)index;

@end

@interface UserHeadView : UIView

@property (nonatomic, weak) id<UserHeadViewDelegate> delegate;

+ (instancetype)personalHeaderViewWithCGSize:(CGSize)headerSize;

- (void)updateUI:(STUserInfo *)userInfo;


@end
