//
//  PageScrollView.h
//  LoveFreshBeen_OC
//
//  Created by 天空之城 on 16/3/4.
//  Copyright © 2016年 天空之城. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageScrollView;
@protocol PageScrollViewDelegate <NSObject>

- (void)pageScollView:(PageScrollView *)pageScrollView imageViewClicked:(NSUInteger)mRow;

@end

@interface PageScrollView : UIView

@property (nonatomic, weak) id<PageScrollViewDelegate> delegate;

+ (instancetype)pageScollView:(NSArray *)images placeHolder:(UIImage *)placeHolderImage;

@end




