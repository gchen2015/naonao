//
//  TipView.m
//  Naonao
//
//  Created by 刘敏 on 16/7/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "TipView.h"
#import "DemandMenu.h"
#import "SquareLogic.h"


#define TagButtonSpaceX         15          //间距
#define TagButtonSpaceY         10          //行距
#define LeftToView              22          //左边距
#define TopToView               8           //顶部边距

#define SelectedButtonTag       1000
#define TAG_BTN_H               30.0            //高


@interface TipView ()

@property (nonatomic, strong) NSArray *dataArray;

@end


@implementation TipView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (CGFloat)setTags:(NSArray *)array
{
    _dataArray = array;
    
    NSInteger beginX = LeftToView;
    NSInteger beginY = TopToView;
    
    CGFloat mH = 0.0;
    int i = 0;
    
    //每排放3个，计算按钮的宽度
    CGFloat mW = (CGRectGetWidth(self.frame) - LeftToView*2 - TagButtonSpaceX*2)/3;
    
    for (sceneModel *item in array) {
        NSUInteger m_x = i/3;       //行
        NSUInteger m_y = i%3;       //列
        
        STipButton *btn = [[STipButton alloc] initWithTitle:item.name frame:CGRectMake(beginX+(mW+TagButtonSpaceX)*m_y, beginY+(TAG_BTN_H+TagButtonSpaceY)*m_x, mW, TAG_BTN_H)];
        btn.tag = SelectedButtonTag+i;
        [btn addTarget:self action:@selector(selectedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        mH = CGRectGetMaxY(btn.frame) +20;
        i++;
    }
    
    return mH;
}

- (void)selectedButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    //更改界面
    for (NSUInteger i = 0; i<_dataArray.count; i++) {
        STipButton *btn = (STipButton *)[self viewWithTag:i+SelectedButtonTag];
        if (btn.tag!= sender.tag) {
            btn.selected = NO;
        }
        else{
            if (!sender.selected) {
                [self clearData];
            }
            else{
                sceneModel *sMode = _dataArray[i];
                [self addSkuMenuData:sMode];
            }
        }
    }
    //重新绘制界面
    [self setNeedsDisplay];
}

//还原（重置）
- (void)reductionTipView {
    //更改界面
    for (NSUInteger i = 0; i<_dataArray.count; i++) {
        STipButton *btn = (STipButton *)[self viewWithTag:i+SelectedButtonTag];
        btn.selected = NO;
    }
    
    //重新绘制界面
    [self setNeedsDisplay];
}

- (void)clearData{
    FilterData *fData = [SquareLogic sharedInstance].fData;
    if (_index == 0) {
        fData.category = nil;
    }
    if (_index == 1) {
        fData.scene = nil;
    }
    if (_index == 2) {
        fData.style = nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_FILTER_CONDITIONS" object:nil];
}

//储存选中的数据
- (void)addSkuMenuData:(sceneModel *)item {
    FilterData *fData = [SquareLogic sharedInstance].fData;
    if (_index == 0) {
        fData.category = item.mId;
    }
    if (_index == 1) {
        fData.scene = item.mId;
    }
    if (_index == 2) {
        fData.style = item.mId;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_FILTER_CONDITIONS" object:nil];
}


@end


@implementation STipButton

- (instancetype)initWithTitle:(NSString *)title
                        frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        //圆角
        self.layer.borderColor = BLACK_COLOR.CGColor;
        self.layer.borderWidth = 0.6;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.layer.borderColor = PINK_COLOR.CGColor;
        [self setBackgroundColor:PINK_COLOR];
    }
    else
    {
        self.layer.borderColor = BLACK_COLOR.CGColor;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    [super setSelected:selected];
}


@end
