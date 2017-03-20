//
//  RequirementViewController.m
//  NaoNao
//
//  Created by Richard Liu on 15/11/20.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.

#import "RequirementViewController.h"
#import "TapScrollView.h"
#import "BRPlaceholderTextView.h"
#import "Requirement.h"
#import "DemandLogic.h"
#import "STRuler.h"



@interface RequirementViewController () <UIScrollViewDelegate, UITextViewDelegate, STRulerDelegate>

@property (nonatomic, weak) TapScrollView *scrollView;
@property (nonatomic, weak) BRPlaceholderTextView *textView;
//@property (nonatomic, weak) STRuler *mRuler;
//@property (nonatomic, weak) UILabel *priceL;

@end

@implementation RequirementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarTitle:@"个性化需求"];
    [self setNabbarBackgroundColor:[UIColor whiteColor]];
    
    //状态栏遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    TapScrollView *scrollView = [[TapScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.navbar.frame))];
    _scrollView = scrollView;
    [_scrollView setDelegate:self];
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_scrollView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -280)/2, 0, 280, 280)];
    //填充方式
    [imageV setContentMode:UIViewContentModeScaleAspectFit];
    [imageV setImage:_screenImage];
    [_scrollView addSubview:imageV];
    
    Requirement* requirement = [[DemandLogic sharedInstance] getRequirementToPublish];
    UILabel *desL = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(imageV.frame) + 5, SCREEN_WIDTH - 28, 20)];
    [desL setText:[NSString stringWithFormat:@"%@ / %@ / %@", requirement.categoryN, requirement.sceneN, requirement.styleN]];
    [desL setTextAlignment:NSTextAlignmentCenter];
    [desL setTextColor:LIGHT_BLACK_COLOR];
    [desL setFont:[UIFont boldSystemFontOfSize:15.0]];
    [_scrollView addSubview:desL];
    
    /********************************* 尺码 *******************************/
//    STRuler *mRuler = [[STRuler alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(imageV.frame) + 90, SCREEN_WIDTH - 28, 46)];
//    _mRuler = mRuler;
//    _mRuler.deletate = self;
//    //设置圆角
//    _mRuler.layer.cornerRadius = 12;
//    _mRuler.layer.masksToBounds = YES;
//    _mRuler.layer.borderColor = [UIColor grayColor].CGColor;
//    _mRuler.layer.borderWidth = 0.5;
//    [_mRuler showRulerScrollViewWithStartCount:0 count:160 average:[NSNumber numberWithFloat:20] currentValue:400.f];
//    [_scrollView addSubview:_mRuler];
//    
//    UIImageView *pV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_bar.png"]];
//    [pV setFrame:CGRectMake(0, 0, 14, 59)];
//    pV.center = _mRuler.center;
//    [_scrollView addSubview:pV];
    /***************************************************************************/
    
//    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(_mRuler.frame) + 10, SCREEN_WIDTH - 28, 20)];
//    _priceL = priceL;
//    [_priceL setTextAlignment:NSTextAlignmentCenter];
//    [desL setTextColor:LIGHT_BLACK_COLOR];
//    [_priceL setFont:[UIFont boldSystemFontOfSize:15.0]];
//    [_scrollView addSubview:_priceL];
    
    
    UILabel *mL = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(imageV.frame) + 50, 100, 20)];
    [mL setText:@"你的想法"];
    [mL setTextColor:GOLDEN_YELLOW];
    [mL setFont:[UIFont boldSystemFontOfSize:15.0]];
    [_scrollView addSubview:mL];
    
    
    BRPlaceholderTextView *textView = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(mL.frame)+6, SCREEN_WIDTH-28, 100)];
    _textView = textView;
    _textView.delegate = self;
    _textView.placeholder = @"说说你的一些要求吧，以便我们更加专业的为您服务。";
    //设置那个圆角的有多圆
    _textView.layer.cornerRadius = 3;
    //设置边框的宽度，当然可以不要
    _textView.layer.borderWidth = 0.5;
    //设置边框的颜色
    _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //设为NO去试试
    _textView.layer.masksToBounds = YES;
    _textView.returnKeyType = UIReturnKeyDone;
    [_scrollView addSubview:_textView];
    
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, CGRectGetMaxY(_textView.frame)+30, 120, 36)];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"btn_pink.png"] forState:UIControlStateNormal];
    [finishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    //圆角
    finishBtn.layer.cornerRadius = 6; //设置那个圆角的有多圆
    finishBtn.layer.masksToBounds = YES;  //设为NO去试试
    finishBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    finishBtn.layer.borderWidth = 0.5;
    [finishBtn addTarget:self action:@selector(finishRequirement:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:finishBtn];
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 800)];
}


- (void)finishRequirement:(id)sender {
    
    if (_textView.text.length == 0 || [_textView.text isEqualToString:@"说说你的一些要求吧，以便我们更加专业的为您服务。"]) {
        [self.view makeToast:@"说点什么吧"];
        return;
    }
    
    Requirement* requirement = [[DemandLogic sharedInstance] getRequirementToPublish];
    requirement.desc = [Units encodeToPercentEscapeString:_textView.text];

    [self publishRequirement:requirement];
}

// 发布需求
- (void)publishRequirement:(Requirement * )requirement{
    [theAppDelegate.HUDManager showSimpleTip:@"需求发布中..." interval:NSNotFound];
    __typeof (&*self) __weak weakSelf = self;
    [[DemandLogic sharedInstance] publishRequirement:requirement withCallback:^(LogicResult *result) {
        
        [theAppDelegate.HUDManager hideHUD];
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf gotoHome];
        }
        else
            [weakSelf.view makeToast:@"发布失败"];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger mx = textView.text.length - range.length + text.length;
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [_textView resignFirstResponder];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        return NO;
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //移动
    [_scrollView setContentOffset:CGPointMake(0, 310) animated:YES];
    
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_textView isExclusiveTouch]) {
        [_textView resignFirstResponder];
        
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

// 返回到首页
- (void)gotoHome {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [theAppDelegate popToNotRespondView];
}


#pragma mark - STRulerDelegate
- (void)ruler:(STRulerScrollView *)rulerScrollView{
//    [_priceL setText:[NSString stringWithFormat:@"%lu", (unsigned long)rulerScrollView.rulerValue]];
}


@end
