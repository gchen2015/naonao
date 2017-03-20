//
//  SexSelectionViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/12/11.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SexSelectionViewController.h"

@interface SexSelectionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;

@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation SexSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    User *user = [[UserLogic sharedInstance] getUser];
    

    [self setNavBarTitle:@"性别选择"];
    _tableArray = [[NSArray alloc] initWithObjects:@"女", @"男", nil];
    if ([user.basic.gender isEqualToString:@"female"]) {
        _currentIndex = 0;
    }
    else
        _currentIndex = 1;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:NO];

    
    [self setExtraCellLineHidden:tableView];
}

//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == _currentIndex){
        return UITableViewCellAccessoryCheckmark;
    }
    else{
        return UITableViewCellAccessoryNone;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"HeadCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
        [cell.textLabel setTextColor:BLACK_COLOR];
        
    }
    cell.textLabel.text = _tableArray[indexPath.row];
    
    return cell;
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == _currentIndex){
        return;
    }
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    _currentIndex = indexPath.row;
    [self updateUserInfo:indexPath.row];

}


- (void)updateUserInfo:(NSUInteger)row
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSString *sex = nil;
    if (row == 0) {
        sex = @"female";
    }
    else
        sex = @"male";
    
    //性别
    [dict setObject:sex forKey:@"gender"];
    
    [self sendRequest:dict];
}

//更新个人资料
- (void)sendRequest:(NSDictionary *)dic
{
    __typeof (&*self) __weak weakSelf = self;
    [[UserLogic sharedInstance] modifyUserData:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //成功
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
    
}


@end
