//
//  ScanQRCodeViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/8/2.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import "CouponsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ShoppingLogic.h"

@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) CGFloat imageSize;
@property (nonatomic, assign) CGFloat originalTop;
@property (nonatomic, assign) BOOL torchIsOn;
@property (nonatomic, assign) BOOL up;

@property (strong, nonatomic) CIDetector *detector;

//计时器
@property (nonatomic, strong) CADisplayLink * link;
@property (nonatomic, strong) AVCaptureSession *session;


@end

@implementation ScanQRCodeViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.session startRunning];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

- (void)setUp {
    _imageSize = 200;
    _originalTop = 150;
    _up = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"扫一扫"];

    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"相册" target:self action:@selector(photoAlbumTapped:)]];
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [self setUp];
    
    CADisplayLink *link=[CADisplayLink displayLinkWithTarget:self selector:@selector(move)];
    self.link = link;
    
    // 1.获取输入设备(摄像头)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2.根据输入设备创建输入对象
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
    
    if (input==nil) {
        return;
    }
    // 3.创建输出对象
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 4.设置代理监听输出对象输出的数据
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 5.创建会话(桥梁)
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 6.添加输入和输出到会话中（判断session是否已满）
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    // 7.告诉输出对象, 需要输出什么样的数据 (二维码还是条形码)
    output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeCode39Mod43Code];
    
    // 8.创建预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    previewLayer.frame = MAINSCREEN;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    // 8.开始扫描数据
    [session startRunning];
    self.session = session;
    
    //设置中空区域
    UIView *maskView = [[UIView alloc] initWithFrame:MAINSCREEN];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.view addSubview:maskView];
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [rectPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake((SCREEN_WIDTH - _imageSize) / 2, _originalTop-20, _imageSize, _imageSize) cornerRadius:1] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = rectPath.CGPath;
    maskView.layer.mask = shapeLayer;
}

//打开相册
- (void)photoAlbumTapped:(id)sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
// 扫描到数据时会调用
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        // 1.停止扫描
        [self.session stopRunning];
        
        // 2.停止冲击波
        [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        // 3.取出扫描到得数据
        AVMetadataMachineReadableCodeObject *obj = [metadataObjects lastObject];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
        [dic setObject:[obj stringValue] forKey:@"binding_code"];
        
        [self sendMessage:dic];
    }
}

- (void)move{
    if (_up == YES) {
        self.lineTop.constant += 2;
        if (self.lineTop.constant >= _originalTop + _imageSize - 19) {
            _up = NO;
        }
    }
    else {
        self.lineTop.constant -= 2;
        if (self.lineTop.constant <= _originalTop) {
            _up = YES;
        }
    }
}

- (void)sendMessage:(NSDictionary *)dic {
    [[ShoppingLogic sharedInstance] getScanQRCode:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            AlertWithTitleAndMessageAndBtton(@"领取成功", @"优惠券已领取，是否去查看我的优惠券？", self, @"查看");
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:result.stateDes
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        
            [alert show];
        }
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //取消
        [self.session startRunning];
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    else if(buttonIndex == 1)
    {
        //进入优惠券页面
        CouponsViewController *sVC = [[CouponsViewController alloc] init];
        sVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sVC animated:YES];
    }
}


#pragma mark -UIImagePickerControllerDelegate
// 选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    CLog(@"%@", info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    //识别二维码
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        
        CLog(@"%@", scannedResult);

    }

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
