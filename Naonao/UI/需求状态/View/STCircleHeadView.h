//
//  STCircleHeadView.h
//  MeeBra
//
//  Created by Richard Liu on 15/9/23.
//  Copyright © 2015年 广州杉川投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STCircleHeadView;

typedef void (^BeginUpdatingBlock)(STCircleHeadView *);

@interface STCircleHeadView : UIView

@property (nonatomic, strong) BeginUpdatingBlock beginUpdatingBlock;

- (id)initWithFrame:(CGRect)frame backGroudImage:(NSString *)imageName isMask:(BOOL)isMask;

- (void)setHeadImage:(NSString *)imageName;
- (void)setTitle:(NSString *)tit setDes:(NSString *)des;

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset scrollView:(UIScrollView *)scrollView;

@end
