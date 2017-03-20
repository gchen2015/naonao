//
//  STLaunchView.m
//  Naonao
//
//  Created by 刘敏 on 16/4/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STLaunchView.h"

@interface STLaunchView ()

@property (assign, nonatomic) int second;

@property (weak, nonatomic) UIImageView *imageA;
@property (weak, nonatomic) UIImageView *imageB;


@end

@implementation STLaunchView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *imageA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_2.png"]];
        _imageA = imageA;
        [_imageA setFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_WIDTH)];
        [self addSubview:_imageA];
        
        
        
        UIImageView *imageB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_1.png"]];
        _imageB = imageB;
        [_imageB setFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_WIDTH)];
        [self addSubview:_imageB];
        
        [self rotatingAnimation];
    }
    
    return self;
}

- (void)begainCountDown {
    self.second = 20;
    
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(nextSecond)];
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    timer.frameInterval = 60;
}

//旋转动画
- (void)rotatingAnimation
{
    /* 旋转 */
    // 对Y轴进行旋转（指定Z轴的话，就和UIView的动画一样绕中心旋转）
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 设定动画选项
    rotationAnimation.duration = 0.6; // 持续时间
    rotationAnimation.repeatCount = 1; // 重复次数
    // 设定旋转角度
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];       // 起始角度
    rotationAnimation.toValue = [NSNumber numberWithFloat:5 * M_PI];    // 终止角度
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    
    [_imageA.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (void)nextSecond {
    self.second --;
//    [self.jumpBtn setTitle:[NSString stringWithFormat:@"跳过(%d)", self.second] forState:UIControlStateNormal];
}

@end
