//
//  ArticleViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/8/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ArticleViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "STGoodsMainViewController.h"
#import "MagazineLogic.h"
#import "LXActionSheet.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CatZanButton.h"

@interface ArticleViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate, UIGestureRecognizerDelegate, LXActionSheetDelegate, NSURLSessionDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic, copy) NSString *urlToSave;
@property (strong, nonatomic) CIDetector *detector;
@property (nonatomic, copy) UIImage *codeImage;
@property (nonatomic, weak) CatZanButton *favButton;

@end

@implementation ArticleViewController


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
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight+StatusBar_H, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
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

    
    //判断是否登录
    if ([UserLogic sharedInstance].user.basic.userId) {
        //喜欢按钮
        CatZanButton *favButton = [[CatZanButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 40, 27, 30, 30)
                                                             zanImage:[UIImage imageNamed:@"icon_favourites_selected.png"]
                                                           unZanImage:[UIImage imageNamed:@"icon_favourites.png"]];
        _favButton = favButton;
        [_favButton setType:CatZanButtonTypeFirework];
        _favButton.isZan = [_mInfo.isLike boolValue];
        [self.navbar addSubview:_favButton];
        
        [_favButton setClickHandler:^(CatZanButton *favButton) {
            if (favButton.isZan) {
                //喜欢
                [self favorableMagazine];
            }
            else
            {
                [self unFavorableMagazine];
            }
        }];
    }
}

- (void)favorableMagazine{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_mInfo.mId forKey:@"id"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[MagazineLogic sharedInstance] favorArticle:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.mInfo.isLike = [NSNumber numberWithBool:YES];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

- (void)unFavorableMagazine{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_mInfo.mId forKey:@"id"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[MagazineLogic sharedInstance] unFavorArticle:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.mInfo.isLike = [NSNumber numberWithBool:NO];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlS = [[request URL] absoluteString];
    if ([urlS hasPrefix:@"http://m.naonaome.com/goodsDetails/productId="]) {
        //进入商品详情
        NSArray *temA = [urlS componentsSeparatedByString:@"="];
        NSNumber *proId = [NSNumber numberWithInteger:[[temA objectAtIndex:1] integerValue]];
        //进入商品详情
        [self jumpToSTGoodsMainViewController:proId];
        
        return NO;
    }
    
    return YES;
}

- (void)jumpToSTGoodsMainViewController:(NSNumber *)productId {
    //自营
    MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
    mcInfo.productId = productId;
    
    
    STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
    goodsVC.mInfo = mcInfo;
    goodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsVC animated:YES];
}

@end
