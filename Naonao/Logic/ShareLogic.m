//
//  ShareLogic.m
//  Naonao
//
//  Created by 刘敏 on 16/4/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ShareLogic.h"
#import "SGActionView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ProductModeFrame.h"

@interface ShareLogic ()

//分享
@property (nonatomic, strong) NSArray *openArray;
@property (nonatomic, strong) NSArray *openImageArray;
@property (nonatomic, strong) id viewController;

@end


@implementation ShareLogic

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static ShareLogic* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ShareLogic alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [self summarizeShareData];
    }
    return self;
}

//- (void)setOInfo:(OrderDes *)oInfo
//{
//    _oInfo = oInfo;
//}

- (void)setDInfo:(DynamicInfo *)dInfo{
    _dInfo = dInfo;
}

- (void)setSData:(SProData *)sData{
    _sData = sData;
}


#pragma mark 分享及增删改查
- (void)summarizeShareData{
    NSMutableArray *tA = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tB = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])
    {
        [tA addObject:@"微信好友"];
        [tA addObject:@"微信朋友圈"];
        
        [tB addObject:[UIImage imageNamed:@"sns_icon_4"]];
        [tB addObject:[UIImage imageNamed:@"sns_icon_5"]];
    }
    
    if (1)
    {
        [tA addObject:@"微博"];
        [tB addObject:[UIImage imageNamed:@"sns_icon_3"]];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
    {
        [tA addObject:@"QQ好友"];
        [tA addObject:@"QQ空间"];
        
        [tB addObject:[UIImage imageNamed:@"sns_icon_1"]];
        [tB addObject:[UIImage imageNamed:@"sns_icon_2"]];
    }

    _openArray = tA;
    _openImageArray = tB;
}



- (void)showActionView:(id)viewController
{
    _viewController = viewController;
    
    [SGActionView sharedActionView].style = SGActionViewStyleLight;
    [SGActionView showGridMenuWithTitle:nil
                             itemTitles:_openArray
                                 images:_openImageArray
                         selectedHandle:^(NSInteger index) {
                             [self didClickOnImageIndex:index];
                         }];
}



- (void)didClickOnImageIndex:(NSInteger)imageIndex {
    if (imageIndex == 0) {
        return;
    }
    
    NSString *urlS = nil;
    NSString *describe = nil;
    NSString *title = nil;
    __block NSData *imageData = nil;
    __block NSData *wbImageData = nil;
    
    
    
    NSString * name = [_openArray objectAtIndex:imageIndex-1];
    UMSocialPlatformType platformType = 0;
    
    if ([name isEqualToString:@"QQ好友"]) {
        //QQ好友
        platformType = UMSocialPlatformType_QQ;
    }
    
    if ([name isEqualToString:@"QQ空间"]) {
        //QQ空间
        platformType = UMSocialPlatformType_Qzone;
    }
    
    if ([name isEqualToString:@"微信好友"]) {
        platformType = UMSocialPlatformType_WechatSession;
    }
    
    if ([name isEqualToString:@"微信朋友圈"]) {
        platformType = UMSocialPlatformType_WechatTimeLine;
    }
    
    if ([name isEqualToString:@"微博"]) {
        platformType = UMSocialPlatformType_Sina;
    }
    

    
    User *user = [[UserLogic sharedInstance] getUser];

    
    //分享回应页面
    if (_mType == KShare_Brand) {
        //传递订单ID，分享者userID
//        urlS = [NSString stringWithFormat:@"%@resp?respid=%@&sourceid=%@", URL_Domain, _oInfo.orderid, user.basic.userId];
//        
//        ProductModeFrame *md = _oInfo.proArray[0];
//        describe = md.pData.wrap_words;
//        //标题
//        title = _oInfo.titS;
//        
//        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200/format/jpg", _oInfo.imgurl]]];
//        
//        wbImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/640/format/jpg", _oInfo.imgurl]]];
    }
    else if (_mType == KShare_Product)
    {
        //传递商品ID，发布者userID
        urlS = [NSString stringWithFormat:@"%@item?pro_id=%@&source_uid=%@", URL_Domain, _sData.proId, [UserLogic sharedInstance].user.basic.userId];
        //文字描述
        describe = _sData.proDes;
        //标题
        title = _sData.proName;
        
        //异步
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CLog(@"当前线程 :%@",[NSThread currentThread]);
            //下载图片
            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200/format/jpg", _sData.proImage]]];
            wbImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/640/format/jpg", _sData.proImage]]];

            if (wbImageData  && wbImageData) {
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    //执行相应的页面跳转
                    [self shareExternAppToPlatformType:platformType webUrl:urlS thumbnail:wbImageData describe:describe title:title];
                });   
            }   
        });
    }
    else if (_mType == KShare_App)
    {
//        //链接
//        urlS = _oInfo.createTime;
//        
//        describe = @"挠挠大神向您推荐，发现不一样的自己";
//        //标题
//        title = _oInfo.titS;
//        
//        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200/format/jpg", _oInfo.imgurl]]];
//        
//        wbImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/640/format/jpg", _oInfo.imgurl]]];
    }
}


///*********************************** 分享 ************************************/

//分享网页
- (void)shareExternAppToPlatformType:(UMSocialPlatformType)platformType
                              webUrl:(NSString *)url
                           thumbnail:(NSData *)thumbnailData
                            describe:(NSString *)describe
                               title:(NSString *)tit{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (platformType == UMSocialPlatformType_Sina){
       messageObject.text = [NSString stringWithFormat:@"@挠挠科技:%@ %@", tit, url];
    }

    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:tit descr:describe thumImage:thumbnailData];
    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = result;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",result);
            }
        }
        CLog(@"%@", error.userInfo);
    }];
}

@end



@implementation SProData

@end
