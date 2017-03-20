//
//  DPWebViewController.h
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STChildViewController.h"

@interface DPWebViewController : STChildViewController

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, assign) BOOL isReturn;

@property (nonatomic, strong) NSString *urlSting;     //链接
@property (nonatomic, strong) NSString *titName;      //标题

@end
