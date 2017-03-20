//
//  STGoodsMainViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STGoodsMainViewController.h"
#import "ShoppingLogic.h"
#import "PaymentOrderViewController.h"

@interface STGoodsMainViewController ()<GoodsCategoryViewDelegate>

@property (nonatomic, weak) GoodsCategoryView *pView;

@end

@implementation STGoodsMainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取SKU
    [self getGoodsSKU];

    GoodsCategoryView *pView = [[GoodsCategoryView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), SCREEN_WIDTH, SCREEN_HEIGHT)];
    _pView = pView;
    _pView.delegate = self;
    

    //导航栏一定要加载ROOTVC上面
    STGoodsDetailsViewController * root = [[STGoodsDetailsViewController alloc] init];
    root.mInfo = _mInfo;
    [self createPopVCWithRootVC:root andPopView:_pView];

    //传递
    [ShoppingLogic sharedInstance].re_userId = _re_userId;
}

//获取商品SKU
- (void)getGoodsSKU
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_mInfo.productId forKey:@"product_id"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[ShoppingLogic sharedInstance] getGoodsSKU:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf.pView updateUI];
        }
    }];
}

#pragma mark -  GoodsCategoryViewDelegate
- (void)jumpToOrderVC
{
    if ([ShoppingLogic sharedInstance].orderArray.count == 0)
    {
        [theAppDelegate.window makeToast:@"没有选中任何商品"];
        return;
    }
    
    //延迟执行
    [self performSelector:@selector(delayJumpToOrderVC) withObject:nil afterDelay:0.45];
}

- (void)delayJumpToOrderVC
{
    PaymentOrderViewController *pVC = [[PaymentOrderViewController alloc] init];
    [self.navigationController pushViewController:pVC animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
