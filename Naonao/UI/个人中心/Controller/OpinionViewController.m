//
//  OpinionViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/12/14.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "OpinionViewController.h"

@interface OpinionViewController ()<UITextViewDelegate>

@property (nonatomic, weak) UILabel *tipsLabel;

@end


@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"意见反馈"];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"提交" target:self action:@selector(submitButtonTapped:)]];
    
    [self resetScrollView:self.scrollView tabBar:NO];
    self.scrollView.backgroundColor = BACKGROUND_GARY_COLOR;
    
    //圆角
    _textView.delegate = self;
    _textView.placeholder = @"你是一匹野马，必须给你草原，来，请自由的奔驰吧~";
    _textView.layer.cornerRadius = 3; //设置那个圆角的有多圆
    _textView.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
    _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];//设置边框的颜色
    _textView.layer.masksToBounds = YES;  //设为NO去试试
    _textView.returnKeyType = UIReturnKeyDone;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 165, CGRectGetMaxY(_textView.frame)+25, 160, 22)];
    _tipsLabel = tipsLabel;
    [_tipsLabel setTextAlignment:NSTextAlignmentRight];
    [_tipsLabel setTextColor:[UIColor grayColor]];
    [_tipsLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_tipsLabel setText:@"已输入文字（0/150）"];
    [self.scrollView addSubview:_tipsLabel];
}


//提交
- (void)submitButtonTapped:(id)sender
{
    if (_textView.text.length == 0) {
        [self.view makeToast:@"内容不能为空"];
        return;
    }
    
    [self sendMessage];
}


// 提交意见
- (void)sendMessage{
    __typeof (&*self) __weak weakSelf = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:[_textView text] forKey:@"content"];

    [[UserLogic sharedInstance] submitRecommendations:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //成功
            CLog(@"成功");
            [theAppDelegate.window makeToast:@"建议已经提交"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger mx = textView.text.length - range.length + text.length;
    [_tipsLabel setText:[NSString stringWithFormat:@"已输入文字（%lu/150）", mx]];
    
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [_textView resignFirstResponder];
        return NO;              //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    
#define MY_MAX 150
    if (mx > MY_MAX)
    {
        NSString *substring = [text substringToIndex:MY_MAX - (textView.text.length - range.length)];
        NSMutableString *lastString = [textView.text mutableCopy];
        [lastString replaceCharactersInRange:range withString:substring];
        textView.text = [lastString copy];
        return NO;
    }
    else
    {
        return YES;
    }
}


@end
