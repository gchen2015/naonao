//
//  UILabel+Extension.m
//  半塘
//
//  Created by Candy on 15/11/19.
//  Copyright © 2015年 汪汉琦. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

-(instancetype)initWithTitle:(NSString *)title textColor:(UIColor *)textColor
{
    self = [super init];
    if (self) {
        self.text = title;
        self.textColor = textColor;
    }
    return self;
}

@end
