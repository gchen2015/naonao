//
//  PGoodsView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModeFrame.h"
#import "AnswerModeFrame.h"

@class PGoodsView;

@protocol PGoodsViewDelegate <NSObject>

//购买按钮点击
- (void)pGoodsView:(PGoodsView *)pView buttonWithIndex:(NSUInteger)index;

@end

@interface PGoodsView : UIView

@property (nonatomic, weak) id<PGoodsViewDelegate> delegate;

@property (nonatomic, strong) ProductModeFrame *proFrame;
@property (nonatomic, strong) AnswerModeFrame *anFrame;


@end
