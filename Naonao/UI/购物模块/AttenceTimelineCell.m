//
//  AttenceTimelineCell.m
//  Naonao
//
//  Created by 刘敏 on 16/4/11.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AttenceTimelineCell.h"
#import "SHLUILabel.h"


#define DotViewCentX 20                                         //圆点中心 x坐标
#define VerticalLineWidth 2                                     //时间轴 线条 宽度
#define ShowLabTop 10                                           //cell间距
#define DotViewRadius  4

#define ShowLabWidth (320 - DotViewCentX - 20)
#define ShowLabFont [UIFont systemFontOfSize:15]



@interface AttenceTimelineCell ()

@property (nonatomic, weak) UIView *verticalLineTopView;        //顶部线条
@property (nonatomic, weak) UIView *dotView;                    //原点
@property (nonatomic, weak) UIView *verticalLineBottomView;     //底部线条

@property (nonatomic, weak) SHLUILabel *phaseLabel;
@property (nonatomic, weak) UILabel *timeL;
@property (nonatomic, weak) UILabel *lineV;

@end


@implementation AttenceTimelineCell

+ (AttenceTimelineCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AttenceTimelineCell";
    
    AttenceTimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //删除重用
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    
    cell = [[AttenceTimelineCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
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
    //顶部线条
    UIView *verticalLineTopView = [[UIView alloc] initWithFrame:CGRectMake(27, 0, 2, 20)];
    _verticalLineTopView = verticalLineTopView;
    _verticalLineTopView.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:_verticalLineTopView];

    //底部线条
    UIView *verticalLineBottomView = [[UIView alloc] initWithFrame:CGRectZero];
    _verticalLineBottomView = verticalLineBottomView;
    _verticalLineBottomView.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:_verticalLineBottomView];
    
    //点
    UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(24, 20, DotViewRadius * 2, DotViewRadius * 2)];
    _dotView = dotView;
    _dotView.backgroundColor = LIGHT_GARY_COLOR;
    _dotView.layer.cornerRadius = DotViewRadius;
    [self.contentView addSubview:_dotView];
    
    SHLUILabel *phaseLabel = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    _phaseLabel = phaseLabel;
    [_phaseLabel setTextColor:GARY_COLOR];
    [_phaseLabel setFont:[UIFont systemFontOfSize:14.0]];
    _phaseLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _phaseLabel.numberOfLines = 0;
    [_phaseLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_phaseLabel];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeL = timeL;
    [_timeL setTextColor:GARY_COLOR];
    [_timeL setFont:[UIFont systemFontOfSize:11.0]];
    [self.contentView addSubview:_timeL];
    
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineV = lineV;
    [_lineV setBackgroundColor:STROKE_GARY_COLOR];
    [self.contentView addSubview:_lineV];
}


- (void)setCellWithCellInfo:(AcceptStation *)aInfo row:(NSInteger)mRow
{
    if (mRow == 0) {
        //当前状态
        [_phaseLabel setTextColor:PINK_COLOR];
        [_timeL setTextColor:PINK_COLOR];
        
        [_verticalLineTopView setHidden:YES];
        
        CGPoint mpoint = _dotView.center;
        UIImageView *point = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redPointRefund.png"]];
        [point setFrame:CGRectMake(0, 0, 17, 17)];
        point.center = mpoint;
        [self.contentView addSubview:point];

    }
    
    [_phaseLabel setText:aInfo.station];
    CGFloat mH = [_phaseLabel getAttributedStringHeightWidthValue:SCREEN_WIDTH - 70];
    [_phaseLabel setFrame:CGRectMake(55, 15, SCREEN_WIDTH - 70, mH)];
    
    [_timeL setFrame:CGRectMake(55, CGRectGetMaxY(_phaseLabel.frame)+4, SCREEN_WIDTH - 70, 12)];
    [_timeL setText:aInfo.time];
    
    _mH = CGRectGetMaxY(_timeL.frame)+15;
    
    [_verticalLineBottomView setFrame:CGRectMake(27, CGRectGetMaxY(_dotView.frame), 2, _mH - CGRectGetMaxY(_dotView.frame))];
    [_lineV setFrame:CGRectMake(52, _mH-0.5, SCREEN_WIDTH - 52, 0.5)];
}

@end
