//
//  ShapeInfoViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ShapeInfoViewController.h"
#import "STShapeViewController.h"
#import "PersonalInfoViewController.h"
#import "ICDPopupMenu.h"
#import "UserLogic.h"
#import "ShapeInfoCell.h"


@interface ShapeInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *intestArray;

@end

@implementation ShapeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"nav_back.png" imgHighlight:@"nav_back_highlighted.png" imgSelected:nil target:self action:@selector(back:)]];
    
    if([UserLogic sharedInstance].isPOP)
    {
        [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"继续" target:self action:@selector(nextTapped:)]];
    }
    else
    {
        [self setNavBarRightBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"more_point.png" imgHighlight:@"more_point_highlighted.png" imgSelected:nil target:self action:@selector(moreBtnTapped:)]];
    }

    [self setNavBarTitle:@"我的身材信息"];
    
    [self getInterestCircleList];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:NO];
}

- (void)nextTapped:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:NULL];
    [UserLogic sharedInstance].isPOP = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_USER_DATA" object:nil];
    
    [theAppDelegate popCenterView];
}

//获取我的兴趣爱好
- (void)getInterestCircleList
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:[UserLogic sharedInstance].user.basic.userId forKey:@"uid"];
    
    __weak typeof(self) weakSelf = self;
    [[UserLogic sharedInstance] queryInterestCircleData:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _intestArray = result.mObject;
            [weakSelf.tableView reloadData];
        }
        else
            [theAppDelegate.window makeToast:result.stateDes];
    }];
}

- (void)back:(id)sender
{
    if([UserLogic sharedInstance].isPOP)
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
        [UserLogic sharedInstance].isPOP = NO;
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_USER_DATA" object:nil];
}


- (void)moreBtnTapped:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    ICDPopupMenu *menu = [[ICDPopupMenu alloc] initWithMenuSize:CGSizeMake(90, 90)];
    NSMutableArray *itemArray = [NSMutableArray new];
    
    for (NSDictionary *menuDic in [self menuDicArray]) {
        ICDPopupMenuItem *item = [[ICDPopupMenuItem alloc] initWithTitle:menuDic[@"title"] imageName:menuDic[@"image"]];
        [itemArray addObject:item];
    }
    
    menu.itemArray = itemArray;
    menu.tintColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    
    __weak typeof(self) weakSelf = self;
    menu.actionHandler = ^(ICDPopupMenu *view, NSUInteger index) {
        
        switch (index) {
            case 0:
            {
                STShapeViewController *sVC = CREATCONTROLLER(STShapeViewController);
                [weakSelf.navigationController pushViewController:sVC animated:YES];
            }
                break;
                
            case 1:
                //删除个人身材信息
                AlertWithTitleAndMessageAndUnits(@"您确定要删除当前的身材信息？", nil, self, @"确定", nil);
                break;
                
            default:
                break;
        }
    };

    [menu showFromStartView:button arrowPositon:ICDPopupMenuArrowPositionTopRight];
}


- (NSArray *)menuDicArray {
    return @[@{@"title":@"编辑",
               @"image":@"icon_edit_white.png"
               },
             @{@"title":@"删除",
               @"image":@"icon_trash_white.png"
               }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        __weak typeof(self) weakSelf = self;
        
        //删除个人身材信息
        [[UserLogic sharedInstance] userRestBodyParamCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                [weakSelf back:nil];
            }
            else
                [theAppDelegate.window makeToast:result.stateDes];
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShapeInfoCell *cell = [ShapeInfoCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:indexPath.row setArray:_intestArray];
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
