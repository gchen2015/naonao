//
//  STPhotoPickerImageView.m
//  Naonao
//
//  Created by 刘敏 on 16/6/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STPhotoPickerImageView.h"


@interface STPhotoPickerImageView ()

@property (nonatomic , weak) UIView *maskView;
@property (nonatomic , weak) UIButton *tickImageView;

@end


@implementation STPhotoPickerImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (UIView *)maskView{
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.frame = self.bounds;
        maskView.backgroundColor = [UIColor whiteColor];
        maskView.alpha = 0.5;
        [self addSubview:maskView];
        self.maskView = maskView;
    }
    return _maskView;
}


- (UIButton *)tickImageView{
    if (!_tickImageView) {
        UIButton *tickImageView = [[UIButton alloc] init];
        tickImageView.frame = CGRectMake(self.bounds.size.width - 26, 0, 26, 26);
        [tickImageView setImage:[UIImage imageNamed:@"icon_image_no.png"] forState:UIControlStateNormal];
        [tickImageView addTarget:self action:@selector(clickTick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tickImageView];
        self.tickImageView = tickImageView;
    }
    
    return _tickImageView;
}

- (void)setMaskViewFlag:(BOOL)maskViewFlag{
    _maskViewFlag = maskViewFlag;
    self.animationRightTick = maskViewFlag;
}

- (void)setMaskViewColor:(UIColor *)maskViewColor{
    _maskViewColor = maskViewColor;
    self.maskView.backgroundColor = maskViewColor;
}

- (void)setMaskViewAlpha:(CGFloat)maskViewAlpha{
    _maskViewAlpha = maskViewAlpha;
    self.maskView.alpha = maskViewAlpha;
}

- (void)setAnimationRightTick:(BOOL)animationRightTick{
    _animationRightTick = animationRightTick;
    
    if (animationRightTick) {
        [self.tickImageView setImage:[UIImage imageNamed:@"icon_image_yes.png"] forState:UIControlStateNormal];
    }
    else{
        [self.tickImageView setImage:[UIImage imageNamed:@"icon_image_no.png"] forState:UIControlStateNormal];
    }
    
    if (!self.isClickHaveAnimation) {
        return;
    }
    
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    

    [self.tickImageView.layer removeAllAnimations];
    [self.tickImageView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];

}

- (void)setIndex:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}


- (void)clickTick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickImageView:selectTapped:)]) {
        [_delegate pickImageView:self selectTapped:_indexPath];
    }
}

@end
