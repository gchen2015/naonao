//
//  STGoodsDetailsViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STGoodsDetailsViewController.h"
#import "ShopCartViewController.h"
#import "PaymentOrderViewController.h"
#import "MQChatViewManager.h"
#import "STCircleHeadView.h"
#import "STJSONSerialization.h"
#import "ShoppingLogic.h"
#import "GoodsNameCell.h"
#import "BrandCell.h"
#import "MLEmojiLabel.h"
#import "DesModeCell.h"
#import "DPWebViewController.h"
#import "STContentCell.h"
#import "GoodsCommentsCell.h"
#import "RecommandCell.h"
#import "STGoodsMainViewController.h"
#import "STBrandIntroduceViewController.h"
#import "STGoodsCommentsViewController.h"
#import "CatZanButton.h"
#import "MagazineLogic.h"
#import "ShareLogic.h"
#import "AppointmentDateViewController.h"
#import "STNavigationController.h"
#import "FigureGuideViewController.h"

@interface STGoodsDetailsViewController ()<UITableViewDataSource, UITableViewDelegate, STContentCellDelegate, DesModeViewDelegate, BrandCellDelegate, GoodsCommentsCellDelegate, RecommandCellDelegate>

@property (nonatomic, weak) UIImageView *navView;
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) CatZanButton *favButton;  //喜欢按钮
@property (nonatomic, weak) UIButton *cartBtn;        //购物车
@property (nonatomic, weak) UIButton *shareBtn;       //分享

@property (nonatomic, weak) STCircleHeadView *headerView;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) GoodsInfo *gInfo;
@property (nonatomic, strong) GoodsDetailInfo *desInfo;
@property (nonatomic, strong) SizeUrlInfo *sizeInfo;

@property (nonatomic, assign) NSUInteger allSections;   //全部的Sections
@property (nonatomic, assign) BOOL isDes;               //是否选中商品详情
@property (nonatomic, assign) BOOL isLeft;              //是否选中购物说明

@end


@implementation STGoodsDetailsViewController

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
    _isDes = YES;
    _isLeft = YES;
    
    //先清空上一次的残余数据
    [self clearData];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - Bottom_H) style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.backgroundColor = BACKGROUND_GARY_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    STCircleHeadView *headerView = [[STCircleHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) backGroudImage:nil isMask:NO];
    _headerView = headerView;
    [_tableView setTableHeaderView:_headerView];
    
    //顶部菜单
    [self setupNavbarButtons];
    //底部菜单
    [self initBottomView];
}


//销毁界面时执行
- (void)clearData
{
    //清空临时SKU
    [[ShoppingLogic sharedInstance].tempDict removeAllObjects];
    
    //清空临时订单信息
    [[ShoppingLogic sharedInstance] clearGoodsData];
}


- (void)setMInfo:(MagazineContentInfo *)mInfo
{
    _mInfo = mInfo;
    //获取商品详情
    [self getGoodsDetails];
}

// 设置顶部自定义导航栏
- (void)setupNavbarButtons
{
    UIImageView *navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _navView = navView;
    [_navView setImage:[UIImage imageNamed:@"nav_shadow.png"]];
    [self.view addSubview:_navView];

    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn = backBtn;
    _backBtn.frame = CGRectMake(-10, 22, 64, 40);
    [_backBtn setImage:[UIImage imageNamed:@"nav_back_whitle.png"] forState:UIControlStateNormal];

    [_backBtn addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    
    //喜欢按钮
    CatZanButton *favButton = [[CatZanButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 145, 27, 30, 30)
                                                         zanImage:[UIImage imageNamed:@"icon_favourites_selected.png"]
                                                       unZanImage:[UIImage imageNamed:@"icon_favourites1.png"]];
    
    _favButton = favButton;
    [_favButton setType:CatZanButtonTypeFirework];
    [self.view addSubview:_favButton];

    
    //购物车
    UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cartBtn = cartBtn;
    _cartBtn.frame = CGRectMake(SCREEN_WIDTH - 110, 22, 64, 40);
    _cartBtn.alpha = 0.7;
    [_cartBtn setImage:[UIImage imageNamed:@"cart_icon.png"] forState:UIControlStateNormal];
    [_cartBtn addTarget:self action:@selector(cartButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cartBtn];
    
    //分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn = shareBtn;
    _shareBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 22, 64, 40);
    _shareBtn.alpha = 0.7;
    [_shareBtn setImage:[UIImage imageNamed:@"icon_more_white.png"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBtn];
}

- (void)initFavButtonStates{
    _favButton.isZan = [_gInfo.like boolValue];
    
    [_favButton setClickHandler:^(CatZanButton *favButton) {
        if (favButton.isZan) {
            //喜欢
            [self favorableMagazine];
        }else{
            [self unFavorableMagazine];
        }
    }];
}

// 添加底部购买按钮和加入购物车按钮的view
- (void)initBottomView{
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, SCREEN_HEIGHT - Bottom_H, SCREEN_WIDTH, Bottom_H);
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 3001;
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.2)];
    [lineV setBackgroundColor:LIGHT_BLACK_COLOR];
    [view addSubview:lineV];
    
    //客服
    UIButton *serButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2/8, Bottom_H)];
    [serButton setTitle:@" 客服" forState:UIControlStateNormal];
    [serButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [serButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [serButton setBackgroundImage:[UIImage imageNamed:@"btn_BG.png"] forState:UIControlStateNormal];
    [serButton setImage:[UIImage imageNamed:@"customer_icon.png"] forState:UIControlStateNormal];
    [serButton setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateHighlighted];
    [serButton setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateSelected];
    [serButton addTarget:self action:@selector(serviceTapped:) forControlEvents:UIControlEventTouchUpInside];
    serButton.tag = 4000;
    [view addSubview:serButton];
    
    //加入购物车
    UIButton *aBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/8, 0, SCREEN_WIDTH*3/8, Bottom_H)];
    [aBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [aBtn setBackgroundImage:[UIImage imageNamed:@"ST_btn_11.png"] forState:UIControlStateNormal];
    [aBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateHighlighted];
    [aBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateSelected];
    [aBtn addTarget:self action:@selector(addShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    aBtn.tag = 4001;
    [view addSubview:aBtn];
    
    //立刻购买
    UIButton* bBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*5/8, 0, SCREEN_WIDTH*3/8, Bottom_H)];;
    [bBtn setTitle:@"立刻购买" forState:UIControlStateNormal];
    [bBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [bBtn setBackgroundImage:[UIImage imageNamed:@"btn_pink.png"] forState:UIControlStateNormal];
    [bBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateHighlighted];
    [bBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateSelected];
    [bBtn addTarget:self action:@selector(nowBuy:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bBtn];
    bBtn.tag = 4002;
    [self.view addSubview:view];
}


- (void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//购物车
- (void)cartButtonTapped:(id)sender
{
    ShopCartViewController *sVC = [[ShopCartViewController alloc] init];
    [self.navigationController pushViewController:sVC animated:YES];
}


//分享
- (void)shareBtnTapped:(id)sender{
    SProData *mData = [[SProData alloc] init];
    mData.proName = _gInfo.mTitle;
    mData.proId = _mInfo.productId;
    mData.proImage = _gInfo.goodsImg;
    mData.proDes = _desInfo.desc;
    
    [[ShareLogic sharedInstance] showActionView:self];
    [ShareLogic sharedInstance].mType = KShare_Product;
    [ShareLogic sharedInstance].dInfo = nil;
    
    [[ShareLogic sharedInstance] setSData:mData];
}


//客服
- (void)serviceTapped:(id)sender
{
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
    [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];
    
    //自定义顾客信息
    User *user = [[UserLogic sharedInstance] getUser];
    if (user) {
        NSMutableDictionary *clientInfo = [[NSMutableDictionary alloc] init];
        
        [clientInfo setValue:user.basic.userName forKey:@"name"];
        [clientInfo setValue:user.basic.avatarUrl forKey:@"avatar"];
        [clientInfo setValue:[user.basic.userId stringValue] forKey:@"client_id"];
        
        if (user.basic.telephone) {
            [clientInfo setValue:user.basic.telephone forKey:@"tel"];
        }
        
        [chatViewManager setClientInfo:clientInfo];
    }

    [chatViewManager pushMQChatViewControllerInViewController:self];
    [chatViewManager setScheduleLogicWithRule:MQChatScheduleRulesRedirectEnterprise];
    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
    
    [[UINavigationBar appearance] setTranslucent:YES];
    
}

//立刻购买
- (void)nowBuy:(id)sender
{
    if(!_sizeInfo)
    {
        return;
    }
    
    //选择SKU--进入订单
    [[ShoppingLogic sharedInstance] setM_type:KSKU_Order];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OPEN_SKU" object:nil];
}

//加入购物车
- (void)addShoppingCar:(id)sender
{
    if(!_sizeInfo)
    {
        return;
    }
    
    //选择SKU--加入购物车
    [[ShoppingLogic sharedInstance] setM_type:KSKU_Cart];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OPEN_SKU" object:nil];
}


//获取商品详情
- (void)getGoodsDetails
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_mInfo.productId forKey:@"product_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] getGoodsContent:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.gInfo = result.mObject;
            [ShoppingLogic sharedInstance].store = weakSelf.gInfo.store;
            
            if([weakSelf.gInfo.isDown boolValue]){
                //商品下架
                [weakSelf goodsShelves];
            }
            
            if ([weakSelf.gInfo.canTry boolValue]){
                [weakSelf updateBottomMenu];
            }
 
            if(weakSelf.gInfo.detailInfo.length > 0)
            {
                if ([weakSelf.gInfo.sourceType integerValue] == 0) {
                    //商品详情
                    weakSelf.desInfo = [MTLJSONAdapter modelOfClass:[GoodsDetailInfo class] fromJSONDictionary:
                                        [STJSONSerialization JSONObjectWithData:[weakSelf.gInfo.detailInfo dataUsingEncoding:NSUTF8StringEncoding]] error:nil];
                    
                    //尺寸信息
                    weakSelf.sizeInfo = [MTLJSONAdapter modelOfClass:[SizeUrlInfo class]
                                                  fromJSONDictionary:[STJSONSerialization JSONObjectWithData:[weakSelf.gInfo.sizeUrl dataUsingEncoding:NSUTF8StringEncoding]]
                                                               error:nil];
                    
                    [weakSelf.headerView setHeadImage:weakSelf.gInfo.goodsImg];
                    [weakSelf.tableView reloadData];
                    
                    [weakSelf initFavButtonStates];
                }
                else if ([weakSelf.gInfo.sourceType integerValue] == 1) {
                    CLog(@"%@", weakSelf.gInfo.detailInfo);
                    //跳转到淘宝
                    [weakSelf jumpToTaoBao:(NSString *)weakSelf.gInfo.detailInfo];
                }
                
            }
            else
            {
                [weakSelf.view makeToast:@"商品不存在"];
            }
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //初始化
    _allSections = 0;
    
    if (_gInfo) {
        //有评论
        if(_gInfo.commentArray.count > 0)
        {
            //有品牌信息
            if (_gInfo.bInfo)
            {
                _allSections = 5;
            }
            else
                _allSections = 4;
        }
        else{
            //有品牌信息
            if (_gInfo.bInfo)
            {
                _allSections = 4;
            }
            else
                _allSections =  3;
        }
        

        if (_gInfo.recommandArray.count > 0) {
            _allSections += 1;
        }

        return _allSections;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 产品属性（价格、产品名称）
    if (indexPath.section == 0) {
        return 115.0;
    }
    
    if(_gInfo.commentArray.count > 0)
    {
        if (indexPath.section == 1)
        {
            //商品评论
            GoodsCommentsCell *cell = [GoodsCommentsCell cellWithTableView:tableView];
            return [cell setCellWithCellInfo:_gInfo.commentArray[0] commentNumber:_gInfo.commentsNum];
        }
        
        //有商品信息
        if (_gInfo.bInfo)
        {
            // 品牌属性（品牌名称、品牌介绍）
            if (indexPath.section == 2) {
                return [self brandCellWithHeight];
            }
            
            if (indexPath.section == 3) {
                return [self desModeCellWithHeight];
            }
            
            if (indexPath.section == 4) {
                STContentCell *cell = [STContentCell cellWithTableView:tableView];
                return [cell setCellWithCellInfo:_isLeft];
            }
        }
        else{
            if (indexPath.section == 2) {
                return [self desModeCellWithHeight];
            }
            
            if (indexPath.section == 3) {
                STContentCell *cell = [STContentCell cellWithTableView:tableView];
                return [cell setCellWithCellInfo:_isLeft];
            }
        }
    }
    else{
        //有商品信息
        if (_gInfo.bInfo)
        {
            // 品牌属性（品牌名称、品牌介绍）
            if (indexPath.section == 1) {
                return [self brandCellWithHeight];
            }
            
            if (indexPath.section == 2) {
                return [self desModeCellWithHeight];
            }
            
            if (indexPath.section == 3) {
                STContentCell *cell = [STContentCell cellWithTableView:tableView];
                return [cell setCellWithCellInfo:_isLeft];
            }
        }
        else{
            if (indexPath.section == 1) {
                return [self desModeCellWithHeight];
            }
            
            if (indexPath.section == 2) {
                STContentCell *cell = [STContentCell cellWithTableView:tableView];
                return [cell setCellWithCellInfo:_isLeft];
            }
        }
        
    }
    
    if(_gInfo.recommandArray.count > 0 && indexPath.section == _allSections-1)
    {
        return 250.0;
    }
    
    
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GoodsNameCell *cell = [GoodsNameCell cellWithTableView:tableView];
        [cell setCellWithCellInfo:_gInfo];
        return cell;
    }
    
    if(_gInfo.commentArray.count > 0)
    {
        //商品评论
        if (indexPath.section == 1)
        {
            GoodsCommentsCell *cell = [GoodsCommentsCell cellWithTableView:tableView];
            [cell setCellWithCellInfo:_gInfo.commentArray[0] commentNumber:_gInfo.commentsNum];
            cell.delegate = self;
            return cell;
        }
        
        
        //有商品信息
        if (_gInfo.bInfo) {
            if (indexPath.section == 2) {
                BrandCell *cell = [BrandCell cellWithTableView:tableView];
                cell.delegate = self;
                [cell setCellWithCellInfo:_gInfo.bInfo];
                return cell;
            }
            
            //商品详情介绍
            if (indexPath.section == 3) {
                return [self desModeCellWithTableView:tableView];
            }
            
            //购物说明
            if (indexPath.section == 4) {
                STContentCell *cell = [STContentCell cellWithTableView:tableView];
                [cell setCellWithCellInfo:_isLeft];
                cell.delegate = self;
                return cell;
            }
        }
        else{
            //商品详情介绍
            if (indexPath.section == 2) {
                return [self desModeCellWithTableView:tableView];
            }
            
            //购物说明
            if (indexPath.section == 3) {
                STContentCell *cell = [STContentCell cellWithTableView:tableView];
                [cell setCellWithCellInfo:_isLeft];
                cell.delegate = self;
                return cell;
            }
        }
    }
    else
    {
        //有商品信息
        if (_gInfo.bInfo) {
            if (indexPath.section == 1) {
                BrandCell *cell = [BrandCell cellWithTableView:tableView];
                cell.delegate = self;
                [cell setCellWithCellInfo:_gInfo.bInfo];
                return cell;
            }
            
            //商品详情介绍
            if (indexPath.section == 2) {
                return [self desModeCellWithTableView:tableView];
            }
            
            //购物说明
            if (indexPath.section == 3) {
                STContentCell *cell = [STContentCell cellWithTableView:tableView];
                [cell setCellWithCellInfo:_isLeft];
                cell.delegate = self;
                return cell;
            }
        }
        else{
            //商品详情介绍
            if (indexPath.section == 1) {
                return [self desModeCellWithTableView:tableView];
            }
            
            //购物说明
            if (indexPath.section == 2) {
                STContentCell *cell = [STContentCell cellWithTableView:tableView];
                [cell setCellWithCellInfo:_isLeft];
                cell.delegate = self;
                return cell;
            }
        }
    }
    
    
    if(_gInfo.recommandArray.count > 0 && indexPath.section == _allSections-1)
    {
        RecommandCell *rCell = [RecommandCell cellWithTableView:tableView];
        [rCell setCellWithCellInfo:_gInfo.recommandArray];
        rCell.delegate = self;
        return rCell;
    }
    
    return nil;
}

//商品详情
- (DesModeCell *)desModeCellWithTableView:(UITableView *)tableView
{
    DesModeCell *mcell = [DesModeCell cellWithTableView:tableView];
    DesModeFrame *dFrame = [[DesModeFrame alloc] init];
    dFrame.sizeInfo = _sizeInfo;
    dFrame.desInfo = _desInfo;
    
    mcell.desFrame = dFrame;
    mcell.desView.delegate = self;
    mcell.desView.isLeft = _isDes;
    
    return mcell;
}

//商品详情模块高度
- (CGFloat)desModeCellWithHeight
{
    if (_isDes) {
        //详情介绍
        DesModeFrame *aFrame = [[DesModeFrame alloc] init];
        aFrame.desInfo = _desInfo;
        return aFrame.rowHeight;
    }
    else
    {
        //科学计数法
        NSDecimalNumber *m_width = [NSDecimalNumber decimalNumberWithString:[[NSNumber numberWithInteger:SCREEN_WIDTH - 20] stringValue]];
        NSDecimalNumber *cof = [NSDecimalNumber decimalNumberWithString:[[NSNumber numberWithFloat:M_K] stringValue]];
        
        //除法
        NSDecimalNumber *m_height = [m_width decimalNumberByDividingBy:cof];
        
        return 100 + m_height.floatValue + 40;
    }
}

//计算品牌介绍模块高度
- (CGFloat)brandCellWithHeight
{
    MLEmojiLabel *contentLab = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    contentLab.numberOfLines = 3;
    contentLab.font = [UIFont systemFontOfSize:14.0];
    contentLab.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    contentLab.customEmojiPlistName = @"MLEmoji_ExpressionImage";
    contentLab.textAlignment = NSTextAlignmentLeft;
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    [contentLab setText:_gInfo.bInfo.story];
    
    CGSize size = [contentLab preferredSizeWithMaxWidth:SCREEN_WIDTH-28];
    
    return size.height + 45.0 + 14.0 + 40.0;
}

#pragma mark scrollView 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(STCircleHeadView *)self.tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset scrollView:scrollView];
    }
}

- (void)jumpToTaoBao:(NSString *)url{
    DPWebViewController *dVC = [[DPWebViewController alloc] init];
    dVC.isReturn = YES;
    dVC.urlSting = url;
    dVC.titName = @"商品详情";
    [self.navigationController pushViewController:dVC animated:YES];
}


#pragma mark STContentCellDelegate
- (void)updateUI:(BOOL)isLeft
{
    _isLeft = isLeft;
    [_tableView reloadData];
}

#pragma mark DesModeViewDelegate
- (void)desModeView:(DesModeView *)desModeView updateUI:(BOOL)isLeft
{
    _isDes = isLeft;
    [_tableView reloadData];
}


#pragma mark RecommandCellDelegate
- (void)recommandCell:(RecommandCell *)pView clickWithInfo:(SameModel *)sMode
{
    //自营
    MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
    mcInfo.productId = sMode.mId;
    mcInfo.coverUrl = sMode.imgurl;
    
    
    STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
    goodsVC.mInfo = mcInfo;
    goodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsVC animated:YES];
}


#pragma mark BrandCellDelegate
- (void)brandCellJumpToBrandDetails
{
    //品牌详情
    STBrandIntroduceViewController *vc = [[STBrandIntroduceViewController alloc] init];
    vc.bInfo = _gInfo.bInfo;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark GoodsCommentsCellDelegate
- (void)goodsCommentsCellJumpToCommentsList
{
    //评论列表
    STGoodsCommentsViewController *vc = [[STGoodsCommentsViewController alloc] init];
    vc.productID = _mInfo.productId;
    [self.navigationController pushViewController:vc animated:YES];
}


//喜欢该商品
- (void)favorableMagazine {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_mInfo.productId forKey:@"product_id"];
    
    [[MagazineLogic sharedInstance] favorProduct:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _gInfo.like = [NSNumber numberWithBool:YES];
        }
        else
            [theAppDelegate.window makeToast:result.stateDes];
    }];
}

//不喜欢该商品
- (void)unFavorableMagazine {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_mInfo.productId forKey:@"product_id"];
    
    [[MagazineLogic sharedInstance] unFavorProduct:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _gInfo.like = [NSNumber numberWithBool:NO];
        }
        else
            [theAppDelegate.window makeToast:result.stateDes];
    }];
}

//商品下架
- (void)goodsShelves{
    UIView* mView = (UIView*)[self.view viewWithTag:3001];
    if (mView) {
        UIButton* aBtn = (UIButton*)[mView viewWithTag:4001];
        if (aBtn) {
            [aBtn setHidden:YES];
        }
        UIButton* bBtn = (UIButton*)[mView viewWithTag:4002];
        if (bBtn) {
            [bBtn setHidden:YES];
        }
        
        UILabel *mL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH*3/4, Bottom_H)];
        [mL setBackgroundColor:[UIColor grayColor]];
        [mL setText:@"已下架"];
        [mL setTextColor:[UIColor whiteColor]];
        [mL setFont:[UIFont systemFontOfSize:18]];
        [mL setTextAlignment:NSTextAlignmentCenter];
        [mView addSubview:mL];
    }
}

- (void)updateBottomMenu{
    CGFloat mW = SCREEN_WIDTH/3.0;
    
    //可试衣
    UIView *bottomMenu = (UIView*)[self.view viewWithTag:3001];
    if (bottomMenu) {
        //客服
        UIButton *cBtn = (UIButton*)[bottomMenu viewWithTag:4000];
        if (cBtn) {
            [cBtn setFrame:CGRectMake(mW/2, 0, mW/2, Bottom_H)];
            [cBtn setTitle:@"" forState:UIControlStateNormal];
            [cBtn setImage:[UIImage imageNamed:@"try_customer.png"] forState:UIControlStateNormal];
            [cBtn setBackgroundImage:[UIImage imageNamed:@"btn_BG.png"] forState:UIControlStateNormal];
            [cBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateHighlighted];
            [cBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateSelected];
        }
        
        // 购物车
        UIButton* aBtn = (UIButton*)[bottomMenu viewWithTag:4001];
        if (aBtn) {
            [aBtn setFrame:CGRectMake(mW, 0, mW, Bottom_H)];
        }
        
        // 立刻购买
        UIButton* bBtn = (UIButton*)[bottomMenu viewWithTag:4002];
        if (bBtn) {
            [bBtn setFrame:CGRectMake(mW*2, 0, mW, Bottom_H)];
        }
        
        //试穿按钮
        UIButton *tryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mW/2, Bottom_H)];
        [tryBtn setImage:[UIImage imageNamed:@"try_clothes.png"] forState:UIControlStateNormal];
        [tryBtn addTarget:self action:@selector(tryBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [tryBtn setBackgroundImage:[UIImage imageNamed:@"btn_BG.png"] forState:UIControlStateNormal];
        [tryBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateHighlighted];
        [tryBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateSelected];
        [bottomMenu addSubview:tryBtn];
    }
}

//进入预约界面
- (void)tryBtnTapped:(id)sender {
    //判断身材数据是否已经完善
    User *user = [[UserLogic sharedInstance] getUser];
    if (user.body) {
        AppointmentDateViewController *aVC = [[AppointmentDateViewController alloc] init];
        skuDesData *sData = [ShoppingLogic sharedInstance].skuData.skuList[0];
        aVC.skuID = sData.skuId;
        [self.navigationController pushViewController:aVC animated:YES];
    }
    else{
        FigureGuideViewController *sVC = CREATCONTROLLER(FigureGuideViewController);
        sVC.isPOP = YES;
        STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:sVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
