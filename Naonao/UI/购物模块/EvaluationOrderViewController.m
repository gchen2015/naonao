//
//  EvaluationOrderViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/4/8.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "EvaluationOrderViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BRPlaceholderTextView.h"
#import "HCSStarRatingView.h"
#import "ShoppingLogic.h"


@interface EvaluationOrderViewController ()<UITextViewDelegate>

@property (nonatomic, weak) BRPlaceholderTextView *textView;

@property (nonatomic, assign) CGFloat body_match;    //身材
@property (nonatomic, assign) CGFloat style_match;   //风格

@end



@implementation EvaluationOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"发表评价"];
    [self.view setBackgroundColor:BACKGROUND_GARY_COLOR];
    
    [self initUI];
}

- (void)initUI{
    
    UIView *firstV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame), SCREEN_WIDTH, 140)];
    [firstV setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:firstV];
    
    SKUOrderModel *mo = _gData.skuList[0];
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 80, 80)];
    [headV sd_setImageWithURL:[NSURL URLWithString:[mo.proImg middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    //图片填充方式
    [headV setContentMode:UIViewContentModeScaleAspectFill];
    headV.layer.masksToBounds = YES;
    [firstV addSubview:headV];
    
    
    BRPlaceholderTextView *textView = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headV.frame)+8, 2, SCREEN_WIDTH - CGRectGetMaxX(headV.frame) - 18, 128)];
    _textView = textView;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    [_textView setFont:[UIFont systemFontOfSize:14.0]];
    _textView.placeholder = @"请写下你对宝贝的感受吧，对别人的帮助会很大的！";
    [firstV addSubview:_textView];
    
    
    
    UIView *secondV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstV.frame)+10, SCREEN_WIDTH, 140)];
    [secondV setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:secondV];
    
    
    UILabel *mA = [[UILabel alloc] initWithFrame:CGRectMake(14, 30, 80, 20)];
    [mA setText:@"身材适合度"];
    [mA setFont:[UIFont systemFontOfSize:15.0]];
    [mA setTextColor:BLACK_COLOR];
    [secondV addSubview:mA];
    
    
    HCSStarRatingView *starA = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 210, 25.5, 200, 25)];
    starA.maximumValue = 5;
    starA.minimumValue = 0;
    starA.value = 0.0f;
    starA.spacing = 8.0;
    starA.allowsHalfStars = NO;
    starA.tintColor = PINK_COLOR;
    [starA addTarget:self action:@selector(didChangeAValue:) forControlEvents:UIControlEventValueChanged];
    [secondV addSubview:starA];

    UILabel *mB = [[UILabel alloc] initWithFrame:CGRectMake(14, 80, 80, 20)];
    [mB setText:@"风格适合度"];
    [mB setTextColor:BLACK_COLOR];
    [mB setFont:[UIFont systemFontOfSize:15.0]];
    [secondV addSubview:mB];
    
    HCSStarRatingView *starB = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 210, 77.5, 200, 25)];
    starB.maximumValue = 5;
    starB.minimumValue = 0;
    starB.value = 0.0f;
    starB.spacing = 8.0;
    starB.allowsHalfStars = NO;
    starB.tintColor = PINK_COLOR;
    [starB addTarget:self action:@selector(didChangeBValue:) forControlEvents:UIControlEventValueChanged];
    [secondV addSubview:starB];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 140)/2, CGRectGetMaxY(secondV.frame)+35, 140, 36)];
    [sendBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    [sendBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"btn_BG"] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey"] forState:UIControlStateSelected];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    //圆角
    sendBtn.layer.cornerRadius = 3; //设置那个圆角的有多圆
    sendBtn.layer.masksToBounds = YES;  //设为NO去试试
    sendBtn.layer.borderColor = PINK_COLOR.CGColor;
    sendBtn.layer.borderWidth = 0.5;
    [sendBtn addTarget:self action:@selector(sendTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sendBtn];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_textView isExclusiveTouch]) {
        [_textView resignFirstResponder];
    }
}

- (void)didChangeAValue:(HCSStarRatingView *)sender {
    _body_match = sender.value;
}


- (void)didChangeBValue:(HCSStarRatingView *)sender {
    _style_match = sender.value;
}

- (void)sendTapped:(id)sender
{
    if(_textView.text.length == 0)
    {
        [self.view makeToast:@"请填写评论"];
        return;
    }
    
    if(_body_match == 0)
    {
        [self.view makeToast:@"请给身材适合度打分"];
        return;
    }
    
    
    if(_style_match == 0)
    {
        [self.view makeToast:@"请给风格适合度打分"];
        return;
    }

    SKUOrderModel *mo = _gData.skuList[0];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:5];
    [dict setObject:mo.productId forKey:@"product_id"];
    [dict setObject:[_textView text] forKey:@"content"];
    [dict setObject:[NSNumber numberWithFloat:_body_match] forKey:@"body_match"];
    [dict setObject:[NSNumber numberWithFloat:_style_match] forKey:@"style_match"];
    [dict setObject:_gData.order_id forKey:@"order_id"];
    
    NSMutableArray *mA = [NSMutableArray arrayWithCapacity:1];
    [mA addObject:dict];
    
    
    __typeof (&*self) __weak weakSelf = self;

    [[ShoppingLogic sharedInstance] productComment:mA withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [theAppDelegate.window makeToast:@"评价成功"];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        //在这里做你响应return键的代码
        [_textView resignFirstResponder];
        return NO;              //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}



@end
