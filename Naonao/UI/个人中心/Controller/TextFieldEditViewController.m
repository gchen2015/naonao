//
//  TextFieldEditViewController.m
//  MeeBra
//
//  Created by Richard Liu on 15/9/22.
//  Copyright © 2015年 广州杉川投资管理有限公司. All rights reserved.
//

#import "TextFieldEditViewController.h"

@interface TextFieldEditViewController ()<RETableViewManagerDelegate>

@property (strong, readwrite, nonatomic) RETableViewSection *section1;
@property (strong, readwrite, nonatomic) RETextItem *ueserName;                 //用户名

@end

@implementation TextFieldEditViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"昵称"];
    
    //保存按钮
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"保存" target:self action:@selector(saveButtonTapped:)]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    [self.view addSubview:_tableView];
    _manager = [[RETableViewManager alloc] initWithTableView:_tableView delegate:self];
    self.manager.style.cellHeight = 44.0;
    self.section1 = [self addSectionA];
    
    [self resetScrollView:self.tableView tabBar:NO];

}

- (RETableViewSection *)addSectionA
{
    // Add sections and items
    RETableViewSection *section = [RETableViewSection section];
    [_manager addSection:section];
    NSMutableArray *collapsedItems = [NSMutableArray array];
    
    self.ueserName = [RETextItem itemWithTitle:nil value:[UserLogic sharedInstance].user.basic.userName placeholder:@"昵称"];
    self.ueserName.clearsOnBeginEditing = YES;
    [collapsedItems addObjectsFromArray:@[self.ueserName]];
    [section addItemsFromArray:collapsedItems];
    
    return section;
}



- (void)saveButtonTapped:(id)sender{
    if(self.ueserName.value.length > 15)
    {
        [self.view makeToast:@"昵称不能大于15个字符"];
        return;
    }
    
    NSString *st = [[UserLogic sharedInstance].user.basic.userName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([_ueserName.value isEqualToString:st]) {
        [self.view makeToast:@"昵称未做修改，无需保存"];
        return;
    }
    
    if ([_ueserName.value isEqualToString:@""]) {
        [self.view makeToast:@"昵称不能为空"];
        return;
    }
    
    [self updateUserInfo];
}


//更新个人资料
- (void)updateUserInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    //昵称（支持Emoji）
    [dict setObject:[Units encodeToPercentEscapeString:_ueserName.value] forKey:@"nickname"];
    
    if ([UserLogic sharedInstance].user.basic.gender) {
        //性别
        [dict setObject:[UserLogic sharedInstance].user.basic.gender forKey:@"gender"];
    }
    else{
        [dict setObject:@"famale" forKey:@"gender"];
    }
    

    
    __typeof (&*self) __weak weakSelf = self;
    [[UserLogic sharedInstance] modifyUserData:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //成功
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
