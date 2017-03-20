//
//  GBrandViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/7/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "GBrandViewController.h"
#import "BrandProViewController.h"
#import "GBrandCell.h"

@interface GBrandViewController ()

@end


@implementation GBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //获取缓存信息
    [self.tableArray addObjectsFromArray:[[MagazineLogic sharedInstance] getHomeBrandArray]];
    
    [self getBrandsList];
}

- (void)loadNewData{
    [super loadNewData];
    //发送网络请求
    [self getBrandsList];
}

- (void)loadMoreData{
    [super loadMoreData];
    
    //发送网络请求
    [self getBrandsList];
}

- (void)getBrandsList{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:[NSNumber numberWithInteger:self.mPage] forKey:@"page_no"];
    [dict setObject:[NSNumber numberWithInteger:10] forKey:@"page_size"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[MagazineLogic sharedInstance] getBrandsList:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            if (self.mPage == 1) {
                [weakSelf.tableArray removeAllObjects];
                [self.tableView.mj_footer setHidden:NO];
            }
            
            NSArray *temA = (NSArray *)result.mObject;
            if (temA.count < 10) {
                //隐藏
                [self.tableView.mj_footer setHidden:YES];
            }
            
            [weakSelf.tableArray addObjectsFromArray:result.mObject];
            [weakSelf.tableView reloadData];
            
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[GBrandCell alloc] init].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //资讯
    GBrandCell *cell = [GBrandCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:self.tableArray[indexPath.row]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    STBrand *topic = self.tableArray[indexPath.row];
    
    BrandProViewController *bVC = [[BrandProViewController alloc] init];
    bVC.brandID = topic.mId;
    bVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
