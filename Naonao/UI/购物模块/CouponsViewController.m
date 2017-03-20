//
//  CouponsViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CouponsViewController.h"
#import "ShoppingLogic.h"
#import "UITableView+Mascot.h"
#import "MJRefresh.h"
#import "CouponsCell.h"
#import "QRCodeView.h"
#import "LewPopupViewAnimationFade.h"


@interface CouponsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;

@end

@implementation CouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"优惠券"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:BACKGROUND_GARY_COLOR];
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:NO];
    
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setLoadedImageName:@"bird_no_order.png"];
    [self.tableView setDescriptionText:@"还没有优惠券，去别处看看吧"];
    
    [self.tableView setButtonText:@""];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [self getCouponList];
}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self.tableView.mj_header endRefreshing];
    
    [self getCouponList];
}


//获取优惠券列表
- (void)getCouponList
{
    // 只需一行代码，我来解放你的代码
    self.tableView.loading = YES;
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] getCouponList:nil withCallback:^(LogicResult *result) {
        self.tableView.loading = NO;
        if(result.statusCode == KLogicStatusSuccess)
        {
            self.tableData = result.mObject;
            [weakSelf.tableView reloadData];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.tableData.count-1) {
        return 20.0;
    }
    return 0.1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponsCell *cell = [CouponsCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:_tableData[indexPath.section]];
    return cell;
}




#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isPAY) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (_delegate && [_delegate respondsToSelector:@selector(updateCouponsUI:)] )  {
            [_delegate updateCouponsUI:_tableData[indexPath.section]];
        }
        
        __typeof (&*self) __weak weakSelf = self;
        //延迟函数
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });

    }
    else{
        CouponsModel * cModel = _tableData[indexPath.section];
        //弹出设置
        QRCodeView *view = [QRCodeView defaultPopupView];
        view.parentVC = self;
        view.couponId = cModel.mId;

        [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
            CLog(@"动画结束");
        }];
        

    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
