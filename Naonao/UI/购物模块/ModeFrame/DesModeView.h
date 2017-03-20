//
//  DesModeView.h
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesModeFrame.h"

@class DesModeView;
@protocol DesModeViewDelegate <NSObject>

- (void)desModeView:(DesModeView *)desModeView updateUI:(BOOL)isLeft;

@end

@interface DesModeView : UIView

@property (nonatomic, weak) id<DesModeViewDelegate> delegate;

@property (nonatomic, assign) BOOL isLeft;

@property (nonatomic, strong) DesModeFrame *desFrame;

@end


@interface STMenuBtn : UIButton

- (instancetype)initWithFrame:(CGRect)frame
                     setTitle:(NSString *)tit
                  normalImage:(NSString *)imageN
                selectedImage:(NSString *)imageS;

@end
