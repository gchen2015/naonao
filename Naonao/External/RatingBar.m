//
//  RatingBar.m
//  Naonao
//
//  Created by Richard Liu on 15/12/10.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//


#import "RatingBar.h"

@interface RatingBar ()

@property (nonatomic, strong) UIColor *fillColor;    //填充颜色

@end

@implementation RatingBar

- (instancetype)initWithFrame:(CGRect)frame borderColor:(UIColor *)borderColor;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _fillColor = borderColor;
        
        for(int i = 0; i<5; i++){
            UILabel *mL = [[UILabel alloc] initWithFrame:CGRectMake(0+9*i, 6, 6, 6)];
            [mL setTag:1000+i];
            [mL setBackgroundColor:[UIColor whiteColor]];
            //圆角
            mL.layer.cornerRadius = 3; //设置那个圆角的有多圆
            mL.layer.masksToBounds = YES;  //设为NO去试试
            mL.layer.borderColor = borderColor.CGColor;
            mL.layer.borderWidth = 0.5;

            [self addSubview:mL];
        }
    }
    return self;
}


- (void)setStarNumber:(NSInteger)starNumber{
    
    if (starNumber == 0) {
        return;
    }
    
    for (int i = 0; i < starNumber; i++) {
        UILabel *lA = (UILabel *)[self viewWithTag:1000+i];
        if (lA) {
            [lA setBackgroundColor:_fillColor];
        }
    }
}


@end
