//
//  ShopCartViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/10.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ShopCartViewController.h"
#import "PaymentOrderViewController.h"
#import "STGoodsMainViewController.h"
#import "ShoppingLogic.h"
#import "ShopCartCell.h"
#import "UITableView+Mascot.h"
#import "MJRefresh.h"
#import "CartStoreCell.h"


@interface ShopCartViewController ()<UITableViewDelegate, UITableViewDataSource, ShopCartCellDelegate, CartStoreCellDelegate>

@property (nonatomic, weak) UILabel *amountL;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tableData;    //购物车数据
@property (nonatomic, strong) NSMutableArray *chooseArray;  //选中的商品

@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, assign) BOOL isEdit;                  //编辑按钮状态

@property (nonatomic, weak) UIButton *settlementBtn;        //结算


@end

@implementation ShopCartViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];

    _isEdit = NO;
    
    //清空数据
    [_chooseArray removeAllObjects];
    [_tableData removeAllObjects];
    [_tableView reloadData];
    
    [self setNavBarTitle:@"购物车"];
    [self updateAmountL:@"￥0.00"];
    
    
    //获取购物车内的商品
    [self getShopCart];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"购物车"];
    
    _tableData = [NSMutableArray array];
    _chooseArray = [NSMutableArray array];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:YES];
    
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setLoadedImageName:@"bird_no_order.png"];
    [self.tableView setDescriptionText:@"购物车空空如也，去挑几件商品吧"];
    [self.tableView setButtonText:@""];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}


- (void)initSelectedTag {
    
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithCapacity:_tableData.count];
    }

    [_selectedArray removeAllObjects];
    
    for (int i = 0; i < _tableData.count; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"selected"];
        
        NSArray *sectionA = _tableData[i];
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:sectionA.count];
        for (int j = 0; j < sectionA.count; j++) {
            [sectionArray addObject:[NSNumber numberWithBool:NO]];
        }
        
        [dic setObject:sectionArray forKey:@"section"];
        
        [_selectedArray addObject:dic];
    }
}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    [self.tableView.mj_header endRefreshing];
    [self getShopCart];
}

- (void)drawUI {
    if (!_isEdit) {
        //底部菜单
        [self initBottomView];
        [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"编辑" target:self action:@selector(editTapped:)]];
    }
    else{
        //
        [self updateBottomView];
    }
}

//获取购物车列表
- (void)getShopCart
{
    // 只需一行代码，我来解放你的代码
    self.tableView.loading = YES;
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] getShopCartList:nil withCallback:^(LogicResult *result) {
        
        self.tableView.loading = NO;
        if(result.statusCode == KLogicStatusSuccess)
        {
            CartData *cDta = result.mObject;
            [_tableData removeAllObjects];
            
            if (cDta) {
                [_tableData addObjectsFromArray:[self arrayGroup:cDta.goodsArray]];
                
                [self setNavBarTitle:[NSString stringWithFormat:@"购物车（%@）", cDta.total]];
                //初始化状态
                [weakSelf initSelectedTag];
                [weakSelf.chooseArray removeAllObjects];
                
                [self drawUI];
            }
            else{
                [weakSelf hideBottomView];
            }
            
            [weakSelf.tableView reloadData];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

// 数组以商家进行分组
- (NSArray *)arrayGroup:(NSArray *)array {
    
    NSMutableSet *shopSet = [NSMutableSet set];
    //收集商户ID
    for (GoodsOData *gData in array){
        [shopSet addObject:gData.store.mId];
    }

    //存储店铺
    NSMutableArray *groupArray = [NSMutableArray array];
    
    for (NSNumber *mID in shopSet) {
        //存储单个店铺中的商品
        NSMutableArray *shopArray = [NSMutableArray array];
        
        [array enumerateObjectsUsingBlock:^(GoodsOData *gData, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([gData.store.mId intValue] == [mID integerValue]){
                [shopArray addObject:gData];
            }
        }];
        
        [groupArray addObject:shopArray];
    }
    
    return groupArray;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionA = _tableData[section];
    return sectionA.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12.0;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0;
    }
    return 114.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CartStoreCell *cell = [CartStoreCell cellWithTableView:tableView];
        NSArray *sectionA = _tableData[indexPath.section];
        cell.delegate = self;
        
        NSDictionary *dic = _selectedArray[indexPath.section];
        
        GoodsOData *goodsTData = sectionA[indexPath.row];
        [cell setCellWithCellInfo:goodsTData.store setChooseBtn:[[dic objectForKey:@"selected"] boolValue] mSection:indexPath.section];
        
        return cell;
    }
    else{
        ShopCartCell *cell = [ShopCartCell cellWithTableView:tableView];
        NSArray *sectionA = _tableData[indexPath.section];
        
        NSDictionary *dic = _selectedArray[indexPath.section];
        NSArray *sectionArray = [dic objectForKey:@"section"];
        
        [cell setCellWithCellInfo:sectionA[indexPath.row-1] setChooseBtn:[[sectionArray objectAtIndex:indexPath.row-1] boolValue] isEdit:_isEdit];
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
    {
        return UITableViewCellEditingStyleNone;
    }
    else{
         return UITableViewCellEditingStyleDelete;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *sectionA = _tableData[indexPath.section];
        [self deleteCellWithTableView:sectionA[indexPath.row - 1] didSelectRowAtIndexPath:indexPath];
    }
}


- (void)deleteCellWithTableView:(GoodsOData *)goodsTData didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    //订单ID
    [dic setObject:[goodsTData.skuTag stringValue] forKey:@"ids"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[ShoppingLogic sharedInstance] getDeleteCart:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            NSMutableArray *sectionA = [NSMutableArray arrayWithArray:weakSelf.tableData[indexPath.section]];
            [sectionA removeObjectAtIndex:indexPath.row-1];
            
            if (sectionA.count == 0) {
                [weakSelf.tableData removeObjectAtIndex:indexPath.section];
            }
            else{
                //替换
                [weakSelf.tableData replaceObjectAtIndex:indexPath.section withObject:sectionA];
            }
            
            
            [weakSelf.tableView reloadData];
            [weakSelf.chooseArray removeAllObjects];
            [weakSelf initSelectedTag];
            
            [weakSelf updateAmountL:@"￥0.00"];
            
            [weakSelf setNavBarTitle:[NSString stringWithFormat:@"购物车（%lu）", (unsigned long)weakSelf.tableData.count]];
            [self hideBottomView];
        }
        else
            [weakSelf.view makeToast:result.stateDes];

    }];
}


#pragma mark - ShopCartCellDelegate
- (void)chooseProduct:(BOOL)isSelected chooseWithInfo:(GoodsOData *)goodsTData goodsClick:(NSIndexPath *)indexPath
{
    if (isSelected) {
        //首先清空其他店铺的数据
        for (GoodsOData *gData in _chooseArray) {
            if ([gData.store.mId integerValue] != [goodsTData.store.mId integerValue]) {
                [_chooseArray removeAllObjects];
                [self initSelectedTag];
                
                break;
            }
        }
        
        [_chooseArray addObject:goodsTData];
        
        //不能同时添加两个不同店铺的商品
        NSArray *sArray = _tableData[indexPath.section];
        if (_chooseArray.count == sArray.count) {
            //该商店已经全部选中
            [self addAllShopWithGoods:indexPath.section];
        }
        else{
            //添加单个商品
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.selectedArray[indexPath.section]];
            NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"section"]];
            
            [sectionArray replaceObjectAtIndex:(indexPath.row - 1) withObject:[NSNumber numberWithBool:YES]];
            [dic setObject:sectionArray forKey:@"section"];
            
            //替换
            [self.selectedArray replaceObjectAtIndex:indexPath.section withObject:dic];
        }
    }
    else
    {
        [_chooseArray removeObject:goodsTData];
        
        if (_chooseArray.count == 0)
        {
            [self initSelectedTag];
        }
        else{
            //删除单个商品
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.selectedArray[indexPath.section]];
            NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"section"]];
            
            [sectionArray replaceObjectAtIndex:(indexPath.row - 1) withObject:[NSNumber numberWithBool:NO]];
            [dic setObject:sectionArray forKey:@"section"];
            
            //替换
            [self.selectedArray replaceObjectAtIndex:indexPath.section withObject:dic];
        }
    }
    
    [_tableView reloadData];
    [self updateBottomView];
}

#pragma mark - CartStoreCellDelegate
- (void)chooseBtnState:(BOOL)isSelected goodsClick:(NSInteger )mSection {
    if (isSelected) {
        //首先清空chooseArray,一次只能买一家店的商品
        [_chooseArray removeAllObjects];
        [self initSelectedTag];
        
        //清空失效的商品之后再添加
        NSMutableArray *temA = [NSMutableArray arrayWithCapacity:0];
        
        for (GoodsOData *gData in _tableData[mSection]) {
            if ([gData.stock integerValue] > 0){
                [temA addObject:gData];
            }
        }
        [_chooseArray addObjectsFromArray:temA];
        
        [self addAllShopWithGoods:mSection];
    }
    else{
        
        [_chooseArray removeAllObjects];
        [self emptyAllShopWithGoods:mSection];
        
    }
    
    [_tableView reloadData];
    [self updateBottomView];
}


- (void)goodsClick:(GoodsOData *)goodsTData
{
    MagazineContentInfo *mInfo = [[MagazineContentInfo alloc] init];
    mInfo.productId = goodsTData.proId;
    mInfo.coverUrl = goodsTData.imageURL;
    
    
    STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
    //推荐者ID
    goodsVC.re_userId = goodsTData.source_uid;
    goodsVC.mInfo = mInfo;
    
    [self.navigationController pushViewController:goodsVC animated:YES];
}

// 更新底部总价（合计）
- (void)updateBottomView
{
    NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (GoodsOData *gTData in _chooseArray) {
        NSDecimalNumber *m = [[NSDecimalNumber decimalNumberWithString:[gTData.price stringValue]]
                              decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[gTData.count stringValue]]];
        total = [total decimalNumberByAdding:m];
    }
    
    [self updateAmountL:[NSString stringWithFormat:@"￥%.2f", [total floatValue]]];
    
}

// 添加底部购买按钮和加入购物车按钮的view
- (void)initBottomView{
    UIView* view = (UIView *)[self.view viewWithTag:0x1024];
    if (!view) {
        UIView* view = [[UIView alloc] init];
        [view setTag:0x1024];
        view.frame = CGRectMake(0, SCREEN_HEIGHT - Bottom_H, SCREEN_WIDTH, Bottom_H);
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        [lineV setBackgroundColor:LIGHT_BLACK_COLOR];
        [view addSubview:lineV];
        
        UILabel *mL = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, 100, Bottom_H)];
        [mL setText:@"合计:"];
        [mL setFont:[UIFont systemFontOfSize:16.0]];
        [view addSubview:mL];
        
        UILabel *amountL = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 120, Bottom_H)];
        _amountL = amountL;
        [_amountL setTextColor:PINK_COLOR];
        
        [_amountL setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:15.0]];
        [self updateAmountL:@"￥0.00"];
        [view addSubview:_amountL];
        
        
        //结算
        UIButton* settlementBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*5/8, 0, SCREEN_WIDTH*3/8, Bottom_H)];
        _settlementBtn = settlementBtn;
        [_settlementBtn setTitle:@"结算" forState:UIControlStateNormal];
        [_settlementBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_settlementBtn setBackgroundImage:[UIImage imageNamed:@"ST_btn_11.png"] forState:UIControlStateNormal];
        [_settlementBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateHighlighted];
        [_settlementBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateSelected];
        [_settlementBtn addTarget:self action:@selector(settlementTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_settlementBtn];
        
        [self.view addSubview:view];
    }
    else
        [self updateBottomView];
}

#pragma mark - 按钮点击事件
//结算
- (void)settlementTapped:(id)sender
{
    if (_chooseArray.count == 0)
    {
        [self.view makeToast:@"您还没有选择宝贝哦~"];
        return;
    }
    
    
    if (_isEdit) {
        //删除
        NSMutableArray *temp = [NSMutableArray array];
        for (GoodsOData *gData in _chooseArray) {
            [temp addObject:gData.skuTag];
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
        //订单ID
        [dic setObject:[temp componentsJoinedByString:@"|"] forKey:@"ids"];
        
        __typeof (&*self) __weak weakSelf = self;
        [[ShoppingLogic sharedInstance] getDeleteCart:dic withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                //重新获取购物车数据
                [weakSelf getShopCart];
                
                [weakSelf.chooseArray removeAllObjects];
                [weakSelf.amountL setText:@"￥0.00"];
                
                [weakSelf setNavBarTitle:[NSString stringWithFormat:@"购物车（%lu）", (unsigned long)weakSelf.tableData.count]];
                
                [self hideBottomView];
            }
            else
                [weakSelf.view makeToast:result.stateDes];
        }];
        
        
    }
    else
    {
        //结算
        [ShoppingLogic sharedInstance].orderArray = _chooseArray;
        
        PaymentOrderViewController *pVC = [[PaymentOrderViewController alloc] init];
        [self.navigationController pushViewController:pVC animated:YES];
    }
}

- (void)editTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _isEdit = YES;
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        
        [_settlementBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_settlementBtn setBackgroundImage:[UIImage imageNamed:@"ST_btn_14.png"] forState:UIControlStateNormal];
    }
    else {
        _isEdit = NO;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        
        [_settlementBtn setTitle:@"结算" forState:UIControlStateNormal];
        [_settlementBtn setBackgroundImage:[UIImage imageNamed:@"ST_btn_11.png"] forState:UIControlStateNormal];
    }
    
    [_tableView reloadData];
}


- (void)hideBottomView{
    
    if (_tableData.count == 0) {
        [self setNavBarRightBtn:nil];
        [self setNavBarTitle:@"购物车"];
        
        UIView* view = (UIView *)[self.view viewWithTag:0x1024];
        if (view) {
            [view removeFromSuperview];
        }
    }
}

- (void)updateAmountL:(NSString *)st{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:24.0] range:NSMakeRange(1, st.length-4)];
    _amountL.attributedText = str;
    
}

#pragma mark - 私有方法
// 选中一个店铺的所有商品
- (void)addAllShopWithGoods:(NSInteger)mSection {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithBool:YES] forKey:@"selected"];
    
    NSArray *sectionA = _tableData[mSection];
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:sectionA.count];
    for (int j = 0; j < sectionA.count; j++) {
        [sectionArray addObject:[NSNumber numberWithBool:YES]];
    }
    
    [dic setObject:sectionArray forKey:@"section"];
    
    //替换
    [self.selectedArray replaceObjectAtIndex:mSection withObject:dic];
}

// 清空一个店铺
- (void)emptyAllShopWithGoods:(NSInteger)mSection {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"selected"];
    
    NSArray *sectionA = _tableData[mSection];
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:sectionA.count];
    for (int j = 0; j < sectionA.count; j++) {
        [sectionArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    [dic setObject:sectionArray forKey:@"section"];
    
    //替换
    [self.selectedArray replaceObjectAtIndex:mSection withObject:dic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
