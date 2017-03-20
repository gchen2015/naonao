//
//  MBChatBar.m
//  MeeBra
//
//  Created by Richard Liu on 15/10/16.
//  Copyright © 2015年 广州杉川投资管理有限公司. All rights reserved.
//

#import "MBChatBar.h"
#import "HPGrowingTextView.h"
#import "ZBMessageManagerFaceView.h"
#import "UIButton+BGImage.h"

#define FACEVIEW_HEIGHT     216.0f

@interface MBChatBar ()<ZBMessageManagerFaceViewDelegate, ZBFaceViewDelegate, HPGrowingTextViewDelegate>

@property (nonatomic, weak) UIView *barView;
@property (nonatomic, weak) HPGrowingTextView *textView;
@property (nonatomic, weak) UIButton *faceButton;

@property (nonatomic, weak) ZBMessageManagerFaceView *faceView;

@end


@implementation MBChatBar


#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        [self setup];
        
        //初始化表情键盘
        [self shareFaceView];
        
        //注册通知
        [self registeredNotification];
    }
    return self;
}

//注册通知
- (void)registeredNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//初始化
- (void)setup{
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, COVER_HEIGHT)];
    _barView = barView;
    [self.barView setBackgroundColor:[UIColor colorWithHex:0xfafafa]];
    [self addSubview:_barView];
    
    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [lineV1 setBackgroundColor:LIGHT_BLACK_COLOR];
    [self addSubview:lineV1];

    
    UIColor *borderColor = [UIColor colorWithHex:0xafafaf];
    
    HPGrowingTextView *textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH-60, 24)];
    self.textView = textView;
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.textView.minNumberOfLines = 1;
    self.textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    self.textView.maxHeight = 100.0f;
    self.textView.font = [UIFont systemFontOfSize:14.0f];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.placeholder = @"发表评论";
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 0.7;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = [borderColor CGColor];
    
    [_barView addSubview:self.textView];
    
    UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.faceButton = faceButton;
    [self.faceButton setFrame:CGRectMake(SCREEN_WIDTH - 42, 9, 32, 32)];
    [self.faceButton setImage:[UIImage imageNamed:@"postExpression"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"send_keyboard"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(faceBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:self.faceButton];
    
}

/**
 *  弹出键盘
 */
- (void)showKeyboard:(NSString *)pStr
{
    self.textView.text = @"";
    
    [self.textView becomeFirstResponder];
    self.textView.placeholder = pStr;
}


/**
 *  回收键盘
 */
- (void)recyclingKeyboard
{
    self.textView.placeholder = @"发表评论";
    
    CGRect r = self.barView.frame;
    [UIView animateWithDuration:.4 animations:^{
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT-r.size.height, SCREEN_WIDTH, r.size.height)];
        [_textView.internalTextView resignFirstResponder];
    } completion:nil];
}


/**
 *  清楚输入框中内容
 */
- (void)clearData
{
    self.textView.placeholder = @"发表评论";
    self.textView.text = @"";
    
    [UIView animateWithDuration:.4 animations:^{
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT-COVER_HEIGHT, SCREEN_WIDTH, COVER_HEIGHT)];
        [_textView.internalTextView resignFirstResponder];
    } completion:nil];
}


#pragma mark -表情键盘
//创建表情view
- (void)shareFaceView{
    ZBMessageManagerFaceView *faceView = [[ZBMessageManagerFaceView alloc] initWithFrame:
                                         CGRectMake(0.0f, COVER_HEIGHT, SCREEN_WIDTH, FACEVIEW_HEIGHT)];
    self.faceView = faceView;
    self.faceView.delegate = self;
    [self addSubview:self.faceView];
}

//显示表情
- (void)showFaceView
{
    if (!self.faceView)
    {
        [self shareFaceView];
    }

    
    CGRect r = self.barView.frame;
    
    [UIView animateWithDuration:.4 animations:^{
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT-FACEVIEW_HEIGHT-r.size.height, SCREEN_WIDTH, FACEVIEW_HEIGHT+r.size.height)];
    } completion:nil];
}



//表情（键盘切换）按钮
- (void)faceBtnTapped:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [_textView.internalTextView resignFirstResponder];
        [self showFaceView];
    }
    else{
        //显示键盘，隐藏表情
        [_textView.internalTextView becomeFirstResponder];
        
    }
}

#pragma mark -ZBMessageManagerFaceViewDelegate
- (void)SendTheFaceStr:(NSString *)faceStr isDelete:(BOOL)dele{
    
    if(dele)
    {
        //删除末尾[xx]字符
        NSUInteger flength = faceStr.length;
        NSUInteger allLength = _textView.text.length;
        
        if (faceStr) {
            if ([_textView.text hasSuffix:faceStr]) {
                //删除表情
                _textView.text = [_textView.text substringWithRange:NSMakeRange(0, allLength- flength)];
                [self.faceView.eArray removeLastObject];
            }
            else{
                if ([_textView.text length] > 0) {
                    _textView.text = [_textView.text substringWithRange:NSMakeRange(0, allLength - 1)];
                }
            }
        }
        else
        {
            CLog(@"删除普通字符");
            if ([_textView.text length] > 0) {
                _textView.text = [_textView.text substringWithRange:NSMakeRange(0, allLength - 1)];
            }
        }
    }
    else
        _textView.text = [_textView.text stringByAppendingString:faceStr];
    
}


#pragma mark - HPGrowingTextView delegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    //负数为增高
    float diff = (growingTextView.frame.size.height - height);
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        //改变整个View的frame
        CGRect f = self.frame;
        self.frame = CGRectMake(f.origin.x, f.origin.y+diff, f.size.width, f.size.height-diff);
        // 改变输入框的高度
        CGRect r = self.barView.frame;
        self.barView.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height-diff);
        
        //改变表情键盘的frame
        CGRect w = self.faceView.frame;
        self.faceView.frame = CGRectMake(w.origin.x, w.origin.y-diff, w.size.width, w.size.height);
        
        //键盘（表情）按钮
        CGRect b = self.faceButton.frame;
        self.faceButton.frame = CGRectMake(b.origin.x, b.origin.y-diff, b.size.width, b.size.height);
        
    } completion:nil];
}


- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
    //显示
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    //重绘
    [self.textView.internalTextView setNeedsDisplay];
    CLog(@"%@", growingTextView.text);
}


- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    CLog(@"输入的内容:%@", growingTextView.text);

    //发送按钮事件
    if ([text isEqualToString:@"\n"] && [[growingTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        [self sendMessage];
        return NO;
    }
    
    NSInteger textLength = self.textView.text.length;
    NSInteger replaceLength = text.length;
    
    if (replaceLength == 0 && textLength > 0) {
        
        //删除字符肯定是安全的(表情整个删除)
        if ([self.faceView.eArray count] > 0) {
            NSString *faceN = [self.faceView.eArray objectAtIndex:self.faceView.eArray.count-1];
            if ([_textView.text hasSuffix:faceN]) {
                //删除表情
                _textView.text = [_textView.text substringWithRange:NSMakeRange(0, _textView.text.length- faceN.length+1)];
                [self.faceView.eArray removeLastObject];
            }
        }
        return YES;
    }
    
    return YES;
}


//发送按钮
- (void)sendMessage{
    
    if (self.textView.text.length == 0) {
        [theAppDelegate.window makeToast:@"评论不能为空"];
        return;
    }
    
    //发表评论
    if (_delegate && [_delegate respondsToSelector:@selector(chatBar:sendMessage:)])
    {
        [_delegate chatBar:self sendMessage:[self.textView text]];
    }
    
}


#pragma mark 执行通知
- (void) keyboardWillShow:(NSNotification*)note
{
    _faceButton.selected = NO;
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    CGRect r = self.barView.frame;
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT - (keyboardBounds.size.height + r.size.height), SCREEN_WIDTH, keyboardBounds.size.height+r.size.height)];
    } completion:nil];
}


@end
