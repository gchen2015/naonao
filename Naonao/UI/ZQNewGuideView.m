//
//  ZQNewGuideView.m
//  新手引导
//
//  Created by zhang on 16/5/21.
//  Copyright © 2016年 zqdreamer. All rights reserved.
//

#import "ZQNewGuideView.h"

#define DEFAULTCORNERRADIUS (5.0f)


@interface ZQNewGuideView ()

@property (strong, nonatomic) UIButton *showRectButton;
@property (strong, nonatomic) UIImageView *textImageView;

@end

@implementation ZQNewGuideView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showRect = self.bounds;
        self.guideColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.68];
        self.fullShow = YES;
        
        self.model = ZQNewGuideViewModeOval;
        
        self.showRectButton = [[UIButton alloc] initWithFrame:CGRectZero];
        self.showRectButton.backgroundColor = [UIColor clearColor];
        [self.showRectButton addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.showRectButton];
        
        self.textImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.textImageView];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)]];
    }
    
    return self;
}


#pragma mark - override
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect frame = [self convertRect:self.bounds toView: self.superview];
    UIImage *fullImage = [self imageFromView:self.superview];
    CGFloat scale = UIScreen.mainScreen.scale;
    UIImage *image = [self imageFromImage:fullImage rect:CGRectMake(frame.origin.x*scale, frame.origin.y*scale, frame.size.width*scale, frame.size.height*scale)];
    [image drawInRect:self.bounds];
    CGContextSetFillColorWithColor(context, self.guideColor.CGColor);
    UIBezierPath *fullPath  = [UIBezierPath bezierPathWithRect:self.bounds];
    
    switch (self.model)
    {
        case ZQNewGuideViewModeOval:
        {
            UIBezierPath *showPath = [UIBezierPath bezierPathWithOvalInRect:self.fullShow?([self ovalFrameScale:self.showRect s:[self ovalDrawScale]]):self.showRect];
            [fullPath appendPath:[showPath bezierPathByReversingPath]];
        }
            break;
        case ZQNewGuideViewModeRoundRect:
        {
            UIBezierPath *showPath = [UIBezierPath bezierPathWithRoundedRect:self.fullShow?([self roundRectScale:self.showRect]):self.showRect cornerRadius:DEFAULTCORNERRADIUS];
            [fullPath appendPath:[showPath bezierPathByReversingPath]];
        }
            break;
        default:
        {
            UIBezierPath *showPath = [UIBezierPath bezierPathWithRect:self.fullShow?([self rectScale:self.showRect]):self.showRect];
            [fullPath appendPath:[showPath bezierPathByReversingPath]];
        }
            break;
    }
    CGContextAddPath(context, fullPath.CGPath);
    CGContextFillPath(context);
    
    self.showRectButton.frame = self.showRect;
    self.textImageView.frame = self.textImageFrame;
}



#pragma mark - event & response
- (void)clickBtn:(UIButton *)btn
{
    if (self.superview != nil) {
        self.showRectButton.frame = CGRectZero;
        self.textImageView.frame = CGRectZero;
        [self removeFromSuperview];
    }
    self.clickedShowRectBlock == nil ? :self.clickedShowRectBlock();
}

- (void)tapBgView:(UITapGestureRecognizer *)gesture
{
    [self removeFromSuperview];
}

#pragma mark - private

- (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)imageFromImage:(UIImage*)image rect:(CGRect)rect
{
    CGImageRef sourceImageRef = image.CGImage;
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage* newImage = [UIImage imageWithCGImage:newImageRef];
    CFRelease(newImageRef);
    return newImage;
}


#pragma mark - getter & setter
- (void)setShowRect:(CGRect)showRect
{
    _showRect = showRect;
    [self setNeedsDisplay];
}

- (void)setTextImage:(UIImage *)textImage
{
    _textImage = textImage;
    self.textImageView.image = textImage;
    [self setNeedsDisplay];
}

- (void)setGuideColor:(UIColor *)guideColor
{
    _guideColor = guideColor;
    [self setNeedsDisplay];
}


- (void)setFullShow:(BOOL)fullShow
{
    _fullShow = fullShow;
    [self setNeedsDisplay];
}


- (void)setModel:(ZQNewGuideViewMode)model
{
    _model = model;
    [self setNeedsDisplay];
}


#pragma mark - 圆角相关
- (CGRect)roundRectScale:(CGRect)rect
{
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGRect newRect = CGRectMake(center.x - width * 0.5 - DEFAULTCORNERRADIUS, center.y - height * 0.5 - DEFAULTCORNERRADIUS, width + DEFAULTCORNERRADIUS * 2.0, height + DEFAULTCORNERRADIUS * 2.0);
    
    return newRect;
}

- (CGRect)rectScale:(CGRect)rect
{
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGRect newRect = CGRectMake(center.x - width * 0.5 - 2.0, center.y - height * 0.5 - 2.0, width + 4.0, height + 4.0);
    
    return newRect;
}

- (CGFloat)ovalDrawScale
{
    CGFloat a = MAX(self.showRect.size.width, self.showRect.size.height);
    CGFloat b = MIN(self.showRect.size.width, self.showRect.size.height);
    CGFloat bigger = (b + sqrt(4.0 * a * a + b * b) - 2 * a)/2.0;
    CGFloat scale = 1.0 + bigger / a;
    return scale;
}


- (CGRect)ovalFrameScale:(CGRect)rect s:(CGFloat)s
{
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGRect newRect = CGRectMake(center.x - width * s * 0.5, center.y - height * s * 0.5, width * s, height * s);
    
    return newRect;
}


@end
