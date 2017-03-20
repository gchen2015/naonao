//
//  MyPhotoViewController.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/12.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MyPhotoViewController.h"
#import "UserLogic.h"
#import "BuyyerShowCell.h"
#import "STGoodsMainViewController.h"
#import "MagazineInfo.h"
#import "STPhotoBrowserViewController.h"

@interface MyPhotoViewController ()<UITableViewDataSource, UITableViewDelegate, BuyyerShowCellDelegate, STPhotoBrowserViewControllerDelegate, STPhotoBrowserViewControllerDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) NSArray *links;

@end

@implementation MyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"我的写真"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    [self resetScrollView:self.tableView tabBar:NO];
    //清除多余分割线
//    [self setExtraCellLineHidden:self.tableView];
    
    [self getBuyyerShow];
}

////清除多余分割线
//- (void)setExtraCellLineHidden:(UITableView *)tableView
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    [self.tableView setTableFooterView:view];
//}

- (void)getBuyyerShow{
    __typeof (&*self) __weak weakSelf = self;
    
    [[UserLogic sharedInstance] requestUserBuyyerShow:nil withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _tableArray = (NSArray *)result.mObject;
            [weakSelf.tableView reloadData];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
    }];
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32.0)];//创建一个视图（v_headerView）
    [bgView setBackgroundColor:[UIColor clearColor]];
    
    ShowModel *model = _tableArray[section];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 20)];
    [timeL setTextColor:LIGHT_BLACK_COLOR];
    [timeL setFont:[UIFont systemFontOfSize:13.0]];
    [timeL setText:model.createTime];
    [timeL setTextAlignment:NSTextAlignmentCenter];
    [bgView addSubview:timeL];
    
    return bgView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat mH = 88.0;
    
    CGFloat mW = (SCREEN_WIDTH - 28)/4;
    
    ShowModel *mInfo = _tableArray[indexPath.section];

    int x_o = (int)mInfo.imgArray.count/4;
    int y_o = mInfo.imgArray.count%4;
    
    if (y_o > 0){
        mH += mW*(x_o+1) + 14;
    }
    else{
        mH += mW*x_o + 14;
    }

    return mH;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyyerShowCell *cell = [BuyyerShowCell cellWithTableView:tableView];
    cell.mRow = indexPath.section;
    cell.delegate = self;
    [cell setCellWithCellInfo:_tableArray[indexPath.section]];
    
    return cell;
}

#pragma mark - BuyyerShowCellDelegate
- (void)buycell:(BuyyerShowCell *)cell clickImageIndex:(NSInteger)index cellWithRow:(NSInteger)row
{
    ShowModel *mInfo = _tableArray[row];
    NSMutableArray *temA = [[NSMutableArray alloc] initWithCapacity:mInfo.imgArray.count];
    
    for (NSString *image in mInfo.imgArray) {
        STBrowserPhoto *photo = [[STBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:[image originalImageTurnWebp]];
        [temA addObject:photo];
    }
    
    _links = temA;
    
    STPhotoBrowserViewController *broswerVC = [[STPhotoBrowserViewController alloc] init];
    broswerVC.delegate = self;
    broswerVC.dataSource = self;
    broswerVC.showType = STShowImageTypeImageURL;
    // 当前选中的值
    broswerVC.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.navigationController pushViewController:broswerVC animated:YES];
}


//商品点击
- (void)buycell:(BuyyerShowCell *)cell cellWithRow:(NSInteger)row{
    
    ShowModel *mInfo = _tableArray[row];
    //自营
    MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
    mcInfo.productId = mInfo.product.proId;
    mcInfo.coverUrl = mInfo.product.imageURL;
    
    
    STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
    goodsVC.mInfo = mcInfo;
    goodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsVC animated:YES];
}

#pragma mark - STPhotoBrowserViewControllerDataSource
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(STPhotoBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(STPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.links.count;
}

- (STBrowserPhoto *)photoBrowser:(STPhotoBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.links objectAtIndex:indexPath.item];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
