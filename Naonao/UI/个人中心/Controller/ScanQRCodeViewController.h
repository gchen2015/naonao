//
//  ScanQRCodeViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/8/2.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"

@interface ScanQRCodeViewController : STChildViewController

@property (strong, nonatomic) IBOutlet UIImageView *scanBgImage;
@property (strong, nonatomic) IBOutlet UIImageView *scanLineImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineTop;

@end
