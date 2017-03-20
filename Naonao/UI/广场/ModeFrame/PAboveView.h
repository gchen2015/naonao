//
//  PAboveView.h
//  Naonao
//
//  Created by Richard Liu on 16/2/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModeFrame.h"
#import "AnswerModeFrame.h"

@class PAboveView;
@protocol PAboveViewDelegate <NSObject>

//购买按钮点击
- (void)pAboveView:(PAboveView *)pView headWithIndex:(NSUInteger)index;

@end

@interface PAboveView : UIView

@property (nonatomic, weak) id<PAboveViewDelegate> delegate;
@property (nonatomic, strong) ProductModeFrame *proFrame;
@property (nonatomic, strong) AnswerModeFrame *anFrame;

@end
