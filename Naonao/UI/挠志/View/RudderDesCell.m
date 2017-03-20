//
//  RudderDesCell.m
//  Naonao
//
//  Created by 刘敏 on 16/8/5.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "RudderDesCell.h"
#import "SHLUILabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommunityLogic.h"


@interface RudderDesCell ()

@property (nonatomic, weak) UILabel *relationshipL;
@property (nonatomic, weak) UIButton *focusBtn;
@property (nonatomic, weak) UILabel *nickL;

@property (nonatomic, weak) UILabel *roleL;
@property (nonatomic, weak) SHLUILabel *desL;

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation RudderDesCell

+ (RudderDesCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RudderDesCell";
    
    RudderDesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[RudderDesCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.userInteractionEnabled = YES;
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView {
    
    UILabel *relationshipL = [[UILabel alloc] init];
    _relationshipL = relationshipL;
    [_relationshipL setTextColor:BLACK_COLOR];
    [_relationshipL setTextAlignment:NSTextAlignmentCenter];
    [_relationshipL setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightLight]];
    [self.contentView addSubview:_relationshipL];

    UIButton *focusBtn = [[UIButton alloc] init];
    _focusBtn = focusBtn;
    //圆角
    _focusBtn.layer.cornerRadius = 14;
    _focusBtn.layer.borderColor = BLACK_COLOR.CGColor;
    _focusBtn.layer.borderWidth = 0.5;
    _focusBtn.layer.masksToBounds = YES;
    [_focusBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_focusBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [_focusBtn addTarget:self action:@selector(followBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_focusBtn];
    
    UILabel *nickL = [[UILabel alloc] init];
    _nickL = nickL;
    [_nickL setTextColor:BLACK_COLOR];
    [_nickL setTextAlignment:NSTextAlignmentCenter];
    [_nickL setFont:[UIFont systemFontOfSize:18.0]];
    [self.contentView addSubview:_nickL];
    
    UILabel *roleL = [[UILabel alloc] init];
    _roleL = roleL;
    [_roleL setTextColor:LIGHT_BLACK_COLOR];
    [_roleL setTextAlignment:NSTextAlignmentCenter];
    [_roleL setFont:[UIFont systemFontOfSize:11.0]];
    [self.contentView addSubview:_roleL];
    
    
    SHLUILabel *desL = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    _desL = desL;
    _desL.numberOfLines = 0;
    [_desL setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightLight]];
    [_desL setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_desL];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    _scrollView = scrollView;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:_scrollView];
}

- (void)setModeFrame:(RudderDesModeFrame *)modeFrame
{
    _modeFrame = modeFrame;
    _relationshipL.frame = _modeFrame.relationshipFrame;
    _focusBtn.frame = _modeFrame.focusFrame;
    _nickL.frame = _modeFrame.nickFrame;
    _roleL.frame = _modeFrame.roleFrame;
    _desL.frame = _modeFrame.desFrame;
    _scrollView.frame = _modeFrame.scrollViewFrame;
    
    [self setCellWithCellInfo:_modeFrame.sData];
}

- (void)setCellWithCellInfo:(STDuozhu *)model {
    NSString *st = [NSString stringWithFormat:@"%@ 关注的人，%@ 粉丝", model.follower, model.fans];
    NSString *followS = [model.follower stringValue];
    NSString *fanS = [model.fans stringValue];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
	[str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium] range:NSMakeRange(0, followS.length)];
	[str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium] range:NSMakeRange(st.length-3-fanS.length, fanS.length)];

    _relationshipL.attributedText = str;
    
    if ([model.isFollow boolValue]) {
        //已关注
        _focusBtn.layer.borderColor = BLACK_COLOR.CGColor;
        [_focusBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [_focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    else {
        _focusBtn.layer.borderColor = PINK_COLOR.CGColor;
        [_focusBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
        [_focusBtn setTitle:@"关 注" forState:UIControlStateNormal];
    }
    
    [_nickL setText:model.nickname];
    [_roleL setText:[NSString stringWithFormat:@"%@  |  %@", model.extraInfo.job, model.extraInfo.constellation]];
    [_desL setText:model.extraInfo.introduce];
    
    [self drawScrollView:model.extraInfo.photos];
}

- (void)drawScrollView:(NSArray *)photos
{
    int i = 0;
    for (NSString *imageURL in photos) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15+145*i, 0, 130, 130)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:[imageURL middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
        [_scrollView addSubview:imageV];
        
        //添加点击事件
        imageV.userInteractionEnabled = YES;
        imageV.tag = 1000+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouchUpInside:)];
        [imageV addGestureRecognizer:tap];
        
        i++;
    }
    
    CGFloat mW = 15+145*photos.count;
    [_scrollView setContentSize:CGSizeMake(mW, 130)];
}

- (void)followBtnTapped:(id)sender {
    
    if (![UserLogic sharedInstance].user.basic.userId) {
        [theAppDelegate popLoginView];
        return;
    }
    
    
    NSMutableDictionary *dict =[[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setObject:_modeFrame.sData.userid forKey:@"following"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    if ([_modeFrame.sData.isFollow boolValue]) {
        //取消关注
        [[CommunityLogic sharedInstance] getUnAttentionUserInfo:dict withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                weakSelf.modeFrame.sData.isFollow = [NSNumber numberWithBool:NO];
                weakSelf.focusBtn.layer.borderColor = PINK_COLOR.CGColor;
                [weakSelf.focusBtn setTitleColor:PINK_COLOR forState:UIControlStateNormal];
                [weakSelf.focusBtn setTitle:@"关 注" forState:UIControlStateNormal];
            }
            else
                [theAppDelegate.window makeToast:result.stateDes];
        }];
    }
    else{
        //关注
        [[CommunityLogic sharedInstance] getAttentionUserInfo:dict withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                weakSelf.modeFrame.sData.isFollow = [NSNumber numberWithBool:YES];
                weakSelf.focusBtn.layer.borderColor = BLACK_COLOR.CGColor;
                [weakSelf.focusBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
                [weakSelf.focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
                
            }
            else
                [theAppDelegate.window makeToast:result.stateDes];
        }];
    }
}

//图片点击
- (void)imageTouchUpInside:(UITapGestureRecognizer *)recognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(recognizer.view.tag - 1000) inSection:0];
    
    if ([self.delegate respondsToSelector:@selector(rudderDesCell:didSelectItemAtIndexPath:)]) {
        [self.delegate rudderDesCell:self didSelectItemAtIndexPath:indexPath];
    }
    
}


@end
