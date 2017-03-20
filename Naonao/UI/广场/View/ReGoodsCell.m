//
//  ReGoodsCell.m
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ReGoodsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZWTagListView.h"
#import "ZQNewGuideView.h"

@interface ReGoodsCell ()

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) UILabel *bandL;      //品牌
@property (nonatomic, weak) UILabel *priceL;

@property (nonatomic, weak) ZWTagListView *tagList;

@property (nonatomic, strong) GoodsMode *mode;
@property (strong, nonatomic) ZQNewGuideView *guideView;

@end

@implementation ReGoodsCell

+ (ReGoodsCell *)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"ReGoodsCell";
    
    ReGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //删除重用
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    
    cell = [[ReGoodsCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
        [self.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    
    return self;
}


- (void)setUpChildView
{
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 96, 96)];
    _headV = headV;
    //图像填充方式
    [_headV setContentMode:UIViewContentModeScaleAspectFill];
    _headV.layer.masksToBounds = YES;
    [self.contentView addSubview:_headV];
    
    _headV.userInteractionEnabled = YES;
    //添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageActiondo:)];
    [_headV addGestureRecognizer:tapGesture];
    

    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+8, 4, SCREEN_WIDTH - CGRectGetMaxX(_headV.frame)-16, 20)];
    _titLabel = titLabel;
    [_titLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_titLabel setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_titLabel];
    
    UILabel *bandL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+8, 22, SCREEN_WIDTH - CGRectGetMaxX(_headV.frame)-22, 20)];
    _bandL = bandL;
    [_bandL setFont:[UIFont systemFontOfSize:13.0]];
    [_bandL setTextColor:[UIColor colorWithHex:0x707070]];
    [_bandL setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_bandL];
    
    
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame)+8, 45, SCREEN_WIDTH -CGRectGetMaxX(_headV.frame)-22, 20)];
    _priceL = priceL;
    [_priceL setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_priceL setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_priceL];
    
    ZWTagListView *tagList = [[ZWTagListView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headV.frame), 70, SCREEN_WIDTH -CGRectGetMaxX(_headV.frame), 30)];
    _tagList = tagList;
    _tagList.signalTagColor = PINK_COLOR;
    _tagList.GBbackgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:_tagList];

}


- (void)setCellWithCellInfo:(GoodsMode *)mode
{
    [_headV sd_setImageWithURL:[NSURL URLWithString:[mode.img middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    [_titLabel setText:mode.title];
    
    [_bandL setText:mode.brand];
    //货币显示形式
    [_priceL setText:[Units currencyStringWithNumber:mode.price]];
    
    NSMutableArray *mA = [[NSMutableArray alloc] initWithCapacity:mode.tags.count];
    
    for(NSString *st in mode.tags)
    {
        NSArray *s = [st componentsSeparatedByString:@":"];
        [mA addObject:[s lastObject]];
    }
    
    
    [_tagList setTagWithTagArray:mA];
    _mode = mode;
    
    BOOL firstComeInTeacherDetail = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowGoodsEnterHere"];
    if (!firstComeInTeacherDetail) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShowGoodsEnterHere"];
        //坐标转换
        CGRect rc = CGRectMake(_headV.frame.origin.x, _headV.frame.origin.y+104, _headV.frame.size.width, _headV.frame.size.height);
        [self makeGuideView:rc];
    }
    
}

- (void)imageActiondo:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(imageTapped:)]) {
        [_delegate imageTapped:_mode];
    }
}

#pragma mark - getter & setter
- (ZQNewGuideView *)guideView
{
    if (_guideView == nil) {
        _guideView = [[ZQNewGuideView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    }
    return _guideView;
}

- (void)makeGuideView:(CGRect)mRect{
    
    self.guideView.showRect = mRect;
    
    self.guideView.textImage = [UIImage imageNamed:@"prompt_goods.png"];
    self.guideView.textImageFrame = CGRectMake(110, 70, self.guideView.textImage.size.width, self.guideView.textImage.size.height);
    self.guideView.model = ZQNewGuideViewModeRoundRect;
    
    __typeof (&*self) __weak weakSelf = self;
    self.guideView.clickedShowRectBlock = ^{
        [weakSelf imageActiondo:nil];
        
    };
    
    //延迟执行
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
    });
    
}

@end
