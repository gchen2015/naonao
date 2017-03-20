//
//  IMJIETagView.m
//  TDS
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import "IMJIETagView.h"

@implementation IMJIETagView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
      
        selectedBtnList = [[NSMutableArray alloc] init];
        //选中的背景颜色
        self.clickBackgroundColor = [UIColor colorWithHex:0xE0CEA3];
        //文字颜色
        self.clickTitleColor = [UIColor whiteColor];
        
        self.clickArray = nil;
        //是否可以被选中
        self.clickbool = YES;
        
        self.borderSize = 0.0;
        self.clickborderSize = 0.0;
    }
    return self;
}

- (void)setTagsFrame:(IMJIETagFrame *)tagsFrame{

    _tagsFrame = tagsFrame;
    
    for (NSInteger i = 0; i < tagsFrame.tagsArray.count; i++) {
        
        UIButton *tagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSArray *ta =  [tagsFrame.tagsArray[i] componentsSeparatedByString:@":"];
        
        
        [tagsBtn setTitle:[ta lastObject] forState:UIControlStateNormal];
        [tagsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tagsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        tagsBtn.tag = i;
        tagsBtn.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
        
        //圆角
        tagsBtn.layer.cornerRadius = 3; //设置那个圆角的有多圆
        tagsBtn.layer.masksToBounds = YES;  //设为NO去试试
        
        
        [self makeCorner:self.borderSize view:tagsBtn color:UIColorRGBA(221, 221, 221, 1)];
        tagsBtn.frame = CGRectFromString(tagsFrame.tagsFrames[i]);
        [tagsBtn addTarget:self action:@selector(TagsBtn:) forControlEvents:UIControlEventTouchDown];
        tagsBtn.enabled = _clickbool;
        [self addSubview:tagsBtn];
    }

}

#pragma mark 选中背景颜色
-(void)setClickBackgroundColor:(UIColor *)clickBackgroundColor{

    if (_clickBackgroundColor != clickBackgroundColor) {
        _clickBackgroundColor = clickBackgroundColor;
    }
}

#pragma makr 选中字体颜色
-(void)setClickTitleColor:(UIColor *)clickTitleColor{

    if (_clickTitleColor != clickTitleColor) {
        _clickTitleColor = clickTitleColor;
    }
}

#pragma makr 能否被选中
-(void)setClickbool:(BOOL)clickbool{
    _clickbool = clickbool;
    
}

#pragma makr 未选中边框大小
-(void)setBorderSize:(CGFloat)borderSize{
    
    if (_borderSize!=borderSize) {
        _borderSize = borderSize;
    }
}

#pragma makr 选中边框大小
- (void)setClickborderSize:(CGFloat)clickborderSize{
    if (_clickborderSize!= clickborderSize) {
        _clickborderSize = clickborderSize;
    }
}

#pragma makr 默认选择 单选
-(void)setClickString:(NSString *)clickString{

    if (_clickString != clickString) {
        _clickString = clickString;
    }
    if ([_tagsFrame.tagsArray containsObject:_clickString]) {
        
        NSInteger index = [_tagsFrame.tagsArray indexOfObject:_clickString];
        [self ClickString:index];
    }
}

#pragma mark 默认选择 多选
-(void)setClickArray:(NSArray *)clickArray{

    if (_clickArray != clickArray) {
        _clickArray = clickArray;
    }
    
    for (NSString *string in clickArray) {
        
        if ([_tagsFrame.tagsArray containsObject:string]) {
            
            NSInteger index = [_tagsFrame.tagsArray indexOfObject:string];
            NSString *x = [[NSString alloc] initWithFormat:@"%ld",(long)index];
            [self ClickArray:x];
        }

    }
    
}

#pragma makr 单选
-(void)ClickString:(NSInteger )index{

    UIButton *btn;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)obj;
            if (btn.tag == index){
                //选中
                btn.backgroundColor = PINK_COLOR;
                [btn setTitleColor:_clickTitleColor forState:UIControlStateNormal];
                [self makeCorner:_clickborderSize view:btn color:_clickTitleColor];
                [_delegate IMJIETagView:@[[NSString stringWithFormat:@"%ld",(long)index]]];
                
            }else{
                //未选中
                btn.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
                [self makeCorner:_borderSize view:btn color:_clickTitleColor];
                
            }
        }
    }
}


#pragma mark 多选
-(void)ClickArray:(NSString *)index{

    UIButton *btn;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)obj;
            if (btn.tag == [index integerValue]){
                
                if ([selectedBtnList containsObject:index]) {
                    
                    btn.backgroundColor = PINK_COLOR;
                    [self makeCorner:_borderSize view:btn color:UIColorRGBA(221, 221, 221, 1)];
                    [selectedBtnList removeObject:index];
                    
                    
                }else{
                    
                    btn.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
                    [btn setTitleColor:_clickTitleColor forState:UIControlStateNormal];
                    [self makeCorner:_clickborderSize view:btn color:_clickTitleColor];
                    [selectedBtnList addObject:index];
                    
                }
                
                [_delegate IMJIETagView:selectedBtnList];
            }
        }
    
    }
  
}

- (void)makeCorner:(CGFloat)corner view:(UIView *)view color:(UIColor *)color{
    
    CALayer * fileslayer = [view layer];
    fileslayer.borderColor = [color CGColor];
    fileslayer.borderWidth = corner;
    
}

-(void)TagsBtn:(UIButton *)sender{

    if (self.clickStart == 0) {
    //单选
        [self ClickString:sender.tag];
        
    }else{
    //多选
        NSString *x = [[NSString alloc] initWithFormat:@"%ld",(long)sender.tag];
        [self ClickArray:x];
    }
}

@end
