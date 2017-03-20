//
//  ORAddressViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/4/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ORAddressViewController.h"
#import "AddAddressViewController.h"
#import "ShoppingLogic.h"
#import "STSelcetedAddressCell.h"
#import "AddressViewController.h"

@interface ORAddressViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;

@end


@implementation ORAddressViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self getAddressList];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"选择收货地址"];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"管理" target:self action:@selector(managementTapped:)]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:NO];
}


//获取收货地址列表
- (void)getAddressList
{
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] getAddressList:nil withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.tableArray = (NSArray *)result.mObject;
            [weakSelf.tableView reloadData];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_tableArray.count == 0) {
        return 1;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return _tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 12.0;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.0;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45.0;
    }
    
    return 92;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            
            
            cell.detailTextLabel.minimumScaleFactor = 0.6f;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
            [cell.detailTextLabel setTextColor:LIGHT_BLACK_COLOR];
            
//            UIButton
        }
        
        cell.textLabel.text = @"添加新地址";
        
        return cell;
    }
    
    STSelcetedAddressCell *mCell = [STSelcetedAddressCell cellWithTableView:tableView];
    AddressInfo *mInfo = _tableArray[indexPath.row];
    [mCell setCellWithCellInfo:mInfo compareAddressInfo:_selectModel];
    
    mCell.selctBtn.tag = indexPath.row;
    [mCell.selctBtn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return mCell;
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        AddAddressViewController *gVC = [[AddAddressViewController alloc] init];
        gVC.mTYPE = K_NEW_TYPE;
        gVC.mInfo = nil;
        
        [self.navigationController pushViewController:gVC animated:YES];
    }
}

//选中
- (void)ClickBtn:(UIButton *)btn
{
    if (self.selectModel) {
        if([self.selectModel.isSelected boolValue])
        {
            self.selectModel.isSelected = [NSNumber numberWithBool:NO];
        }
        else
            self.selectModel.isSelected = [NSNumber numberWithBool:YES];
    }
    
    AddressInfo *model = _tableArray[btn.tag];
    
    if (![model.isSelected boolValue]) {
        
        if([model.isSelected boolValue])
        {
            model.isSelected = [NSNumber numberWithBool:NO];
        }
        else
            model.isSelected = [NSNumber numberWithBool:YES];
        
        self.selectModel = model;
    }
    
    [self.tableView reloadData];
    
    //延迟执行
    if ([self.selectModel.isSelected boolValue]) {
        if (_delegate && [_delegate respondsToSelector:@selector(selectedAddressInfo:)]) {
            [_delegate selectedAddressInfo:self.selectModel];
            
            [self performSelector:@selector(jumpToLastVC) withObject:nil afterDelay:0.3];
        }
    }
}

- (void)jumpToLastVC
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)managementTapped:(id)sender
{
    AddressViewController *pVC = [[AddressViewController alloc] init];
    [self.navigationController pushViewController:pVC animated:YES];
}


@end
