//
//  STToolbar.m
//  Naonao
//
//  Created by 刘敏 on 16/6/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STToolbar.h"

@interface STToolbar()

// 标记View
@property (nonatomic, weak) UILabel *makeView;
// 预览
@property (nonatomic, weak) UIButton *previewBtn;
// 完成
@property (nonatomic, weak) UIButton *doneBtn;

@end


@implementation STToolbar


- (instancetype)initWithFrame:(CGRect)frame isBlack:(BOOL)isBlack{
    self = [super initWithFrame:frame];
    if (self){
        if (isBlack) {
            [self setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.8]];
            [self initBlackView];
        }
        else{
            [self setBackgroundColor:[UIColor whiteColor]];
            [self initView];
        }
        
        self.count = 0;
    }
    
    return self;
}

- (void)initView
{
    //线条
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.3)];
    [lineV setBackgroundColor:[UIColor grayColor]];
    [self addSubview:lineV];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:LIGHT_BLACK_COLOR forState:UIControlStateDisabled];
    leftBtn.enabled = YES;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    leftBtn.frame = CGRectMake(10, 0, 44, 44);
    [leftBtn setTitle:@"预览" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(previewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    self.previewBtn = leftBtn;
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor colorWithHex:0xff6a66] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHex:0xf3c1c3] forState:UIControlStateDisabled];
    rightBtn.enabled = YES;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 54, 0, 44, 44);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(doneTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    self.doneBtn = rightBtn;
    
    
    UILabel *makeView = [[UILabel alloc] init];
    makeView.textColor = [UIColor whiteColor];
    makeView.textAlignment = NSTextAlignmentCenter;
    makeView.font = [UIFont systemFontOfSize:13];
    makeView.frame = CGRectMake(-20, 12, 20, 20);
    makeView.hidden = YES;
    makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
    makeView.clipsToBounds = YES;
    makeView.backgroundColor = [UIColor colorWithHex:0xff6a66];
    [self.doneBtn addSubview:makeView];
    self.makeView = makeView;
    
}


- (void)initBlackView{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor colorWithHex:0xfb2c31] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHex:0xf3c1c3] forState:UIControlStateDisabled];
    rightBtn.enabled = YES;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 54, 0, 44, 44);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(doneTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    self.doneBtn = rightBtn;
    
    
    UILabel *makeView = [[UILabel alloc] init];
    makeView.textColor = [UIColor whiteColor];
    makeView.textAlignment = NSTextAlignmentCenter;
    makeView.font = [UIFont systemFontOfSize:13];
    makeView.frame = CGRectMake(-20, 12, 20, 20);
    makeView.hidden = YES;
    makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
    makeView.clipsToBounds = YES;
    makeView.backgroundColor = [UIColor redColor];
    [self.doneBtn addSubview:makeView];
    self.makeView = makeView;

}


- (void)setCount:(NSUInteger)count {
    _count = count;
    self.previewBtn.enabled = YES;
    self.doneBtn.enabled = YES;
    self.makeView.hidden = !count;
    self.makeView.text = [NSString stringWithFormat:@"%ld",(long)count];
    
    if(count == 0)
    {
        self.previewBtn.enabled = NO;
        self.doneBtn.enabled = NO;
        
    }
}

- (void)previewTapped:(id)sender{
    if (_mDelegate && [_mDelegate respondsToSelector:@selector(previewSelectImages)]) {
        [_mDelegate previewSelectImages];
    }
}

- (void)doneTapped:(id)sender{
    if (_mDelegate && [_mDelegate respondsToSelector:@selector(toolbarBackMainview)]) {
        [_mDelegate toolbarBackMainview];
    }
}



@end
