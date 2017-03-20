//
//  STPublishButton.m
//  Naonao
//
//  Created by 刘敏 on 16/3/15.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STPublishButton.h"

@implementation STPublishButton

#pragma mark -
#pragma mark - Private Methods

//上下结构的 button
- (void)layoutSubviews
{
    [super layoutSubviews];

    //imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.imageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

#pragma mark -
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    
    return self;
}

#pragma mark -
#pragma mark - Public Methods
+ (instancetype)publishButton{
    
    STPublishButton *button = [[STPublishButton alloc] init];
    [button setImage:[UIImage imageNamed:@"tab_icon3_normal"] forState:UIControlStateNormal];
    [button sizeToFit];
    
    return button;
    
}


@end
