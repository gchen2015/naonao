//
//  UIView+DZNConstraintBasedLayoutExtensions.h
//  Naonao
//
//  Created by 刘敏 on 16/3/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DZNConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view
                                               attribute:(NSLayoutAttribute)attribute;


@end
