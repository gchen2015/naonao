//
//  STPhotoRect.h
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPhotoRect : NSObject

+ (CGRect)setMaxMinZoomScalesForCurrentBoundWithImage:(UIImage *)image;
+ (CGRect)setMaxMinZoomScalesForCurrentBoundWithImageView:(UIImageView *)imageView;

@end
