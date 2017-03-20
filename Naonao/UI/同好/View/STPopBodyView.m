//
//  STPopBodyView.m
//  Naonao
//
//  Created by 刘敏 on 16/7/7.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STPopBodyView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "UserCenterViewController.h"

@interface STPopBodyView ()

@property (nonatomic, weak) IBOutlet UILabel * lA;      //体型
@property (nonatomic, weak) IBOutlet UILabel * lB;      //体型描述
@property (nonatomic, weak) IBOutlet UILabel * lC;      //身高
@property (nonatomic, weak) IBOutlet UILabel * lD;      //体重
@property (nonatomic, weak) IBOutlet UILabel * lE;      //鞋码
@property (nonatomic, weak) IBOutlet UILabel * lF;      //胸围
@property (nonatomic, weak) IBOutlet UILabel * lG;      //腰围
@property (nonatomic, weak) IBOutlet UILabel * lH;      //臀围

@end

@implementation STPopBodyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
        
        //圆角
        _innerView.layer.cornerRadius = 6;                     //设置那个圆角的有多圆
        _innerView.layer.masksToBounds = YES;                  //设为NO去试试
        _innerView.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
        _innerView.layer.borderWidth = 0.5;
        
    }
    return self;
}

- (void)setBody:(STBodyStyle *)body {
    _body = body;
    
    [_lA setText:_body.style];
    
    [_lB setTextAlignment:NSTextAlignmentRight];
    
    if ([_body.style isEqualToString:@"矩型"]) {
        [_lB setText:@"身体呈长方形，胸、腰、臀部曲线不明显"];
    }
    
    if ([_body.style isEqualToString:@"沙漏型"]) {
        [_lB setText:@"骨架娇小，肉多却不显胖，胸、腰、臀部线条明显"];
    }
    if ([_body.style isEqualToString:@"梨型"]) {
        [_lB setText:@"上半身较瘦，下半身臀部、腿部肉较多"];
    }
    if ([_body.style isEqualToString:@"倒三角形"]) {
        [_lB setText:@"肩膀较宽，臀部较窄，腿部纤细，呈倒三角形"];
    }
    if ([_body.style isEqualToString:@"苹果型"]) {
        [_lB setText:@"上身丰腴浑圆，双腿较为纤细"];
    }
    
    //身高
    [_lC setText:[NSString stringWithFormat:@"%@cm", _body.height]];
    
    //体重
    [_lD setText:[NSString stringWithFormat:@"%@kg", _body.weight]];
    
    
    //鞋码
    [_lE setText:[NSString stringWithFormat:@"%@", _body.shoes]];
    
    
    //胸围
    [_lF setText:[NSString stringWithFormat:@"%@", _body.bust]];
    
    
    //腰围
    [_lG setText:[NSString stringWithFormat:@"%@cm", _body.waistline]];
    
    //臀围
    [_lH setText:[NSString stringWithFormat:@"%@cm", _body.hipline]];
}

+ (instancetype)defaultPopupView{
    return [[STPopBodyView alloc]initWithFrame:CGRectMake(0, 0, 280, 168)];
}

- (IBAction)closeBtnTapped:(id)sender{
    [_parentVC lew_dismissPopupView];
}

@end
