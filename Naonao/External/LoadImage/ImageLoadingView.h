//
//  ImageLoadingView.h
//  Shitan
//
//  Created by RichardLiu on 15/3/18.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinProgress 0.0001


@interface ImageLoadingView : UIView

@property (nonatomic) float progress;

- (void)showLoading;
- (void)showFailure;

@end
