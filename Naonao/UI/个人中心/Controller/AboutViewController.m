//
//  AboutViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/12/14.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AboutViewController.h"


@interface AboutViewController ()

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIImageView *logoView;
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;

@end


@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"关于挠挠"];
    self.view.backgroundColor = BACKGROUND_GARY_COLOR;

    
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    _bgView.layer.cornerRadius = 5;                     //设置那个圆角的有多圆
    _bgView.layer.masksToBounds = YES;                  //设为NO去试试
    

    [_versionLabel setText:[NSString stringWithFormat:@"当前版本号：%@", APP_Version]];
}

@end
