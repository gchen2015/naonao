//
//  FreeButton.h
//  Naonao
//
//  Created by 刘敏 on 16/5/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FreeButtonDelegate <NSObject>

@optional
// 按钮点击事件
- (void)clickFreeButtonTapped;

@end


@interface FreeButton : UIImageView

@property (nonatomic, weak) id<FreeButtonDelegate> delegate;

@end
