//
//  UIImage+IF.h
//  STFilterTools
//
//  Created by Richard Liu on 15/5/27.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.


#import <UIKit/UIKit.h>

@interface UIImage (IF)

- (UIImage *)cropImageWithBounds:(CGRect)bounds;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end
