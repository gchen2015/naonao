//
//  MenuButton.m
//  Naonao
//
//  Created by 刘敏 on 16/6/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MenuButton.h"

@interface MenuButton ()

@property (nonatomic, weak) UIImageView *iconV;
@property (nonatomic, weak) UILabel *titLabel;

@end


@implementation MenuButton

- (instancetype)initWithFrame:(CGRect)frame
                     setTitle:(NSString *)tit
                        image:(NSString *)imageN
{
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 60, 54)];
        _iconV = iconV;
        [_iconV setImage:[UIImage imageNamed:imageN]];
        //填充方式
        [_iconV setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_iconV];
        
        //标题
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 68, 20)];
        _titLabel = titLabel;
        [_titLabel setText:tit];
        [_titLabel setTextAlignment:NSTextAlignmentCenter];
        [_titLabel setTextColor:[UIColor whiteColor]];
        [_titLabel setBackgroundColor:[UIColor colorWithHex:0x595858]];
        [_titLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self addSubview:_titLabel];
        
        //圆角
        self.layer.borderColor = [UIColor colorWithHex:0x595858].CGColor;
        self.layer.borderWidth = 0.6;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        [_titLabel setBackgroundColor:GOLDEN_YELLOW];
        [_iconV setHighlighted:YES];
        self.layer.borderColor = GOLDEN_YELLOW.CGColor;
    }
    else
    {
        [_titLabel setBackgroundColor:[UIColor colorWithHex:0x595858]];
        self.layer.borderColor = [UIColor colorWithHex:0x595858].CGColor;
    }
    
    [super setSelected:selected];
}

@end
