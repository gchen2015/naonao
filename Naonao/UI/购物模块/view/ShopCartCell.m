//
//  ShopCartCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/24.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ShopCartCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ShoppingLogic.h"

@interface ShopCartCell ()

@property (nonatomic, weak) UIButton *chooseBtn;

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) UILabel *skuLabel;
@property (nonatomic, weak) UILabel *priceL;
@property (nonatomic, weak) UILabel *countLabel;

@property (nonatomic, weak) UIView *editView;
@property (nonatomic, weak) UILabel *mL;


@property (nonatomic, strong) GoodsOData *goodsTData;

@end


@implementation ShopCartCell

+ (ShopCartCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopCartCell";
    
    ShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ShopCartCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView
{
    //全选
    UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Bottom_H, 106)];
    _chooseBtn = chooseBtn;
    [_chooseBtn setImage:[UIImage imageNamed:@"icon_selected_no.png"] forState:UIControlStateNormal];
    [_chooseBtn setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateHighlighted];
    [_chooseBtn setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateSelected];
    [_chooseBtn addTarget:self action:@selector(chooseGoodsTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_chooseBtn];
    
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(48, 12, 90, 90)];
    _headV = headV;
    //填充方式
    [_headV setContentMode:UIViewContentModeScaleAspectFill];
    _headV.layer.masksToBounds = YES;  //设为NO去试试
    [self.contentView addSubview:_headV];
    _headV.userInteractionEnabled = YES;
    //添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headActiondo:)];
    [_headV addGestureRecognizer:tapGesture];
    
    //标题
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titLabel = titLabel;
    [_titLabel setNumberOfLines:0];
    [_titLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_titLabel setTextColor:LIGHT_BLACK_COLOR];
    [self.contentView addSubview:_titLabel];
    
    //SKU
    UILabel *skuLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _skuLabel = skuLabel;
    [_skuLabel setNumberOfLines:0];
    [_skuLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_skuLabel setTextColor:LIGHT_GARY_COLOR];
    [self.contentView addSubview:_skuLabel];

    //单价
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, CGRectGetMaxY(_headV.frame)-14, 100, 16)];
    _priceL = priceL;
    [_priceL setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:14.0]];
    [_priceL setTextColor:PINK_COLOR];
    [self.contentView addSubview:_priceL];
    
    //数量
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-54, CGRectGetMaxY(_headV.frame)-14, 40, 16)];
    _countLabel = countLabel;
    [_countLabel setTextAlignment:NSTextAlignmentRight];
    [_countLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_countLabel setTextColor:LIGHT_BLACK_COLOR];
    [self.contentView addSubview:_countLabel];
    
    //编辑区域
    UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame), 0, SCREEN_WIDTH - CGRectGetMaxX(_headV.frame), 44)];
    _editView = editView;
    [_editView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_editView];
    
    //减号
    UIButton *reduceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [reduceButton setImage:[UIImage imageNamed:@"reduce_icon.png"] forState:UIControlStateNormal];
    [reduceButton addTarget:self action:@selector(reduceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_editView addSubview:reduceButton];
    
    //数量
    UILabel *mL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, editView.width, editView.height)];
    _mL = mL;
    [_mL setTextAlignment:NSTextAlignmentCenter];
    [_mL setFont:[UIFont systemFontOfSize:18.0]];
    [_mL setTextColor:BLACK_COLOR];
    [_editView addSubview:_mL];
    
    //加好
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - CGRectGetMaxX(_headV.frame) - 44, 0, 44, 44)];
    [addButton setImage:[UIImage imageNamed:@"add_icon.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_editView addSubview:addButton];
}

- (void)setCellWithCellInfo:(GoodsOData *)goodsTData setChooseBtn:(BOOL)isSelected isEdit:(BOOL)isEdit
{
    _goodsTData = goodsTData;

    [_chooseBtn setSelected:isSelected];
    [_headV sd_setImageWithURL:[NSURL URLWithString:[goodsTData.imageURL middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    
    [_titLabel setText:goodsTData.proName];
    CGFloat mf = SCREEN_WIDTH - CGRectGetMaxX(_headV.frame)-24;
    CGFloat tH = [_titLabel sizeThatFits:CGSizeMake(mf, MAXFLOAT)].height;
    if (tH > 48.0){
        tH = 36.0;
    }
    
    [_titLabel setFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, 10, mf, tH)];
    
    
    //SKU
    NSArray *ks = [goodsTData.skuDict allKeys];
    NSArray *ms = [goodsTData.skuDict allValues];
    
    NSMutableString *st = [[NSMutableString alloc] init];
    for (int i = 0; i<ks.count; i++) {
        NSString *s = [NSString stringWithFormat:@"%@：%@     ", [ks objectAtIndex:i], [ms objectAtIndex:i]];
        [st appendString:s];
    }
    
    [_skuLabel setText:st];
    [_skuLabel setFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, CGRectGetMaxY(_titLabel.frame)+5, mf, 18)];

    //单价
    NSString *price = [NSString stringWithFormat:@"￥%.2f", [goodsTData.price floatValue]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:20.0] range:NSMakeRange(1, price.length-4)];
    _priceL.attributedText = str;
    
    //数量
    [_countLabel setText:[NSString stringWithFormat:@"x%@", goodsTData.count]];
    [_mL setText:[NSString stringWithFormat:@"%@", goodsTData.count]];
    
    //编辑状态
    if(isEdit)
    {
        [self editState];
    }
    else{
        [self normalState];
    }
    
    
    //判断是否有库存
    if ([goodsTData.stock integerValue] <= 0 ){
        [_chooseBtn setHidden:YES];
        
        UILabel *failureL = [[UILabel alloc] initWithFrame:CGRectMake(8, 43, 36, 20)];
        [failureL setText:@"失效"];
        [failureL setFont:[UIFont systemFontOfSize:12.0]];
        [failureL setTextAlignment:NSTextAlignmentCenter];
        [failureL setBackgroundColor:[UIColor colorWithHex:0xAAAAAA]];
        [failureL setTextColor:[UIColor whiteColor]];
        //圆角
        failureL.layer.cornerRadius = 3;                     //设置那个圆角的有多圆
        failureL.layer.masksToBounds = YES;                  //设为NO去试试
        
        [self.contentView addSubview:failureL];
        
        [self.contentView setBackgroundColor:[UIColor colorWithHex:0xFAFAFA]];
    }
}


- (void)chooseGoodsTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(chooseProduct:chooseWithInfo:goodsClick:)]) {
        [_delegate chooseProduct:sender.selected chooseWithInfo:_goodsTData goodsClick:_indexPath];
    }
}

- (void)headActiondo:(UITapGestureRecognizer *)tapGesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(goodsClick:)]) {
        [_delegate goodsClick:_goodsTData];
    }
}


- (void)editState
{
    [_titLabel setHidden:YES];
    [_countLabel setHidden:YES];
    [_priceL setHidden:YES];
    
    CGSize size = _skuLabel.size;
    [_skuLabel setFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, 104-size.height, size.width, size.height)];
    [_skuLabel setTextColor:LIGHT_GARY_COLOR];
    
    [_editView setHidden:NO];
}


- (void)normalState
{
    [_titLabel setHidden:NO];
    [_countLabel setHidden:NO];
    [_priceL setHidden:NO];
    
    CGSize size = _skuLabel.size;
    [_skuLabel setFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+10, CGRectGetMaxY(_titLabel.frame)+5, size.width, size.height)];
    [_skuLabel setTextColor:LIGHT_GARY_COLOR];
    
    [_editView setHidden:YES];
}

//减少
- (void)reduceButtonTapped:(id)sender
{
    if ([_goodsTData.count integerValue] == 1) {
        [theAppDelegate.window makeToast:@"受不了了，宝贝不能再减少了哦"];
        //
        return;
    }
    
    [self addGoodsInCartWithNumber:-1];
    
}

//增加
- (void)addButtonTapped:(id)sender{
    [self addGoodsInCartWithNumber:1];
}


//添加到购物车
- (void)addGoodsInCartWithNumber:(NSInteger)num
{
    //发起添加到购物车请求
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:[NSNumber numberWithInteger:num] forKey:@"num"];
    [dic setObject:_goodsTData.skuTag forKey:@"sku_id"];
    
    [dic setObject:_goodsTData.source_uid forKey:@"source_uid"];
    
    
    __typeof (&*self) __weak weakSelf = self;
    
    // 添加商品到购物车
    [[ShoppingLogic sharedInstance] addProductShoppingCart:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            CLog(@"成功");
            //执行代理事件
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(updateShopCart)]) {
                [weakSelf.delegate updateShopCart];
            }
        }
        else
            [theAppDelegate.window makeToast:result.stateDes];
    }];
}




@end
