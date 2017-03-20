//
//  LMButton.m
//  Naonao
//
//  Created by Richard Liu on 16/1/22.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "LMButton.h"

@interface LMButton ()

@property (nonatomic, weak) UIImageView *maskView;

@end

@implementation LMButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame))];
        _maskView = maskView;
        [_maskView setImage:[UIImage imageNamed:@"btn_yellow_single.png"]];
        [self addSubview:_maskView];
        [_maskView setHidden:YES];
        
        //圆角
        self.layer.cornerRadius = CGRectGetHeight(frame)/2; //设置那个圆角的有多圆
        self.layer.masksToBounds = YES;  //设为NO去试试
        
    }
    
    return self;
}

- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    //选中
    if (selected) {
        [_maskView setHidden:NO];
    }
    else
        [_maskView setHidden:YES];
}


@end
