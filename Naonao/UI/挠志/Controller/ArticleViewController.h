//
//  ArticleViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/8/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "MagazineInfo.h"


@interface ArticleViewController : STChildViewController

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, strong) NSString *urlSting;     //链接
@property (nonatomic, strong) NSString *titName;      //标题

@property (nonatomic, strong) MagazineInfo *mInfo;

@end
