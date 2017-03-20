//
//  BaseTextViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/4/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "BaseTextViewController.h"
#import "UIView+FindFirstResponder.h"


@interface BaseTextViewController ()

- (UIToolbar *)createToolbar;
- (void)nextTextField;
- (void)prevTextField;
- (void)textFieldDone;
- (NSArray *)inputViews;

@end


@implementation BaseTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initToolBar
{
    UIToolbar *toolBar = [self createToolbar];
    for (UIView *v in self.view.subviews) {
        if ([v respondsToSelector:@selector(setText:)]) {
            if ([v isKindOfClass:[UITextField class]]) {
                [v performSelector:@selector(setDelegate:) withObject:self];
                [v performSelector:@selector(setInputAccessoryView:) withObject:toolBar];
            }
        }
    }
    
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.view];
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - private
- (UIToolbar *)createToolbar
{
    UIToolbar *toolBar = [UIToolbar new];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RETableViewManager.bundle/UIButtonBarArrowRight"] style:UIBarButtonItemStylePlain target:self action:@selector(nextTextField)];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RETableViewManager.bundle/UIButtonBarArrowLeft"] style:UIBarButtonItemStylePlain target:self action:@selector(prevTextField)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(textFieldDone)];
    toolBar.items = @[prevButton, nextButton, space, done];
    [toolBar sizeToFit];
    return toolBar;
}

- (void)nextTextField
{
    NSUInteger currentIndex = [[self inputViews] indexOfObject:[self.view findFirstResponder]];
    NSUInteger nextIndex = currentIndex + 1;
    nextIndex += [[self inputViews] count];
    nextIndex %= [[self inputViews] count];
    UITextField *nextTextField = [[self inputViews] objectAtIndex:nextIndex];
    [nextTextField becomeFirstResponder];
}

- (void)prevTextField
{
    NSUInteger currentIndex = [[self inputViews] indexOfObject:[self.view findFirstResponder]];
    NSUInteger prevIndex = currentIndex - 1;
    prevIndex += [[self inputViews] count];
    prevIndex %= [[self inputViews] count];
    UITextField *nextTextField = [[self inputViews] objectAtIndex:prevIndex];
    [nextTextField becomeFirstResponder];
}

- (void)textFieldDone
{
    [[self.view findFirstResponder] resignFirstResponder];
}

- (NSArray *)inputViews
{
    NSMutableArray *returnArray = [NSMutableArray array];
    for (UIView *eachView in self.view.subviews) {
        if ([eachView isKindOfClass:[UITextField class]]) {
            [returnArray addObject:eachView];
        }
    }
    return returnArray;
}

- (UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

- (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

- (UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}


@end
