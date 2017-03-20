//
//  STBrowserHeadView.h
//  Naonao
//
//  Created by 刘敏 on 16/6/26.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STBrowserHeadView : UIView

@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, weak) UIButton *delectBtn;

@property (nonatomic, strong) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame setShowType:(STShowImageType)showType;

@end
