//
//  GBaseViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/7/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineLogic.h"
#import "MJRefresh.h"
#import "DPWebViewController.h"

@interface GBaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSUInteger mPage;                 //页码
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) UIEdgeInsets tableViewEdinsets;


#pragma mark - 下拉刷新更新数据
- (void)loadNewData;

#pragma mark - 上拉刷新更多数据
- (void)loadMoreData;

@end
