//
//  UIButton+VVShop.m
//  VVShop
//
//  Created by sunlin on 15/6/1.
//  Copyright (c) 2015年 xuantenghuaxing. All rights reserved.
//

#import "UIButton+VVShop.h"

#define BUTTON_DISABLE_TEXT_COLOR [UIColor colorWithRed:160.0f/255.0f green:160.0f/255.0f blue:160.0f/255.0f alpha:1.0f]

const static CGFloat kViewCommonCornerRadius = 4.0f;
const static CGFloat kHandwrittingButtonFontSize = 20.0f;

@implementation UIButton(VVShop)

- (void)setBackgroundImage:(UIImage*)image capInsets:(UIEdgeInsets)insets {
    UIImage* stretchImage = [image resizableImageWithCapInsets:insets];
    [self setBackgroundImage:stretchImage forState:UIControlStateNormal];
    [self setBackgroundImage:stretchImage forState:UIControlStateDisabled];
}

- (void)setBackgroundImage:(UIImage*)image capInsets:(UIEdgeInsets)insets forState:(UIControlState)state {
    UIImage* stretchImage = [image resizableImageWithCapInsets:insets];
    [self setBackgroundImage:stretchImage forState:state];
}

- (void)makeVVShopButtonAppearance {
    UIImage* disableImage = [Units imageWithColor:PUBLISH_BUTTON_DISABLE_COLOR
                                              size:self.frame.size];
    UIImage* normalImage = [Units imageWithColor:NAVI_BAR_COLOR
                                             size:self.frame.size];
    [self setBackgroundImage:disableImage forState:UIControlStateDisabled];
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    self.layer.cornerRadius = kViewCommonCornerRadius;
    self.clipsToBounds = YES;
}

- (void)makeNaoNaoButtonAppearance {
    UIImage* disableImage = [Units imageWithColor:NN_BUTTON_HIGHLIGHT_COLOR
                                                size:self.frame.size];
    UIImage* normalImage = [Units imageWithColor:[UIColor blackColor]
                                               size:self.frame.size];

    self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.adjustsImageWhenHighlighted = NO;
    [self setBackgroundImage:normalImage  forState:UIControlStateNormal];
    [self setBackgroundImage:disableImage forState:UIControlStateHighlighted];
    self.clipsToBounds = YES;
}

- (void)setButtonEnabledNoAnimation:(BOOL)enabled {
    [UIView setAnimationsEnabled:NO];
    self.enabled = enabled;
    [self layoutIfNeeded];
    [UIView setAnimationsEnabled:YES];
}


- (void)customHandwrittingAppearanceWithTitle:(NSString*)title {
    NSDictionary* dict = @{NSFontAttributeName:[UIFont systemFontOfSize:kHandwrittingButtonFontSize],
                           NSForegroundColorAttributeName: [UIColor blackColor]};
    NSDictionary* disableDict = @{NSFontAttributeName : [UIFont systemFontOfSize:kHandwrittingButtonFontSize],
                                  NSForegroundColorAttributeName: BUTTON_DISABLE_TEXT_COLOR};
    NSAttributedString* titleStr = [[NSMutableAttributedString alloc] initWithString:title
                                                                          attributes:dict];
    NSAttributedString* disableTitleStr = [[NSMutableAttributedString alloc] initWithString:title
                                                                                 attributes:disableDict];
    [self setAttributedTitle:titleStr forState:UIControlStateNormal];
    [self setAttributedTitle:disableTitleStr forState:UIControlStateDisabled];
}

@end
