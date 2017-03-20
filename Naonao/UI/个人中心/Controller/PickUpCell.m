//
//  PickUpCell.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PickUpCell.h"
#import "SHLUILabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TimeUtil.h"


@interface PickUpCell ()

@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, weak) UILabel *titL;
@property (nonatomic, weak) UILabel *dateL;
@property (nonatomic, weak) UILabel *timeL;


@property (nonatomic, weak) UIView *adView;
@property (nonatomic, weak) UIImageView *addressV;
@property (nonatomic, weak) UILabel *addressL;

@end



@implementation PickUpCell

+ (PickUpCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"FittingCell";
    
    PickUpCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PickUpCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)setUpChildView{
    [self.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 0)];
    _bgView = bgView;
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:_bgView];
    _bgView.userInteractionEnabled = YES;
    
    UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, 37.5)];
    _titL = titL;
    [_titL setTextAlignment:NSTextAlignmentCenter];
    [_titL setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]];
    [_titL setTextColor:PINK_COLOR];
    [_bgView addSubview:_titL];
    
    // 分割线
    UILabel *lineA = [[UILabel alloc] initWithFrame:CGRectMake(0, 37.5, _bgView.width, 0.5)];
    [lineA setBackgroundColor:LINE_COLOR];
    [_bgView addSubview:lineA];
    
    UILabel *dateL = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, _bgView.width, 15)];
    _dateL = dateL;
    [_dateL setTextAlignment:NSTextAlignmentCenter];
    [_dateL setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
    [_dateL setTextColor:BROWN_COLOR];
    [_bgView addSubview:_dateL];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 72, _bgView.width, 30)];
    _timeL = timeL;
    [_timeL setTextAlignment:NSTextAlignmentCenter];
    [_timeL setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:26.0]];
    [_timeL setTextColor:BROWN_COLOR];
    [_bgView addSubview:_timeL];
    
    
    /***************************  商铺地点 ******************************/
    UIView *adView = [[UIView alloc] initWithFrame:CGRectZero];
    _adView = adView;
    [_bgView addSubview:_adView];
    
    // 地址
    UIImageView *addressV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 18, 14, 18)];
    _addressV = addressV;
    [_addressV setImage:[UIImage imageNamed:@"cell_address_icon.png"]];
    [_adView addSubview:_addressV];
    
    UILabel *addressL = [[UILabel alloc] initWithFrame:CGRectZero];
    _addressL = addressL;
    [_addressL setFont:[UIFont systemFontOfSize:15.0]];
    [_addressL setTextColor:BLACK_COLOR];
    [_adView addSubview:_addressL];
}


- (void)setCellWithCellInfo:(PickUpData *)mInfo
{
    if ([mInfo.status integerValue] == 0) {
        [_titL setText:@"待上门"];
    }
    else if ([mInfo.status integerValue] == 1) {
        [_titL setText:@"已取消"];
    }
    else if ([mInfo.status integerValue] == 2) {
        [_titL setText:@"已完成"];
    }
    
    //日期、事件
    CLog(@"%@", mInfo.reserveTime);
    
    NSString *dateS = [mInfo.reserveTime substringToIndex:10];
    NSString *timeS = [mInfo.reserveTime substringFromIndex:11];
    
    [_dateL setText:[NSString stringWithFormat:@"%@（%@）", dateS, [TimeUtil featureWeekdayWithDate:dateS]]];
    [_timeL setText:timeS];
    
    int i = 0;
    CGFloat mh = 0.0;
    for (SKUOrderModel *oModel in mInfo.skuArray) {
        mh = [self addGoodsViewWithFrame:CGRectMake(0, CGRectGetMaxY(_timeL.frame)+8+52*i, _bgView.width, 52) data:oModel tag:i+1000];
        i++;
    }
    
    
    [_addressL setText:mInfo.address.name];
    CGFloat textWidth = [_addressL sizeThatFits:CGSizeMake(200, 54)].width;
    [_addressL setFrame:CGRectMake(CGRectGetMaxX(_addressV.frame)+8, 0, textWidth, 54)];
    
    [_adView setFrame:CGRectMake((_bgView.width - CGRectGetMaxX(_addressL.frame))/2, mh, CGRectGetMaxX(_addressL.frame), 54)];
    
    [_bgView setFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, CGRectGetMaxY(_adView.frame))];
}


- (CGFloat )addGoodsViewWithFrame:(CGRect)mRect data:(SKUOrderModel *)skuData tag:(NSInteger)mTag {
    UIView *mV = [[UIView alloc] initWithFrame:mRect];
    [mV setTag:mTag];
    [self.bgView addSubview:mV];
    
     //商品
    UIImageView *goodsV = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, 36, 36)];
    goodsV.layer.masksToBounds = YES;
    //填充方式
    [goodsV setContentMode:UIViewContentModeScaleAspectFill];
    [mV addSubview:goodsV];
    [goodsV sd_setImageWithURL:[NSURL URLWithString:[skuData.proImg smallHead]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];

    UILabel *goodsL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsV.frame)+12, 8, mV.width - CGRectGetMaxX(goodsV.frame) - 25, 36)];
    [goodsL setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightLight]];
    [goodsL setTextColor:GARY_COLOR];
    goodsL.numberOfLines = 0;
    [goodsL setText:skuData.proName];
    [mV addSubview:goodsL];

    // 分割线
    UILabel *lineB = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(goodsV.frame)+7.5, mV.width-18, 0.5)];
    [lineB setBackgroundColor:LINE_COLOR];
    [mV addSubview:lineB];
    
    return CGRectGetMaxY(mV.frame);
}

@end
