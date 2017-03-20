//
//  QRCodeView.m
//  Naonao
//
//  Created by 刘敏 on 16/8/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "QRCodeView.h"
#import "CouponsViewController.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"


@interface QRCodeView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation QRCodeView

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

- (void)setCouponId:(NSNumber *)couponId{
    //二维码滤镜
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    User *user = [[UserLogic sharedInstance] getUser];
    NSString *urls = [NSString stringWithFormat:@"%@activity/use_coupon?coupon_id=%@&userid=%@&token=%@", URL_Domain, couponId, user.basic.userId, user.basic.token];
    //将字符串转换成NSData
    NSData *data = [urls dataUsingEncoding:NSUTF8StringEncoding];
    //通过KVO设置滤镜inputmessage数据
    [filter setValue:data forKey:@"inputMessage"];
    //获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    //将CIImage转换成UIImage,并放大显示
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
}


//改变二维码大小
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


+ (instancetype)defaultPopupView{
    return [[QRCodeView alloc]initWithFrame:CGRectMake(0, 0, 240, 304)];
}

- (IBAction)closeBtnTapped:(id)sender{
    [_parentVC lew_dismissPopupView];
}

@end
