//
//  LXActionSheet.h
//  LXActionSheetDemo
//
//
//  Created by 刘敏 on 14-7-31.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXActionSheet;
@protocol LXActionSheetDelegate <NSObject>
- (void)actionSheet:(LXActionSheet *)mActionSheet didClickOnButtonIndex:(int)buttonIndex;

@optional
- (void)didClickOnDestructiveButton;
- (void)didClickOnCancelButton;
@end

@interface LXActionSheet : UIView
- (id)initWithTitle:(NSString *)title delegate:(id<LXActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;
- (void)showInView:(UIView *)view;

@end
