//
//  XIBBaseViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-5-17.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "DMBaseViewController.h"


@interface DMBaseViewController ()

@end

@implementation DMBaseViewController


- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}



- (void)viewWillDisappear:(BOOL)animated
{

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    SYSTEMVERSION_IOS7;
    // Do any additional setup after loading the view.
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem customWithImageName:@"nav_back.png" target:self action:@selector(backButtonTapped:)];

    
    cameraStoryboard = [UIStoryboard storyboardWithName:@"CameraStoryboard" bundle:nil];
    
}


- (void)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
