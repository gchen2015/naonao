//
//  STToolbar.h
//  Naonao
//
//  Created by 刘敏 on 16/6/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol STToolbarDelegate <NSObject>

@optional

- (void)toolbarBackMainview;
- (void)previewSelectImages;

@end

@interface STToolbar : UIView

@property (nonatomic, weak) id<STToolbarDelegate> mDelegate;

@property (nonatomic, assign) NSUInteger count;

- (instancetype)initWithFrame:(CGRect)frame isBlack:(BOOL)isBlack;

@end
