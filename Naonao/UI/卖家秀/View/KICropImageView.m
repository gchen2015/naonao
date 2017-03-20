//
//  KICropImageView.m
//  Artery
//
//  Created by 刘敏 on 15/1/10.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//  注意：图片统一按1280*1280来裁剪

#import "KICropImageView.h"
#import "UIImage+UIImageScale.h"

#define TOP_HEIGHT 0

@implementation KICropImageView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [[self scrollView] setFrame:self.bounds];
    
    if (CGSizeEqualToSize(_cropSize, CGSizeZero)) {
        [self setCropSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [[self scrollView] addSubview:_imageView];
    }
    return _imageView;
}

- (void)setImage:(UIImage *)image {
    if (image != _image) {
        [_image release];
        _image = nil;
        _image = [image retain];
    }
    [[self imageView] setImage:_image];
    
    [self updateZoomScale];
}

/*****更新缩放系数****/
- (void)updateZoomScale {
    
    _scrollView.scrollEnabled = YES;
    
    [[self scrollView] setUserInteractionEnabled:YES];

    CLog(@"图片的宽度跟高度：%02f, %02f", _image.size.width, _image.size.height);
    
    CGFloat m_zoom = 0.0;
    //宽度大于高度,以最短的边做填充
    if(_image.size.width > _image.size.height && _image.size.height > 0)
    {
        //缩放系数
        m_zoom = SCREEN_WIDTH/_image.size.height;
        [[self imageView] setFrame:CGRectMake(0, 0, _image.size.width*m_zoom, SCREEN_WIDTH)];
    }
    
    if (_image.size.height > _image.size.width && _image.size.width > 0) {
        //缩放系数
        m_zoom = SCREEN_WIDTH/_image.size.width;
        [[self imageView] setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _image.size.height*m_zoom)];
    }
    
    if (_image.size.height == _image.size.width && _image.size.height > 0) {
        [[self imageView] setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    }

    CGFloat width = _image.size.width/2;
    CGFloat height = _image.size.height/2;
    
    
    CGFloat xScale = _cropSize.width / width;
    CGFloat yScale = _cropSize.height / height;
    
    CGFloat min = 1.0;
    CGFloat max = MAX(xScale, yScale);
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        max = 1.0 / [[UIScreen mainScreen] scale];
    }
    
    if (min > max) {
        max = min;
    }
    
    [[self scrollView] setMinimumZoomScale:min];
    [[self scrollView] setMaximumZoomScale:max + 1.0f];
    
    [[self scrollView] setZoomScale:max animated:YES];
    
    
}


/*****照片填充****/
- (void)photoFilling
{
    _scrollView.scrollEnabled = NO;
    [[self scrollView] setUserInteractionEnabled:NO];

    
    [[self scrollView] setContentOffset:CGPointMake(0, -TOP_HEIGHT)];
    
    CLog(@"图片的宽度跟高度：%02f, %02f", _image.size.width, _image.size.height);
    
    CGFloat m_zoom = 0.0;
    //宽度大于高度,以最短的边做填充
    if(_image.size.width > _image.size.height && _image.size.height > 0)
    {
        //缩放系数
        m_zoom = SCREEN_WIDTH/_image.size.width;
        CGFloat m_difference = (SCREEN_WIDTH -_image.size.height*m_zoom)/2;
        [[self imageView] setFrame:CGRectMake(0, m_difference, SCREEN_WIDTH, _image.size.height*m_zoom)];
    }
    
    if (_image.size.height > _image.size.width && _image.size.width > 0) {
        //缩放系数
        m_zoom = SCREEN_WIDTH/_image.size.height;
        CGFloat m_difference = (SCREEN_WIDTH -_image.size.width*m_zoom)/2;
        [[self imageView] setFrame:CGRectMake(m_difference, 0, _image.size.width*m_zoom, SCREEN_WIDTH)];
    }
    
    if (_image.size.height == _image.size.width && _image.size.height > 0) {
        [[self imageView] setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    
}


- (void)setCropSize:(CGSize)size {
    _cropSize = size;
    
    [self updateZoomScale];
    
    CGFloat width = _cropSize.width;
    CGFloat height = _cropSize.height;
    
    CGFloat x = (CGRectGetWidth(MAINSCREEN) - width) / 2;
    
    CGFloat top = TOP_HEIGHT;
    CGFloat left = x;
    CGFloat right = CGRectGetWidth(MAINSCREEN)- width - x;
    CGFloat bottom = CGRectGetHeight(MAINSCREEN)- height - top - 44;
    _imageInset = UIEdgeInsetsMake(top, left, bottom, right);
    
    //设置scrollView滚动区域
    [[self scrollView] setContentInset:_imageInset];
    
    [[self scrollView] setContentOffset:CGPointMake(0, 0)];
}


//裁剪图片
- (UIImage *)cropImage
{
    /**
     *  图片裁剪
     *
     *  @param SCREEN_WIDTH 屏幕宽度
     *
     *  @return 返回裁剪后的图片
     */
    CGSize msize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH+TOP_HEIGHT);
    
    // 缩放比例（高清分辨率为2倍， iPhone 6 Plus 为3x）
    UIGraphicsBeginImageContextWithOptions(msize, NO, 4.0);

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    CLog(@"%f, %f", viewImage.size.width, viewImage.size.height);

    
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    
    //二次裁剪（这里可以设置想要截图的区域）
    CGRect rect = CGRectMake(0, TOP_HEIGHT*4, 1500, 1500);
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    UIImage *imageA = [[UIImage alloc] scaleWithImage:image size:CGSizeMake(1280, 1280)];
    
    CLog(@"%f, %f", imageA.size.width, imageA.size.height);
    
    return imageA;
}

#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self imageView];
}

- (void)dealloc {
    [_scrollView release];
    _scrollView = nil;
    [_imageView release];
    _imageView = nil;
    [_image release];
    _image = nil;
    [super dealloc];
}


@end
