//
//  STButton.m
//  Naonao
//
//  Created by Richard Liu on 15/12/10.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STButton.h"


@interface STButton ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *countLabel;

@end

@implementation STButton

// 初始化
- (id)initWithFrame:(CGRect)frame buttonWithTitle:(NSString *)title countL:(NSUInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat btnW = SCREEN_WIDTH/3;

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, btnW, 21)];
        _titleLabel = titleLabel;
        _titleLabel.text = title;
        _titleLabel.textColor = BLACK_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, btnW, 30)];
        _countLabel = countLabel;
        _countLabel.text = [NSString stringWithFormat:@"%ld", count];
        _countLabel.textColor = BLACK_COLOR;
        _countLabel.font = [UIFont fontWithName:kAkzidenzGroteskBQ size:28.0];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_countLabel];
    }
    
    return self;
}

- (void)setCountLabelText:(NSNumber *)num {
    [_countLabel setText:[NSString stringWithFormat:@"%@", num]];
}

    
@end