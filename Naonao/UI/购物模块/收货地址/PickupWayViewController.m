//
//  PickupWayViewController.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PickupWayViewController.h"

@interface PickupWayViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation PickupWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"取货方式"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:NO];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.0;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.textLabel setTextColor:BLACK_COLOR];
        
        cell.detailTextLabel.minimumScaleFactor = 0.6f;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightLight]];
        [cell.detailTextLabel setTextColor:PINK_COLOR];
        
        UIImageView *sV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 20, 20, 20)];
        [sV setImage:[UIImage imageNamed:@"icon_selected_no.png"]];
        [cell.contentView addSubview:sV];
    }
    
    NSString *tit = nil;
    NSString *des = nil;
    
    if (indexPath.row == 0) {
        tit = @"快递送达";
        des = @"下单后，48小时内发货";
    }
    else if (indexPath.row == 1) {
        tit = @"门店自取";
        des = @"可免费享受专业化妆、发型，专业摄影棚拍写真服务~";
    }
    cell.textLabel.text = tit;
    cell.detailTextLabel.text = des;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    UIImageView *sV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 20+60*row, 20, 20)];
    [sV setImage:[UIImage imageNamed:@"icon_selected.png"]];
    [self.tableView addSubview:sV];
    
    //延迟执行
    double delayInSeconds = 0.3;
    __typeof (&*self) __weak weakSelf = self;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //马上进入刷新状态
        [weakSelf backToPage:row];
    });
}


- (void)backToPage:(NSInteger)mRow{
    if (_delegate && [_delegate respondsToSelector:@selector(pickView:selectedCellRow:)]) {
        [_delegate pickView:self selectedCellRow:mRow];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
