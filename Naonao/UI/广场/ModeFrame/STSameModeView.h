//
//  STSameModeView.h
//  Naonao
//
//  Created by 刘敏 on 16/4/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareModel.h"


typedef void (^STSameModeViewClickBlock)(SameModel *result);

@interface STSameModeView : UIView

@property (nonatomic, copy) STSameModeViewClickBlock clickBlock;

- (void)setInfo:(SameModel *)sMode;

- (void)sameModeViewClick:(STSameModeViewClickBlock)block;

@end
