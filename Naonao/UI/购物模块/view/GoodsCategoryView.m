//
//  GoodsCategoryView.m
//  Naonao
//
//  Created by 刘敏 on 16/3/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "GoodsCategoryView.h"
#import "SKUHeadView.h"
#import "SKUMenuView.h"
#import "ShoppingLogic.h"
#import <QuartzCore/QuartzCore.h>  


@interface GoodsCategoryView ()<SKUMenuViewDelegate>
{
    CALayer     *layer;
}

@property (nonatomic, weak) UIView *backGV;             //背景

@property (nonatomic, weak) SKUHeadView *hV;
@property (nonatomic, weak) UIButton *backBtn;

@property (nonatomic, weak) UIView *mV;
@property (nonatomic, weak) UIButton *increaseBtn;
@property (nonatomic, weak) UIButton *reduceBtn;
@property (nonatomic, weak) UILabel *countLabel;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *sureBtn;

@property (nonatomic, assign) NSUInteger count;         //商品数量

@property (nonatomic, strong) UIBezierPath *path;       //贝塞尔

@end

@implementation GoodsCategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

#pragma mark 触发绘制界面（触发条件------> SKU请求完成获取到相关数据）
- (void)updateUI
{
    _count = 1;
    [self setUpChildView];
    
    /******************* 终点 ************************/
    //宽度缩放0.8
    CGFloat x = (SCREEN_WIDTH-85)*0.8 + SCREEN_WIDTH*0.1;
    //高度缩放0.95
    CGFloat y = 42*0.95 + SCREEN_HEIGHT*0.025;
    
    //贝塞尔
    self.path = [UIBezierPath bezierPath];
    //起始点
    [self.path moveToPoint:CGPointMake(60, SCREEN_HEIGHT*0.24+51)];
    //中间点---->终点
    [self.path addQuadCurveToPoint:CGPointMake(x, y) controlPoint:CGPointMake(SCREEN_WIDTH/2, y/2-8)];
}


- (void)setUpChildView
{
    /***************************************    顶部触摸层     ***************************************/
    UIView *touchV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.24)];
    [touchV setBackgroundColor:[UIColor clearColor]];
    [self addSubview:touchV];
    //增加点击事件
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapped:)];
    [touchV addGestureRecognizer:tapGesture];
    
    
    /***************************************    背景     ***************************************/
    UIView *backGV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.24, SCREEN_WIDTH, SCREEN_HEIGHT*0.76)];
    _backGV = backGV;
    _backGV.userInteractionEnabled = YES;
    //加个阴影
    _backGV.layer.shadowColor = [UIColor blackColor].CGColor;
    _backGV.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _backGV.layer.shadowOpacity = 0.8;
    _backGV.layer.shadowRadius = 5;

    [_backGV setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_backGV];
    
    /***************************************    商品     ***************************************/
    SKUHeadView *hV = [[SKUHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 122)];
    _hV = hV;
    [_backGV addSubview:_hV];
    
    //取消按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 40, 40)];
    _backBtn = backBtn;
    [_backBtn setImage:[UIImage imageNamed:@"icon_close_btn.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(closeTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_backGV addSubview:_backBtn];
    
    /***************************************    SKU     ***************************************/
    
    [self initScrollView];
    
    /***************************************    底部按钮     ***************************************/
    //确定按钮
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_backGV.frame)-49, SCREEN_WIDTH, 49)];
    _sureBtn = sureBtn;
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setBackgroundImage:[UIImage imageNamed:@"ST_btn_11.png"] forState:UIControlStateNormal];
    [_sureBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateHighlighted];
    [_sureBtn setBackgroundImage:[UIImage imageNamed:@"btn_grey.png"] forState:UIControlStateSelected];
    [_sureBtn addTarget:self action:@selector(sureTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_backGV addSubview:_sureBtn];
}

//绘制滑动区域
- (void)initScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _hV.height, SCREEN_WIDTH, _backGV.height - 49 - _hV.height)];
    _scrollView = scrollView;
    //分页
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.bounces = YES;                      //反弹属性
    [_backGV addSubview:_scrollView];
    
    SKUData *mData = [ShoppingLogic sharedInstance].skuData;
    
    CGFloat mH = 0.0;
    
    //标签
    for (skuMenuData *menuData in mData.disArray) {
        SKUMenuView *skV = [[SKUMenuView alloc] initWithFrame:CGRectMake(0, mH, SCREEN_WIDTH, 0)];
        skV.delegate = self;
        
        CGRect mG = skV.frame;
        mG.size.height = [skV setMenuWithskuMenuData:menuData];
        [skV setFrame:mG];
        [_scrollView addSubview:skV];
        
        mH += mG.size.height;
    }
    
    //数量
    UIView *mV = [[UIView alloc] initWithFrame:CGRectMake(0, mH, SCREEN_WIDTH, 45)];
    _mV = mV;
    [_scrollView addSubview:_mV];
    [self drawMView];
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, mH+80)];
}


// 绘制数量（加、减）
- (void)drawMView {
    UILabel *mT = [[UILabel alloc] initWithFrame:CGRectMake(14, 20, 120, 20)];
    [mT setText:@"数量："];
    [mT setFont:[UIFont systemFontOfSize:14.0]];
    [mT setTextColor:BLACK_COLOR];
    [_mV addSubview:mT];
    
    //加
    UIButton *increaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 54, 10, 40, 40)];
    _increaseBtn = increaseBtn;
    [_increaseBtn setImage:[UIImage imageNamed:@"icon_bank_add.png"] forState:UIControlStateNormal];
    [_increaseBtn addTarget:self action:@selector(increaseBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_mV addSubview:_increaseBtn];

    //减少
    UIButton *reduceBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 134, 10, 40, 40)];
    _reduceBtn = reduceBtn;
    [_reduceBtn setImage:[UIImage imageNamed:@"icon_bank_reduce.png"] forState:UIControlStateNormal];
    [_reduceBtn addTarget:self action:@selector(reduceBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_mV addSubview:_reduceBtn];
    
    //数量
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_reduceBtn.frame), 10, SCREEN_WIDTH - 54 - CGRectGetMaxX(_reduceBtn.frame), 40)];
    _countLabel = countLabel;
    [_countLabel setTextAlignment:NSTextAlignmentCenter];
    [_countLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_mV addSubview:_countLabel];

    [self drawMV];
}

//重新绘制数量按钮
- (void)drawMV {
    
    if (_count == 1) {
        [_reduceBtn setEnabled:NO];
    }
    else
        [_reduceBtn setEnabled:YES];
    
    [_countLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)_count]];
}


#pragma mark --按钮响应事件
//关闭
- (void)closeTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CLOSE_SKU" object:nil];
}


//确定按钮
- (void)sureTapped:(id)sender {
    NSDictionary *dic = [ShoppingLogic sharedInstance].tempDict;
    CLog(@"%@", dic);
    
    
    for (skuMenuData *pdata in [ShoppingLogic sharedInstance].skuData.disArray) {
        NSString *t = [[ShoppingLogic sharedInstance].tempDict objectForKeyNotNull:pdata.name];
        if (!t) {
            [theAppDelegate.window makeToast:[NSString stringWithFormat:@"请选择%@", pdata.name]];
            return;
        }
    }
    
    skuDesData *pdata = [self findskuWithProduct];
    
    //先判断库存
    if ([pdata.stock integerValue] <= 0){
        [theAppDelegate.window makeToast:@"库存不足，请选择其他商品"];
        return;
    }
    //赋值（推荐者ID）
    pdata.source_uid = [ShoppingLogic sharedInstance].re_userId;
    
    //存储临时订单信息
    [[ShoppingLogic sharedInstance] encapsulationTemporaryOrderData:_count skuDesData:pdata];
    
    
    if ([ShoppingLogic sharedInstance].m_type == KSKU_Cart) {
        //加入购物车动画
        [self startAnimation];
        
        //发起添加到购物车请求
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
        [dic setObject:[NSNumber numberWithInteger:_count] forKey:@"num"];
        [dic setObject:pdata.skuId forKey:@"sku_id"];
        
        NSString *recommendedS = @"0";
        //推荐者UserID
        if ([ShoppingLogic sharedInstance].re_userId) {
            recommendedS = [[ShoppingLogic sharedInstance].re_userId stringValue];
        }
        
        [dic setObject:recommendedS forKey:@"source_uid"];
        
        // 添加商品到购物车
        [[ShoppingLogic sharedInstance] addProductShoppingCart:dic withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                [theAppDelegate.window makeToast:@"添加成功，在购物车等亲哦~"];
            }
            else
                [theAppDelegate.window makeToast:result.stateDes];
        }];
        
    }
    else if ([ShoppingLogic sharedInstance].m_type == KSKU_Order)
    {
        //直接购买
        if (_delegate && [_delegate respondsToSelector:@selector(jumpToOrderVC)]) {
            [_delegate jumpToOrderVC];
            [self closeTapped:nil];
            
        }
    }
}

//增加
- (void)increaseBtnTapped:(id)sender {
    _count++;
    [self drawMV];
}

//减少
- (void)reduceBtnTapped:(id)sender
{
    _count--;
    [self drawMV];
}


#pragma mark ----添加到购物车动画
- (void)startAnimation
{
    if (!layer) {
        layer = [CALayer layer];
        layer.contents = (__bridge id)_hV.headV.image.CGImage;
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer.bounds = CGRectMake(0, 0, 92, 92);
        layer.masksToBounds = YES;
        layer.position = CGPointMake(60, SCREEN_HEIGHT*0.24+51);
        
        [self.layer addSublayer:layer];
    }
    
    [self groupAnimation];
}


- (void)groupAnimation
{
    // 指定position属性（移动）
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    
    /* 旋转 */
    // 对Y轴进行旋转（指定Z轴的话，就和UIView的动画一样绕中心旋转）
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 设定动画选项
    rotationAnimation.duration = 0.6; // 持续时间
    rotationAnimation.repeatCount = 1; // 重复次数
    // 设定旋转角度
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];       // 起始角度
    rotationAnimation.toValue = [NSNumber numberWithFloat:5 * M_PI];    // 终止角度
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];

    //缩小
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.1;
    //起始scale
    narrowAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    // 动画持续时间
    narrowAnimation.duration = 0.5f;
    //终了scale
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation, rotationAnimation, narrowAnimation];
    groups.duration = 0.6f;                 // 动画持续时间
    groups.repeatCount = 1; // 不重复
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    
    [layer addAnimation:groups forKey:@"group"];
}


//动画执行结束执行
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [layer animationForKey:@"group"]) {
        [layer removeFromSuperlayer];
        layer = nil;
        
        // 执行关闭
        [self closeTapped:nil];
    }
}

//查找当前对应的SKU信息
- (skuDesData *)findskuWithProduct{
    NSString *tA = [[[ShoppingLogic sharedInstance].tempDict allValues] componentsJoinedByString:@"|"];
    
    for (skuDesData *sData in [ShoppingLogic sharedInstance].skuData.skuList) {
        NSString *tB = [[sData.skuInfo allValues] componentsJoinedByString:@"|"];
        if ([tA isEqualToString:tB]) {
            return sData;
        }
    }

    return nil;
}



#pragma mark SKUMenuViewDelegate  SKU按钮点击
- (void)skuButtonTapped
{
    for (skuMenuData *pdata in [ShoppingLogic sharedInstance].skuData.disArray) {
        NSString *t = [[ShoppingLogic sharedInstance].tempDict objectForKeyNotNull:pdata.name];
        if (!t) {
            return;
        }
    }
    
    skuDesData *pdata = [self findskuWithProduct];
    
    //更新SKUHeadView界面
    [_hV updateUIMessage:pdata];
}

@end

