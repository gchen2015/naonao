//
//  SKUTagView.m
//  Naonao
//
//  Created by 刘敏 on 16/3/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SKUTagView.h"
#import "ShoppingLogic.h"

#define TagButtonSpaceX         15          //间距
#define TagButtonSpaceY         10          //行距

#define LeftToView              14          //左边距
#define RightToView             14          //右边距
#define TopToView               6           //顶部边距

#define SelectedButtonTag       1000

#define TAG_BTN_H               30.0

@interface SKUTagView ()

@property (nonatomic, strong) skuMenuData *sData;

@end


@implementation SKUTagView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (CGFloat)setTags:(skuMenuData *)mData
{
    _sData = mData;
    
    NSInteger beginX = LeftToView;
    NSInteger beginY = TopToView;
    
    CGFloat mH = 0.0;
    
    int i = 0;
    
    for (NSString *item in _sData.skuArray) {
        SKUTagButton *btn = [[SKUTagButton alloc] initWithTitle:item frame:CGRectMake(beginX, beginY, 0, TAG_BTN_H)];
        btn.tag = SelectedButtonTag+i;
        
        if (CGRectGetMaxX(btn.frame) + TagButtonSpaceX > (self.frame.size.width - RightToView)) {
            beginX = LeftToView;
            beginY += CGRectGetHeight(btn.frame) + TagButtonSpaceY;
            CGRect rect = btn.frame;
            rect.origin.x = beginX;
            rect.origin.y = beginY;
            btn.frame = rect;
        }
        
        beginX = TagButtonSpaceX + CGRectGetMaxX(btn.frame);
        [btn addTarget:self action:@selector(selectedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (_sData.skuArray.count == 1) {
            [btn setSelected:YES];
            //添加
            [self addSkuMenuData:item];
        }
        
        mH = CGRectGetMaxY(btn.frame) +20;
        i++;
    }
    
    return mH;
}


- (void)selectedButtonClicked:(SKUTagButton *)button{
    button.selected = YES;
    //更改界面
    for (NSUInteger i = 0; i<_sData.skuArray.count; i++) {
        SKUTagButton *btn = (SKUTagButton *)[self viewWithTag:i+SelectedButtonTag];
        if (btn.tag!= button.tag) {
            btn.selected = NO;
        }
    }
    
    [self addSkuMenuData:button.titleLabel.text];
    //重新绘制界面
    [self setNeedsDisplay];
}


- (void)addSkuMenuData:(NSString *)item
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:item forKey:_sData.name];
    //添加到临时数据
    [[ShoppingLogic sharedInstance] addSomethingWithDict:dict];
    
    //TODO:更新价格：以SKU价格为准
    if (_delegate && [_delegate respondsToSelector:@selector(skuTapped)]) {
        [_delegate skuTapped];
    }
}


@end



@implementation SKUTagButton

- (instancetype)initWithTitle:(NSString *)title
                        frame:(CGRect)frame
{
    if (self = [super init])
    {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        //按钮颜色
        [self setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"ST_btn_6.png"] forState:UIControlStateSelected];
        
        frame.size.width = [self getLabelWidthWithText:title allowHeight:30] + 30;
        self.frame = frame;
        
    }
    return self;
}


// 根据label的内容自动算高度
- (CGFloat)getLabelWidthWithText:(NSString *)text
                     allowHeight:(CGFloat)height
{
    CGFloat width;
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(2000, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                     context:nil];
    width = rect.size.width;
    
    return width;
}

@end
