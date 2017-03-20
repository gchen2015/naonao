//
//  RatingBar.h
//  Naonao
//
//  Created by Richard Liu on 15/12/10.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingBar : UIView

@property (nonatomic,assign) NSInteger starNumber;

- (instancetype)initWithFrame:(CGRect)frame borderColor:(UIColor *)borderColor;

@end
