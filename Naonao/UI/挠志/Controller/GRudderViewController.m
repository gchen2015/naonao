//
//  GRudderViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/7/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "GRudderViewController.h"
#import "RudderCell.h"
#import "RudderModeFrame.h"
#import "RudderLordViewController.h"

@interface GRudderViewController ()

@end

@implementation GRudderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    //获取缓存信息
    [self.tableArray addObjectsFromArray:[[MagazineLogic sharedInstance] getHomeDuozhuArray]];
    
    [self getMagazineList];
}

- (void)loadNewData{
    [super loadNewData];
    //发送网络请求
    [self getMagazineList];
}

- (void)loadMoreData{
    [super loadMoreData];
    
    //发送网络请求
    [self getMagazineList];
}

- (void)getMagazineList{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dict setObject:[NSNumber numberWithInteger:self.mPage] forKey:@"page_no"];
    [dict setObject:[NSNumber numberWithInteger:10] forKey:@"page_size"];
    [dict setObject:[NSNumber numberWithInteger:3] forKey:@"category"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[MagazineLogic sharedInstance] getRecommandUsers:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
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
    RudderModeFrame *modeFrame = self.tableArray[indexPath.row];
    return modeFrame.rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //资讯
    RudderCell *cell = [RudderCell cellWithTableView:tableView];
    cell.modeFrame = self.tableArray[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是否登录
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    RudderModeFrame *modeFrame = self.tableArray[indexPath.row];
    
    RudderLordViewController *dVC = [[RudderLordViewController alloc] init];
    dVC.hidesBottomBarWhenPushed = YES;
    dVC.sData = modeFrame.sModel;
    [self.navigationController pushViewController:dVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
