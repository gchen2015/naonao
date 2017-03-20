//
//  DMCameraViewController.m
//  Artery
//
//  Created by 刘敏 on 14-10-22.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.

#import "DMCameraViewController.h"
#import "EffectsViewController.h"
#import "UIImage+UIImageScale.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ILTranslucentView.h"



@interface DMCameraViewController ()

@property (nonatomic, assign) NSInteger alphaTimes;
@property (nonatomic, assign) CGPoint currTouchPoint;           //点击的位置（对焦框的位置）

@property (nonatomic, weak) UIView *imagePreview;               //成像区域
@property (nonatomic, weak) UIButton *photoCaptureButton;       //拍照按钮
@property (nonatomic, weak) UIButton *flashButton;              //闪光灯按钮

@property (nonatomic) dispatch_queue_t   sessionQueue;

//@property (weak, nonatomic) UIImageView *captureImage;          //图像区域


@property (nonatomic, strong) AVCaptureDeviceInput *inputDevice;        //输入设备
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;      //图像输出
//对焦
@property (nonatomic, strong) UIImageView *focusImageView;

//是否打开相机
@property (nonatomic, assign) BOOL isOpenCamera;
@property (nonatomic, strong) ALAssetsLibrary *library;

@property (nonatomic, assign) BOOL FrontCamera;             //前摄像头
@property (nonatomic, strong) AVCaptureSession            *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer  *captureVideoPreviewLayer;
@property (nonatomic, strong) UIImage                     *croppedImageWithoutOrientation;



@end

@implementation DMCameraViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    if (_isOpenCamera) {
        //初始化硬件设备
        [self initializeCamera];
    }
    else{
        _isOpenCamera = YES;
    }
    
    [MobClick beginLogPageView:@"拍照"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"拍照"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

    // Stop capturing image
    [_session stopRunning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //初始化界面
    [self initUI];
    
    _library = [[ALAssetsLibrary alloc] init];
    
    _isOpenCamera = YES;
        
    // Today Implementation
    _FrontCamera = NO;

    _croppedImageWithoutOrientation = [[UIImage alloc] init];
}

- (void)initUI
{
    [self.view setBackgroundColor:[UIColor colorWithHex:0x2d2d2d]];
    
    //成像区域
    UIView *imagePreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH + TOP_H + SBottom_H)];
    _imagePreview = imagePreview;
    [self.view addSubview:_imagePreview];
    
    ILTranslucentView *navView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    navView.alpha = 1.0;
    navView.translucentStyle = UIBarStyleDefault;
    navView.translucentTintColor = [UIColor blackColor];
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(-10, 22, 64, 40);
    [backBtn setImage:[UIImage imageNamed:@"btn_back_c.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    //底部菜单
    ILTranslucentView *bottomV = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH + TOP_H, SCREEN_WIDTH, SBottom_H)];
    bottomV.alpha = 0.8;
    bottomV.translucentStyle = UIBarStyleDefault;
    bottomV.translucentTintColor = [UIColor blackColor];
    [self.view addSubview:bottomV];
    
    //前后摄像头转换
    UIButton *swithBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 80, 10, 40, 40)];
    [swithBtn setImage:[UIImage imageNamed:@"switch_camera.png"] forState:UIControlStateNormal];
    [swithBtn addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:swithBtn];
    
    //闪关灯
    UIButton *flashButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 40, 10, 40, 40)];
    _flashButton = flashButton;
    [_flashButton setImage:[UIImage imageNamed:@"flashing_off.png"] forState:UIControlStateNormal];
    [_flashButton addTarget:self action:@selector(flashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:_flashButton];
    
    //拍摄按钮
    UIButton *shootButtonTapped = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    [shootButtonTapped setBackgroundImage:[UIImage imageNamed:@"shot.png"] forState:UIControlStateNormal];
    [shootButtonTapped addTarget:self action:@selector(shootButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shootButtonTapped];
    
    CGFloat mY = CGRectGetMaxY(bottomV.frame) + (SCREEN_HEIGHT - CGRectGetMaxY(bottomV.frame))/2;
    [shootButtonTapped setCenter:CGPointMake(SCREEN_WIDTH/2, mY)];
}



// 初始化相机
- (void) initializeCamera {
    
    if (_session)
    {
        _session = nil;
    }
    _session = [[AVCaptureSession alloc] init];
	_session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    //创建队列
    [self createQueue];

    if (_captureVideoPreviewLayer)
    {
        _captureVideoPreviewLayer = nil;
    }
	_captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    [_captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	_captureVideoPreviewLayer.frame = self.imagePreview.bounds;
	[self.imagePreview.layer addSublayer:_captureVideoPreviewLayer];
    
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = view.bounds;
    [_captureVideoPreviewLayer setFrame:bounds];
    
    //4、默认后置摄像头
    [self addVideoInputFrontCamera:_FrontCamera];
    
    //设备输出
    if (_stillImageOutput)
        _stillImageOutput = nil;
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    
    [_stillImageOutput setOutputSettings:outputSettings];
    [_session addOutput:_stillImageOutput];
    
    //对焦框
    [self addFocusView];
    
	[_session startRunning];
}

/**
 *  添加输入设备
 *
 *  @param front 前或后摄像头
 */
- (void)addVideoInputFrontCamera:(BOOL)front {
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        CLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                CLog(@"Device position : back");
                backCamera = device;
                
            }  else {
                CLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    NSError *error = nil;
    
    if (front) {
        AVCaptureDeviceInput *frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!error) {
            if ([_session canAddInput:frontFacingCameraDeviceInput]) {
                [_session addInput:frontFacingCameraDeviceInput];
                self.inputDevice = frontFacingCameraDeviceInput;
                
            } else {
                CLog(@"Couldn't add front facing video input");
            }
        }
    } else {
        AVCaptureDeviceInput *backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!error) {
            if ([_session canAddInput:backFacingCameraDeviceInput]) {
                [_session addInput:backFacingCameraDeviceInput];
                self.inputDevice = backFacingCameraDeviceInput;
            } else {
                CLog(@"Couldn't add back facing video input");
            }
        }
    }
}

#pragma mark 按钮响应事件
- (void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 闪光灯
- (void)flashButtonTapped:(UIButton *)sender{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (!captureDeviceClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有拍照功能" delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }

    NSString *imgStr = @"";
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    
    if ([device hasFlash]) {
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            imgStr = @"flashing_on.png";
            
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            imgStr = @"flashing_auto.png";
            
        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            imgStr = @"flashing_off.png";
            
        }
        
        if (sender) {
            [sender setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有闪光灯功能" delegate:nil cancelButtonTitle:@"噢T_T" otherButtonTitles: nil];
        [alert show];
    }

    [device unlockForConfiguration];

}

// 切换前后摄像头
- (void)switchCamera:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _FrontCamera = sender.selected;
    
    [self addVideoInputFrontCamera:_FrontCamera];
}


//拍照按钮
- (void)shootButtonTapped:(id)sender{
    [self closeCaptureView];
    [self capImage];
}


- (void) capImage {
    //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    CLog(@"关于请求捕获: %@", _stillImageOutput);
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}


//过程捕获图像,作物,大小和旋转
- (void)processImage:(UIImage *)image {
    
    // Resize image to 1280*1280
    // Resize image
    UIImage *smallImage = [self imageWithImage:image scaledToWidth:1280];

    /**
     *  图像裁剪
     *  1.先裁剪宽度，再裁剪高度   2、所取得图像为正中心的部分
     *
     *  @param 0
     *  @param 取正中心位置 (smallImage.size.height-smallImage.size.width)/2 为差值
     *
     *  @return
     */
    NSInteger height = (smallImage.size.height-smallImage.size.width)/2;
    CGRect cropRect = CGRectMake(0, height, 1280,  1280);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    
    _croppedImageWithoutOrientation = [[UIImage imageWithCGImage:imageRef] copy];
    
    UIImage *croppedImage = nil;
    
    // 调整图像的方向
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationLandscapeLeft:
            croppedImage = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationLeft];
            break;
        case UIDeviceOrientationLandscapeRight:
            croppedImage = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationRight];
            break;
            
        case UIDeviceOrientationFaceUp:
            croppedImage = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationUp];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            croppedImage = [[UIImage alloc] initWithCGImage: imageRef
                                                       scale: 1.0
                                                 orientation: UIImageOrientationDown];
            break;
            
        default:
            croppedImage = [UIImage imageWithCGImage:imageRef];
            break;
    }
    
    CGImageRelease(imageRef);
    
//    [self.captureImage setImage:croppedImage];
    
//    //保存拍摄的图片到相册
//    [_library saveImage:croppedImage toAlbum:@"食探" completion:^(NSURL *assetURL, NSError *error) {
//        CLog(@"你好，阳光！");
//        
//    } failure:^(NSError *error) {
//        if (error != nil) {
//            CLog(@"Big error: %@", [error description]);
//        }
//    }];
    
    [self setCapturedImage:croppedImage];
}

// 图片裁剪
- (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setCapturedImage:(UIImage *)image{
    // Stop capturing image
    [_session stopRunning];
    
    // Hide Top/Bottom controller after taking photo for editing
    [self jumpToNext:image];
}


- (void)jumpToNext:(UIImage *)image
{
    //跳转到特效页面（滤镜）
    EffectsViewController * eVC = [[EffectsViewController alloc] init];
    eVC.cacheImage = image;
    CLog(@"%02f, %02f", image.size.width, image.size.height);
    [self.navigationController pushViewController:eVC animated:YES];
}

//关闭相机显示区域
- (void)closeCaptureView{

}


//打开相机显示区域
- (void)openCaptureView{

}


#pragma mark - Device Availability Controls
- (void)disableCameraDeviceControls{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------对焦---------------
//对焦的框
- (void)addFocusView {
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus.png"]];
    [imgView setFrame:CGRectMake(-74, -74, 73, 73)];
    imgView.alpha = 0;
    [self.imagePreview addSubview:imgView];
    self.focusImageView = imgView;
    
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && [device isFocusPointOfInterestSupported]) {
        [device addObserver:self forKeyPath:ADJUSTINT_FOCUS options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
#endif
}

#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
//监听对焦是否完成了
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ADJUSTINT_FOCUS]) {
        BOOL isAdjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        
        CLog(@"是否调整对焦点? %@", isAdjustingFocus ? @"YES" : @"NO" );
        CLog(@"Change dictionary: %@", change);
        
        if (!isAdjustingFocus) {
            alphaTimes = -1;
        }
    }
}

- (void)showFocusInPoint:(CGPoint)touchPoint {
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        int alphaNum = (alphaTimes % 2 == 0 ? HIGH_ALPHA : LOW_ALPHA);
        self.focusImageView.alpha = alphaNum;
        alphaTimes++;
        
    } completion:^(BOOL finished) {
        
        if (alphaTimes != -1) {
            [self showFocusInPoint:currTouchPoint];
        } else {
            self.focusImageView.alpha = 0.0f;
        }
    }];
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    _alphaTimes = -1;
    
    UITouch *touch = [touches anyObject];
    
    
    _currTouchPoint.x = [touch locationInView:self.view].x;
    _currTouchPoint.y = [touch locationInView:self.view].y;
    
    if (CGRectContainsPoint(_captureVideoPreviewLayer.bounds, _currTouchPoint) == NO) {
        return;
    }
    
    [self focusInPoint:_currTouchPoint];
    
    //对焦框
    [_focusImageView setCenter:_currTouchPoint];
    
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    
#if SWITCH_SHOW_FOCUSVIEW_UNTIL_FOCUS_DONE
    [UIView animateWithDuration:0.1f animations:^{
        _focusImageView.alpha = HIGH_ALPHA;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self showFocusInPoint:currTouchPoint];
    }];
#else
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusImageView.alpha = 1.f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusImageView.alpha = 0.f;
        } completion:nil];
    }];
#endif
}


/**
 *  点击后对焦
 *
 *  @param devicePoint 点击的point
 */
- (void)focusInPoint:(CGPoint)devicePoint {
    devicePoint = [self convertToPointOfInterestFromViewCoordinates:devicePoint];
	[self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
    
	dispatch_async(_sessionQueue, ^{
		AVCaptureDevice *device = [_inputDevice device];
		NSError *error = nil;
		if ([device lockForConfiguration:&error])
		{
			if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
			{
				[device setFocusMode:focusMode];
				[device setFocusPointOfInterest:point];
			}
			if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
			{
				[device setExposureMode:exposureMode];
				[device setExposurePointOfInterest:point];
			}
			[device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
			[device unlockForConfiguration];
		}
		else
		{
			CLog(@"%@", error);
		}
	});
}



/**
 *  外部的point转换为camera需要的point(外部point/相机页面的frame)
 *
 *  @param viewCoordinates 外部的point
 *
 *  @return 相对位置的point
 */
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = _captureVideoPreviewLayer.bounds.size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = _captureVideoPreviewLayer;
    
    if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResize]) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    }
    else
    {
        CGRect cleanAperture;
        
        for(AVCaptureInputPort *port in [[_session.inputs lastObject]ports])
        {
            if([port mediaType] == AVMediaTypeVideo)
            {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspect])
                {
                    if(viewRatio > apertureRatio)
                    {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if(point.x >= blackBar && point.x <= blackBar + x2)
                        {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    }
                    else
                    {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if(point.y >= blackBar && point.y <= blackBar + y2)
                        {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                }
                else if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspectFill])
                {
                    if(viewRatio > apertureRatio)
                    {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    }
                    else
                    {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

- (void)subjectAreaDidChange:(NSNotification *)notification {
    
	CGPoint devicePoint = CGPointMake(.5, .5);
	[self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}


/***********************************************************************/

/**
 *  创建一个队列，防止阻塞主线程
 */
- (void)createQueue {
	dispatch_queue_t sessionQueue = dispatch_queue_create("com.budstudio.sessionQueue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
}



@end
