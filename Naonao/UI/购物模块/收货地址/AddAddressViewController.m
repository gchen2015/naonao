//
//  AddAddressViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AddAddressViewController.h"
#import "ShoppingLogic.h"
#import "RETableViewManager.h"
#import "AddressPickView.h"
#import "LXActionSheet.h"
#import "UserLogic.h"

@interface AddAddressViewController ()<RETableViewManagerDelegate, LXActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) RETableViewManager *manager;
@property (nonatomic, weak) UITableView *tableView;

@property (strong, nonatomic) RETableViewSection *section1;
@property (strong, nonatomic) RETableViewSection *section2;
@property (strong, nonatomic) RETextItem *nameItem;                 //姓名
@property (strong, nonatomic) RENumberItem *phoneItem;              //手机
@property (strong, nonatomic) RENumberItem *codeItem;               //邮编
@property (strong, nonatomic) RERadioItem *areaItem;                //区域
@property (strong, nonatomic) RELongTextItem *addressItem;          //地址

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_mTYPE == K_EDIT_TYPE) {
        [self setNavBarTitle:@"编辑地址"];
    }
    else
        [self setNavBarTitle:@"添加新地址"];
    
    if(!_mInfo)
    {
        _mInfo = [[AddressInfo alloc] init];
    }
    
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"保存" target:self action:@selector(saveTapped:)]];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    [self.view addSubview:_tableView];
    _manager = [[RETableViewManager alloc] initWithTableView:_tableView delegate:self];

    [self resetScrollView:self.tableView tabBar:NO];

    self.section1 = [self addSectionA];
}

#pragma mark 自定义表格
- (RETableViewSection *)addSectionA
{
    // Add sections and items
    RETableViewSection *section = [RETableViewSection section];
    [_manager addSection:section];
    NSMutableArray *collapsedItems = [NSMutableArray array];
    
    self.nameItem = [RETextItem itemWithTitle:@"收货人" value:_mInfo.name placeholder:@"姓名"];
    self.phoneItem = [RENumberItem itemWithTitle:@"联系方式" value:_mInfo.telephone placeholder:@"手机号码"];
    self.codeItem = [RENumberItem itemWithTitle:@"邮政编码" value:_mInfo.zipcode placeholder:@"邮政编码"];

    NSString *aS = nil;
    if (_mInfo.province) {
        if (_mInfo.country.length > 0) {
            aS = [NSString stringWithFormat:@"%@, %@, %@", _mInfo.province, _mInfo.city, _mInfo.country];
        }
        else
            aS = [NSString stringWithFormat:@"%@, %@", _mInfo.province, _mInfo.city];
    }

    self.areaItem = [[RERadioItem alloc] initWithTitle:@"省/市/区" value:aS selectionHandler:^(RERadioItem *item) {
        AddressPickView *addressPickView = [AddressPickView shareInstance];
        [self.view addSubview:addressPickView];
        addressPickView.block = ^(NSString *province, NSString *city, NSString *town){
            
            if (province) {
                _mInfo.province = province;
                _mInfo.city = city;
                _mInfo.country = town;
                
                if (town) {
                    item.value = [NSString stringWithFormat:@"%@, %@, %@", province, city, town];
                }
                else
                {
                    item.value = [NSString stringWithFormat:@"%@, %@", province, city];
                }
            }
            
            [_tableView reloadData];
        };
    }];
    
    self.addressItem = [RELongTextItem itemWithTitle:nil value:_mInfo.address placeholder:@"街道地址"];
    self.addressItem.cellHeight = 64.0;
    [collapsedItems addObjectsFromArray:@[self.nameItem, self.phoneItem, self.codeItem, self.areaItem, self.addressItem]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    
    return 40.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.0;
}

- (void)saveTapped:(id)sender
{
    if (!self.nameItem.value) {
        [self.view makeToast:@"收件人姓名不能为空"];
        return;
    }
    
    if (!self.phoneItem.value) {
        [self.view makeToast:@"手机号码不能为空"];
        return;
    }
    
    if (!self.codeItem.value) {
        [self.view makeToast:@"邮政编码不能为空"];
        return;
    }
    
    if (!self.areaItem.value) {
        [self.view makeToast:@"省/市/县 信息不能为空"];
        return;
    }
    
    if (!self.addressItem.value) {
        [self.view makeToast:@"详细地址不能为空"];
        return;
    }
    
    //两种情况
    if (_mTYPE == K_EDIT_TYPE)
    {
        //更新地址
        [self updateAddress];
    }
    else
    {
        //添加新的地址
        [self addAddress];
    }
}


- (void)backToLastVC{
    [self.navigationController popViewControllerAnimated:YES];
}


//添加新的地址
- (void)addAddress
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:7];
    [dict setObject:self.nameItem.value forKey:@"name"];
    [dict setObject:self.phoneItem.value forKey:@"telephone"];
    [dict setObject:self.codeItem.value forKey:@"zipcode"];
    [dict setObject:_mInfo.province forKey:@"province"];
    [dict setObject:_mInfo.city forKey:@"city"];
    if (_mInfo.country) {
        [dict setObject:_mInfo.country forKey:@"country"];
    }
    else{
        [dict setObject:@"" forKey:@"country"];
    }
    
    [dict setObject:self.addressItem.value forKey:@"address"];
    
    _mInfo.address = self.addressItem.value;
    _mInfo.zipcode = self.codeItem.value;
    _mInfo.telephone = self.phoneItem.value;
    _mInfo.name = self.nameItem.value;
    
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] addAddress:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            NSNumber *addressId = [result.mObject objectForKey:@"address_id"];
            _mInfo.addressId = addressId;
            [weakSelf setDefault];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}


//更新地址
- (void)updateAddress
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:7];
    [dict setObject:self.nameItem.value forKey:@"name"];
    [dict setObject:self.phoneItem.value forKey:@"telephone"];
    [dict setObject:self.codeItem.value forKey:@"zipcode"];
    [dict setObject:_mInfo.province forKey:@"province"];
    [dict setObject:_mInfo.city forKey:@"city"];
    if (_mInfo.country) {
        [dict setObject:_mInfo.country forKey:@"country"];
    }
    else{
        [dict setObject:@"" forKey:@"country"];
    }
    
    [dict setObject:self.addressItem.value forKey:@"address"];
    
    [dict setObject:_mInfo.addressId forKey:@"id"];
    
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] updateAddress:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf backToLastVC];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

//提示设置成默认地址
- (void)setDefault
{
    AlertWithTitleAndMessageAndUnitsToTag(@"是否将该地址设置成默认地址", nil, self, @"确定", nil, 0x128);
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
            [weakSelf backToLastVC];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if(alertView.tag == 0x128)
        {
            //设置成默认地址
            [self setDefaultAddress:_mInfo];
        }
    }
    else
        [self backToLastVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
