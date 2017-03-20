//
//  UserCenterViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/4/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "UserCenterViewController.h"
#import "CommunityLogic.h"
#import "STUserInfo.h"
#import "MagazineLogic.h"
#import "UserHeadView.h"
#import "FavGoodsCell.h"
#import "MagazineInfo.h"
#import "STGoodsMainViewController.h"
#import "UserLogic.h"
#import "DemandLogic.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LewPopupViewAnimationFade.h"
#import "InterestModel.h"
#import "STUserInfo.h"
#import "STPopupView.h"
#import "STPopBodyView.h"
#import "RudderTTCell.h"


@interface UserCenterViewController ()<UITableViewDataSource, UITableViewDelegate, UserHeadViewDelegate, FavGoodsCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) STUserInfo *userInfo;

@property (nonatomic, weak) UserHeadView *headV;
@property (nonatomic, strong) NSArray *goodsArray;          //商品数据

@property (nonatomic, strong) NSArray *intestArray;
@property (nonatomic, strong) NSArray *styleArray;
@property (nonatomic, strong) STBodyStyle *body;

@property (nonatomic, weak) UIView * downView;
@property (nonatomic, weak) UIView * bgView;
@end


@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BACKGROUND_GARY_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:NO];

    
    UserHeadView *headV = [UserHeadView personalHeaderViewWithCGSize:CGSizeMake(SCREEN_WIDTH, 254.0)];
    _headV = headV;
    _headV.delegate = self;
    [_tableView setTableHeaderView:_headV];

    //获取个人信息
    [self getUserInfo];
    
    [self getFavGoodsList];
}

- (void)getUserInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_userId forKey:@"uid"];

    __typeof (&*self) __weak weakSelf = self;
    
    [[CommunityLogic sharedInstance] getUserInfo:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.userInfo = result.mObject;
            [weakSelf setNavBarTitle:_userInfo.userName];
            [weakSelf.headV updateUI:weakSelf.userInfo];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44.0;
    }
    
    CGFloat m_H = K_S_W + 50;
    NSUInteger mRow = _goodsArray.count/2 +  _goodsArray.count%2;
    
    return m_H*mRow+ 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RudderTTCell *cell = [RudderTTCell cellWithTableView:tableView];
        return cell;
    }
    else if (indexPath.row == 1){
        FavGoodsCell *cell = [FavGoodsCell cellWithTableView:tableView];
        cell.delegate = self;
        [cell setCellWithCellInfo:_goodsArray];
        return cell;
    }

    return nil;
}


//增加提示语句
- (void)addPromptView {
    UILabel *mL = (UILabel *)[self.view viewWithTag:0x256];
    if (!mL)
    {
        mL = [[UILabel alloc] initWithFrame:CGRectMake(30, 350, SCREEN_WIDTH-60, 50)];
        mL.numberOfLines = 2;
        [mL setTextAlignment:NSTextAlignmentCenter];
        [mL setFont:[UIFont systemFontOfSize:14.0]];
        [mL setTextColor:BLACK_COLOR];
        mL.tag = 0x256;
        [mL setText:@"TA还没有收藏任何商品"];
    }
    
    
    [self.tableView addSubview:mL];
}


//删除提示语句
- (void)removePromptView {
    UILabel *mL = (UILabel *)[self.tableView viewWithTag:0x256];
    if (mL) {
        [mL removeFromSuperview];
    }
}


//喜欢的商品列表
- (void)getFavGoodsList {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:_userId forKey:@"uid"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[MagazineLogic sharedInstance] favoriteGoodsList:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.goodsArray = (NSArray *)result.mObject;
            [weakSelf.tableView reloadData];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
    }];
}



#pragma mark -UserHeadViewDelegate
- (void)updateUserHeadView {
    [_tableView reloadData];
}

- (void)userHeadView:(UserHeadView *)mView indexWithBtn:(NSUInteger)index {
    switch (index) {
        case 1:
        {
            if (!_intestArray) {
                [self getInterestList];
            }
            else
            {
                [self addPopView:YES];
            }
        }
            
            break;
            
        case 2:
        {
            if (!_styleArray) {
                [self getUserStyles];
            }
            else
            {
                [self addPopView:NO];
            }
        }
            
            break;
            
        case 3:
        {
            if (!_body) {
                [self getUserBodyPara];
            }
            else
                [self setBodyView];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark FavGoodsCellDelegate
- (void)goodsCell:(FavGoodsCell *)cell didSelectRowWithData:(FavGoodsModel *)cInfo
{
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
    mcInfo.productId = cInfo.productId;
    mcInfo.coverUrl = cInfo.imgUrl;
    
    
    STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
    goodsVC.mInfo = mcInfo;
    goodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsVC animated:YES];
}


//获取兴趣圈子
- (void)getInterestList {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_userId forKey:@"uid"];
    
    [[UserLogic sharedInstance] queryInterestCircleData:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _intestArray = result.mObject;
            [self addPopView:YES];
        }
        else
        {
            
        }
    }];
}


//获取风格标签
- (void)getUserStyles {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_userId forKey:@"uid"];
    
    [[UserLogic sharedInstance] queryUserStyles:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            NSArray *temA = result.mObject;
            
            NSMutableArray *tA = [NSMutableArray arrayWithCapacity:temA.count];
            
            for(styleModel *sm in [DemandLogic sharedInstance].demandMenu.styleArray)
            {
                for(NSNumber *mA in temA)
                {
                    if ([sm.mId integerValue] == [mA integerValue]) {
                        [tA addObject:sm];
                    }
                }
            }
            
            _styleArray = tA;
            
            [self addPopView:NO];
        }
        else
        {
            
        }
    }];
}

//身材参数
- (void)getUserBodyPara {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_userId forKey:@"uid"];
    
    [[UserLogic sharedInstance] queryUserBodyPara:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _body = result.mObject;
            
            [self setBodyView];
        }
        else
        {
            
        }
    }];
}

//自定义view
- (void)addPopView:(BOOL)isA {
    //弹出设置
    STPopupView *view = [STPopupView defaultPopupView];
    view.parentVC = self;
    
    if (isA) {
        view.dataArray = _intestArray;
    }
    else {
        view.dataArray = _styleArray;
    }
    
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        CLog(@"动画结束");
    }];

}

- (void)setBodyView
{
    STPopBodyView *view = [STPopBodyView defaultPopupView];
    view.parentVC = self;
    view.body = _body;
    [self lew_presentPopupView:view animation:[LewPopupViewAnimationFade new] dismissed:^{
        CLog(@"动画结束");
    }];
    
}


//确认后移除所有view
- (void)buttonAction
{
    [self.bgView removeFromSuperview];
    [self.downView removeFromSuperview];
    self.bgView = nil;
    self.downView = nil;
}


@end
