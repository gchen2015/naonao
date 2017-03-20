//
//  STPhotoImageView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol STPhotoImageViewDelegate <NSObject>

@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;

@end

@interface STPhotoImageView : UIImageView

@property (nonatomic, weak) id <STPhotoImageViewDelegate> tapDelegate;
@property (assign,nonatomic) CGFloat progress;

- (void)addScaleBigTap;
- (void)removeScaleBigTap;

@end

