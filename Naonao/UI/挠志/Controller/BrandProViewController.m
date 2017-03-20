//
//  BrandProViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/8/5.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "BrandProViewController.h"
#import "STGoodsMainViewController.h"
#import "ParallaxHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BrandIntroduceCell.h"
#import "BrandGoodsCell.h"
#import "MagazineInfo.h"
#import "MagazineLogic.h"


#define K_S_W   (SCREEN_WIDTH-15*3)/2.0f     //单个高度
#define M_HEARD_OX     0.458f

@interface BrandProViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) ParallaxHeaderView *headV;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) STBrand *brandInfo;

@end

@implementation BrandProViewController

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
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINBOUNDS style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self setupNavbarButtons];
    [self getMagazineDetails];
}

- (void)drawHeadUI{
    _headV.headerURL = _brandInfo.content.background;
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -64)/2, SCREEN_WIDTH*M_HEARD_OX - 50 , 64, 64)];
    //圆角
    headV.layer.cornerRadius = CGRectGetHeight(headV.frame)/2;                     //设置那个圆角的有多圆
    headV.layer.masksToBounds = YES;                                               //设为NO去试试
    headV.layer.borderWidth = 2;                                                   //设置边框的宽度，当然可以不要
    headV.layer.borderColor = [[UIColor colorWithHex:0xE7E1CE] CGColor];           //设置边框的颜色
    [headV sd_setImageWithURL:[NSURL URLWithString:[_brandInfo.content.logo smallHead]] placeholderImage:[UIImage imageNamed:@"default_merchants.png"]];
    
    [self.tableView addSubview:headV];
}

// 获取品牌详情
- (void)getMagazineDetails{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_brandID forKey:@"id"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[MagazineLogic sharedInstance] magazineDetails:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.brandInfo = result.mObject;
            [weakSelf.tableView reloadData];
            [weakSelf drawHeadUI];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }

    }];
}

// 设置顶部自定义导航栏
- (void)setupNavbarButtons
{
    ParallaxHeaderView *headV =  [ParallaxHeaderView parallaxHeaderViewWithCGSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*M_HEARD_OX)];
    _headV = headV;
    [_tableView setTableHeaderView:_headV];
    
    
    UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [navView setImage:[UIImage imageNamed:@"nav_shadow.png"]];
    [self.view addSubview:navView];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(-10, 22, 64, 40);
    [backBtn setImage:[UIImage imageNamed:@"nav_back_whitle.png"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_brandInfo) {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        BrandIntroduceCell *cell = [BrandIntroduceCell cellWithTableView:tableView];
        [cell setCellWithCellInfo:_brandInfo];
        return cell.height;
    }
    else if (indexPath.row == 1){
        BrandGoodsCell *cell = [BrandGoodsCell cellWithTableView:tableView];
        [cell setCellWithCellInfo:_brandInfo];
        return cell.height;
    }

    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        BrandIntroduceCell *cell = [BrandIntroduceCell cellWithTableView:tableView];
        [cell setCellWithCellInfo:_brandInfo];
        return cell;
    }
    else if (indexPath.row == 1){
        BrandGoodsCell *cell = [BrandGoodsCell cellWithTableView:tableView];
        cell.rootVC = self;
        [cell setCellWithCellInfo:_brandInfo];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
