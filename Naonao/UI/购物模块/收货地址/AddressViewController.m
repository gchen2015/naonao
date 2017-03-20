//
//  AddressViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AddressViewController.h"
#import "AddAddressViewController.h"
#import "ShoppingLogic.h"
#import "STAddressCell.h"
#import "EditAddressCell.h"

@interface AddressViewController ()<UITableViewDataSource, UITableViewDelegate, EditAddressCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"地址管理"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:NO];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self getAddressList];
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


//设置默认地址
- (void)setDefaultAddress:(AddressInfo *)mInfo
{
    __typeof (&*self) __weak weakSelf = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:7];
    [dict setObject:mInfo.addressId forKey:@"address_id"];
    
    [[ShoppingLogic sharedInstance] SetDefaultAddress:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //缓存默认地址，以便下次使用
            [[ShoppingLogic sharedInstance] saveDefaulAddress:mInfo];
            [weakSelf getAddressList];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

// 删除地址
- (void)deleteAddress:(AddressInfo *)mInfo
{
    NSMutableDictionary *pubDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [pubDic setObject:mInfo.addressId forKey:@"address_id"];
    
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithArray:_tableArray];
    
    __typeof (&*self) __weak weakSelf = self;
    [[ShoppingLogic sharedInstance] deleteAddress:pubDic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [tempA removeObject:mInfo];
            weakSelf.tableArray = tempA;
            [weakSelf.tableView reloadData];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return 2;
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
    else{
        if (indexPath.row == 0) {
            return 92.0;
        }
        
        return 45.0;
    }
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
        }
        
        cell.textLabel.text = @"添加新地址";
        
        return cell;
    }
    else
    {
        if (indexPath.row == 0) {
            STAddressCell *mCell = [STAddressCell cellWithTableView:tableView];
            AddressInfo *mInfo = _tableArray[indexPath.section -1];
            [mCell setCellWithCellInfo:mInfo];
            return mCell;
        }
        else
        {
            EditAddressCell *cell = [EditAddressCell cellWithTableView:tableView];
            AddressInfo *mInfo = _tableArray[indexPath.section -1];
            [cell setCellWithCellInfo:mInfo];
            cell.delegate = self;
            return cell;
        }
    }

    return nil;

}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        AddAddressViewController *gVC = [[AddAddressViewController alloc] init];
        gVC.mTYPE = K_NEW_TYPE;
        [self.navigationController pushViewController:gVC animated:YES];
    }
}

#pragma mark - EditAddressCellDelegate
//设置默认地址
- (void)editAddressCell:(EditAddressCell *)cell setDefaultCellInfo:(AddressInfo *)mInfo
{
    [self setDefaultAddress:mInfo];
}

//编辑
- (void)editAddressCell:(EditAddressCell *)cell edictCellInfo:(AddressInfo *)mInfo
{
    AddAddressViewController *gVC = [[AddAddressViewController alloc] init];
    gVC.mTYPE = K_EDIT_TYPE;
    gVC.mInfo = mInfo;
    [self.navigationController pushViewController:gVC animated:YES];
}

//删除
- (void)editAddressCell:(EditAddressCell *)cell deleteCellInfo:(AddressInfo *)mInfo
{
    [self deleteAddress:mInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
