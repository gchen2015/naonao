//
//  MenuScrollView.m
//  Naonao
//
//  Created by 刘敏 on 16/6/20.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MenuScrollView.h"
#import "MenuButton.h"
#import "DemandMenu.h"

const static CGFloat kScrollViewMoveAnimationDuration = 0.5f;

@interface MenuScrollView ()

@property (nonatomic, assign) NSUInteger selectionStage;
@property (nonatomic, strong) NSArray *mArray;

@end


@implementation MenuScrollView

- (instancetype)initWithFrame:(CGRect)frame
                     setArray:(NSArray *)mArray
                          tag:(NSUInteger)selectionStage
{
    if (self = [super initWithFrame:frame]) {
        
        _mArray = mArray;
        _selectionStage = selectionStage;
        [self setBackgroundColor:[UIColor whiteColor]];
        
        for (int i = 0 ; i < mArray.count; i++) {
            sceneModel *model = mArray[i];
            MenuButton *btn = [[MenuButton alloc] initWithFrame:CGRectMake(12+80*i, 0, 68, 82) setTitle:model.name image:model.icon];
            btn.tag = 100+i;
            [btn addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }

    }
    
    return self;
}

- (void)menuTapped:(MenuButton *)sender
{
    sender.selected = YES;
    
    for (int i = 0 ; i<_mArray.count; i++) {
        if (sender.tag != 100+i) {
            MenuButton *btn = (MenuButton *)[self viewWithTag:100+i];
            btn.selected = NO;
        }
    }
    
    if (_mDelegate && [_mDelegate respondsToSelector:@selector(menuScrollView:selectTag:selectionStage:)]) {
        [_mDelegate menuScrollView:self selectTag:sender.tag-100 selectionStage:_selectionStage];
    }
}


- (void)moveToDirection:(DirectionType)direction {
    CGFloat width = CGRectGetWidth(self.frame);
    
    [UIView beginAnimations:@"MoveAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:kScrollViewMoveAnimationDuration];
    
    CGRect rect = self.frame;
    if (direction == kDirectionTypeLeft) {
        rect.origin.x -= width;
    }
    else {
        rect.origin.x += width;
    }
    self.frame = rect;
    
    [UIView commitAnimations];
}


- (void)clearData
{
    for (int i = 0 ; i<_mArray.count; i++) {
        MenuButton *btn = (MenuButton *)[self viewWithTag:100+i];
        btn.selected = NO;
    }
}



@end
