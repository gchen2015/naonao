//
//  STBrowserPhotoView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol STBrowserPhotoViewDelegate <NSObject>

@optional

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;

@end



@interface STBrowserPhotoView : UIView

@property (nonatomic, weak) id <STBrowserPhotoViewDelegate> tapDelegate;

@end

