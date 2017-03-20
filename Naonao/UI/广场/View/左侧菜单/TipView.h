//
//  TipView.h
//  Naonao
//
//  Created by 刘敏 on 16/7/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipView : UIView

@property (nonatomic, assign) NSUInteger index;

- (CGFloat)setTags:(NSArray *)array;
//还原（重置）
- (void)reductionTipView;

@end


@interface STipButton : UIButton

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame;

@end