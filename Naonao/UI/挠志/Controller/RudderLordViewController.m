//
//  RudderLordViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/7/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "RudderLordViewController.h"
#import "ParallaxHeaderView.h"
#import "RudderDesCell.h"
#import "RudderDesModeFrame.h"
#import "RudderTTCell.h"
#import "FavGoodsCell.h"
#import "MagazineLogic.h"
#import "STGoodsMainViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommunityLogic.h"
#import "STUserInfo.h"
#import "STPhotoBrowserViewController.h"

#define M_HEARD_OX     0.518f

@interface RudderLordViewController ()<UITableViewDataSource, UITableViewDelegate, FavGoodsCellDelegate, STPhotoBrowserViewControllerDelegate, STPhotoBrowserViewControllerDataSource, RudderDesCellDelegate>

@property (nonatomic, weak) ParallaxHeaderView *headV;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) RudderDesModeFrame *modeFrame;

@property (nonatomic, strong) NSArray *goodsArray;
@property (nonatomic, strong) NSArray *links;

@end


@implementation RudderLordViewController

// 状态栏设置成白色
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINBOUNDS style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //初始化数据
    _modeFrame = [[RudderDesModeFrame alloc] init];
    _modeFrame.sData = _sData;
    
    ParallaxHeaderView *headV =  [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*M_HEARD_OX)];
    _headV = headV;
    _headV.headerURL = _sData.extraInfo.background;
    [_tableView setTableHeaderView:_headV];
    
    [self setupNavbarButtons];
    [self getFavGoodsList];
    [self getUserInfo];
}

// 设置顶部自定义导航栏
- (void)setupNavbarButtons
{
    UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [navView setImage:[UIImage imageNamed:@"nav_shadow.png"]];
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(-10, 22, 64, 40);
    [backBtn setImage:[UIImage imageNamed:@"nav_back_whitle.png"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    

    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -64)/2, SCREEN_WIDTH*M_HEARD_OX - 50 , 64, 64)];
    //圆角
    headV.layer.cornerRadius = CGRectGetHeight(headV.frame)/2;                     //设置那个圆角的有多圆
    headV.layer.masksToBounds = YES;                                               //设为NO去试试
    headV.layer.borderWidth = 2;                                                   //设置边框的宽度，当然可以不要
    headV.layer.borderColor = [[UIColor colorWithHex:0xE7E1CE] CGColor];           //设置边框的颜色
    [headV sd_setImageWithURL:[NSURL URLWithString:[_sData.avatar smallHead]] placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    
    [self.tableView addSubview:headV];
}

- (void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//喜欢的商品列表
- (void)getFavGoodsList {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:_sData.userid forKey:@"uid"];
    
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

- (void)getUserInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_sData.userid forKey:@"uid"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[CommunityLogic sharedInstance] getUserInfo:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            STUserInfo *userInfo = result.mObject;
            weakSelf.headV.style = userInfo.scoresInfo.style;

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }

    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _modeFrame.rowHeight;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 44;
        }
        else{
            CGFloat m_H = K_S_W + 50;
            NSUInteger mRow = _goodsArray.count/2 +  _goodsArray.count%2;
            
            return m_H*mRow+ 15;
        }
    }
    
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        RudderDesCell *cell = [RudderDesCell cellWithTableView:tableView];
        cell.modeFrame = _modeFrame;
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 1){
        if(indexPath.row == 0){
            RudderTTCell *cell = [RudderTTCell cellWithTableView:tableView];
            return cell;
        }
        
        FavGoodsCell *cell = [FavGoodsCell cellWithTableView:tableView];
        cell.delegate = self;
        [cell setCellWithCellInfo:_goodsArray];
        return cell;
    }
    
    return nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

#pragma mark - FavGoodsCellDelegate
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

#pragma mark - RudderDesCellDelegate
- (void)rudderDesCell:(RudderDesCell *)mView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *temA = [[NSMutableArray alloc] initWithCapacity:self.modeFrame.sData.extraInfo.photos.count];
    
    for (NSString *urlS in self.modeFrame.sData.extraInfo.photos) {
        STBrowserPhoto *photo = [[STBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:urlS];
        [temA addObject:photo];
    }
    
    _links = temA;

    STPhotoBrowserViewController *broswerVC = [[STPhotoBrowserViewController alloc] init];
    broswerVC.delegate = self;
    broswerVC.dataSource = self;
    broswerVC.showType = STShowImageTypeImageURL;
    // 当前选中的值
    broswerVC.currentIndexPath = indexPath;
    
    [self.navigationController pushViewController:broswerVC animated:YES];
}


#pragma mark - STPhotoBrowserViewControllerDataSource
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(STPhotoBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(STPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return _links.count;
}

- (STBrowserPhoto *)photoBrowser:(STPhotoBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    return [_links objectAtIndex:indexPath.item];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
