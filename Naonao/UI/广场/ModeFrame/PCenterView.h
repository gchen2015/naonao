//
//  PCenterView.h
//  Naonao
//
//  Created by Richard Liu on 16/2/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModeFrame.h"
#import "AnswerModeFrame.h"

@class PCenterView;
@protocol PCenterViewDelegate <NSObject>

- (void)pCenterView:(PCenterView *)mView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imageArray:(NSArray *)images;

@end

@interface PCenterView : UIView

@property (nonatomic, weak) id<PCenterViewDelegate> delegate;

@property (nonatomic, strong) ProductModeFrame *proFrame;
@property (nonatomic, strong) AnswerModeFrame *anFrame;

@end
