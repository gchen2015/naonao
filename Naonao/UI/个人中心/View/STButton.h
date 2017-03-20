//
//  STButton.h
//  Naonao
//
//  Created by Richard Liu on 15/12/10.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STButton : UIView

// 初始化
- (id)initWithFrame:(CGRect)frame buttonWithTitle:(NSString *)title countL:(NSUInteger)count;

- (void)setCountLabelText:(NSNumber *)num;

@end
