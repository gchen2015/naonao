//
//  DPWebViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "DPWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"


@interface DPWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic, assign) NSUInteger mPage;
@property (nonatomic, weak) UIButton *endBtn;

@end

@implementation DPWebViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navbar addSubview:_progressView];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavBarTitle:_titName];
    
    UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(44, 22, 40, 40)];
    _endBtn = endBtn;
    [_endBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_endBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_endBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_endBtn addTarget:self action:@selector(shutDown:) forControlEvents:UIControlEventTouchUpInside];
    [_endBtn setHidden:YES];
    [self.navbar addSubview:_endBtn];
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight+StatusBar_H, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"nav_back.png" imgHighlight:@"nav_back_highlighted.png" imgSelected:nil target:self action:@selector(back:)]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    _webView = webView;
    
    //自动适应屏幕
    _webView.scalesPageToFit = YES;
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    [self.view addSubview:_webView];
    
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlSting]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0]];
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setOpaque:YES];//使网页透明
    
    
    for (id subview in _webView.subviews){
        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).bounces = NO;
            
        }
        
    }
}


- (void)back:(id)sender
{
    if (!_webView.canGoBack) {
        if (_isReturn) {
            
            //连续返回两级
            NSUInteger index = [[self.navigationController viewControllers] indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
        }
        else
            [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [_webView goBack];
        [_endBtn setHidden:NO];
    }
}

- (void)shutDown:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(title.length > 0 && ![title hasPrefix:@"http://"])
    {
        [self setNavBarTitle:title];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    CLog(@"当前网络链接：%@", [request URL]);
    NSString *urlS = [[request URL] absoluteString];
    if([urlS hasPrefix:@"taobao://h5.m.taobao.com/"] || [urlS hasPrefix:@"taobao://www.tmall.com/"]) {
        //禁止跳转
        return NO;
    }
    
    if([urlS hasSuffix:@".jpg"])
    {
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlS]];
        UIImage* image = [UIImage imageWithData:data];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        return NO;
    }

    return YES;
}

//保存到相册的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL){
        [self.view makeToast:@"保存图片失败"];
    }else{
        [self.view makeToast:@"保存图片成功"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}


@end
