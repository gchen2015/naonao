//
//  PublishPicturesViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/5/9.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PublishPicturesViewController.h"
#import "CommunityLogic.h"
#import <SDWebImage/UIImage+WebP.h>
#import "BRPlaceholderTextView.h"

@interface PublishPicturesViewController ()<UITextViewDelegate>

//发布图片的Data
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, weak) BRPlaceholderTextView *textView;

@end



#define M_Quality 75.0f         //质量

@implementation PublishPicturesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;

    //设置导航栏右侧按钮
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"发布" target:self action:@selector(sendButtonTapped:)]];
    
    //图像压缩
    [self compressedImage];
    
    //输入文字
    BRPlaceholderTextView *textView = [[BRPlaceholderTextView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.navbar.frame), SCREEN_WIDTH-5,  130)];
    _textView = textView;
    [_textView setFont:[UIFont systemFontOfSize:16.0]];
    [_textView setPlaceholderFont:[UIFont systemFontOfSize:16.0]];
    _textView.delegate = self;
    _textView.placeholder = @"说点什么吧~";
    _textView.layer.masksToBounds = YES;  //设为NO去试试
    _textView.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:_textView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_textView.frame) + 15, 90, 90)];
    [imageV setImage:_image];
    [self.view addSubview:imageV];
    
    [_textView becomeFirstResponder];
    
}


- (void)sendButtonTapped:(id)sender
{
    if (_textView.text.length == 0) {
        [self.view makeToast:@"说点什么吧"];
        return;
    }
    
    [self uploadImage];
    [theAppDelegate.HUDManager showSimpleTip:@"发布中..." interval:NSNotFound];
}


- (void)compressedImage{
    __typeof (&*self) __weak weakSelf = self;
    
    //webP压缩
    dispatch_after(0.2, dispatch_get_global_queue(0, 0), ^{
        
        NSData *tempData = UIImageJPEGRepresentation(_image, 0.45);
        
        [UIImage imageToWebP:[UIImage imageWithData:tempData] quality:M_Quality alpha:1 preset:WEBP_PRESET_DEFAULT completionBlock:^(NSData *result) {
            //上传图片
            weakSelf.imageData = result;
        } failureBlock:^(NSError *error) {
            CLog(@"%@", error.localizedDescription);
        }];
        
    });
}


//上传图片
- (void)uploadImage
{
    __typeof (&*self) __weak weakSelf = self;
    [[CommunityLogic sharedInstance] uploadPicturesToQiniu:_imageData withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            CLog(@"%@", result);
            //成功
            [weakSelf sendBuyerShow:(NSString *)result.mObject];
        }
        else
        {
            [theAppDelegate.HUDManager hideHUD];
            [weakSelf.view makeToast:result.stateDes];
        }
    }];
    
}

//发布买家秀
- (void)sendBuyerShow:(NSString *)imageUrl
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:imageUrl forKey:@"imgurl"];
    [dict setObject:[_textView text] forKey:@"desc"];
    [dict setObject:[CommunityLogic sharedInstance].proID forKey:@"product_id"];
    
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[CommunityLogic sharedInstance] sendBuyersShow:dict withCallback:^(LogicResult *result) {
        
        [theAppDelegate.HUDManager hideHUD];
        
        if(result.statusCode == KLogicStatusSuccess)
        {
            //成功
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [_textView resignFirstResponder];
        return NO;              //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


@end
