//
//  WalletTimelineCell.m
//  Naonao
//
//  Created by 刘敏 on 16/5/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WalletTimelineCell.h"
#import "TimeUtil.h"



#define DotViewCentX 20                         //圆点中心 x坐标
#define VerticalLineWidth 2                     //时间轴 线条 宽度
#define ShowLabTop 10                           //cell间距
#define DotViewRadius  4

#define ShowLabWidth (320 - DotViewCentX - 20)
#define ShowLabFont [UIFont systemFontOfSize:15]


@interface WalletTimelineCell ()

@property (nonatomic, weak) UIView *verticalLineTopView;        //顶部线条
@property (nonatomic, weak) UIView *dotView;                    //原点
@property (nonatomic, weak) UIView *verticalLineBottomView;     //底部线条

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *phaseLabel;
@property (nonatomic, weak) UILabel *timeL;

@end


@implementation WalletTimelineCell


+ (WalletTimelineCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"WalletTimelineCell";
    
    WalletTimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WalletTimelineCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
        self.contentView.backgroundColor = BACKGROUND_GARY_COLOR;

    }
    
    return self;
}

- (void)setUpChildView{
    //顶部线条
    UIView *verticalLineTopView = [[UIView alloc] initWithFrame:CGRectMake(27, 0, 2, 40.5)];
    _verticalLineTopView = verticalLineTopView;
    _verticalLineTopView.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:_verticalLineTopView];
    
    //底部线条
    UIView *verticalLineBottomView = [[UIView alloc] initWithFrame:CGRectMake(27, 48.5, 2, 16.5)];
    _verticalLineBottomView = verticalLineBottomView;
    _verticalLineBottomView.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:_verticalLineBottomView];
    
    //点
    UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(24, 40.5, DotViewRadius * 2, DotViewRadius * 2)];
    _dotView = dotView;
    _dotView.backgroundColor = LIGHT_BLACK_COLOR;
    _dotView.layer.cornerRadius = DotViewRadius;
    [self.contentView addSubview:_dotView];

    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(45, 30, 25, 25)];
    _headV = headV;
    //填充方式
    [_headV setContentMode:UIViewContentModeScaleAspectFit];
    _headV.layer.masksToBounds = YES;
    [self.contentView addSubview:_headV];
    
    //文字描述
    UILabel *phaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, SCREEN_WIDTH-94, 20)];
    _phaseLabel = phaseLabel;
    [_phaseLabel setTextColor:BLACK_COLOR];
    [_phaseLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:_phaseLabel];
    
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(80, 48, 130, 20)];
    _timeL = timeL;
    [_timeL setTextColor:LIGHT_BLACK_COLOR];
    [_timeL setFont:[UIFont systemFontOfSize:11.0]];
    [_timeL setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_timeL];
}

- (void)setCellWithCellWPInfo:(WPayTimeline *)pInfo
{
    [_headV setImage:[UIImage imageNamed:@"recommended_icon.png"]];
    [_phaseLabel setText:[NSString stringWithFormat:@"通过你的推荐，卖出1单，获得%@元", pInfo.amount]];
    
    [_timeL setText:pInfo.payTime];
}

- (void)setCellWithCellWSInfo:(WShowTimeline *)showTime
{
    [_verticalLineBottomView setHidden:YES];
    [_headV setImage:[UIImage imageNamed:@"release_icon.png"]];
    
    [_phaseLabel setText:@"给用户推荐商品"];
    [_timeL setText:showTime.createTime];
}


- (void)updateDotView
{
    _dotView.backgroundColor = PINK_COLOR;
    
    UIView *shadowV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    [shadowV setBackgroundColor:[UIColor colorWithHex:0xc9b27b alpha:0.4]];
    shadowV.center = _dotView.center;
    shadowV.layer.cornerRadius = 6;
    [self.contentView addSubview:shadowV];
}

@end
