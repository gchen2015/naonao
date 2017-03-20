//
//  CommentsHeadCell.m
//  Naonao
//
//  Created by 刘敏 on 16/4/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CommentsHeadCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MLEmojiLabel.h"
#import "CatZanButton.h"
#import "CommunityLogic.h"



#define kHeadVHeight 36



@interface CommentsHeadCell () <MLEmojiLabelDelegate,TTTAttributedLabelDelegate>

@property (nonatomic, strong) DynamicInfo *dInfo;
//商品图片
@property (nonatomic, weak) UIImageView *imageBtn;
//发布者头像
@property (nonatomic, weak) UIButton *headBtn;
//昵称
@property (nonatomic, weak) UILabel *nickName;
@property (nonatomic, weak) UILabel *timeL;

@property (nonatomic, weak) MLEmojiLabel *desLabel;


//@property (nonatomic, weak) UILabel *nameL;
//@property (nonatomic, weak) UILabel *priceL;
////品牌
//@property (nonatomic, weak) UILabel *brandL;


//喜欢按钮
@property (nonatomic, weak) CatZanButton *favButton;
@property (nonatomic, weak) UILabel *lineV;

@end

@implementation CommentsHeadCell


+ (CommentsHeadCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CommentsHeadCell";
    
    CommentsHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CommentsHeadCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    //商品图片
    UIImageView *imageBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _imageBtn = imageBtn;
    //图片填充方式
    [_imageBtn setContentMode:UIViewContentModeScaleAspectFill];
    _imageBtn.layer.masksToBounds = YES;
    _imageBtn.userInteractionEnabled = YES;

    //填充方式
    [self.contentView addSubview:_imageBtn];
    
    
    //开启触摸事件
    UIButton *singleTap = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [singleTap setBackgroundColor:[UIColor clearColor]];
    [singleTap addTarget:self action:@selector(imageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_imageBtn addSubview:singleTap];
    
    
    UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(14 , SCREEN_WIDTH + 14, kHeadVHeight , kHeadVHeight)];
    _headBtn = headBtn;
    //头像圆角
    [_headBtn.layer setCornerRadius:kHeadVHeight * 0.5];
    _headBtn.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    _headBtn.layer.borderWidth = 0.5;
    _headBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:_headBtn];
    
    //昵称
    UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headBtn.frame)+8, SCREEN_WIDTH + 15, 120, 16)];
    _nickName = nickName;
    _nickName.font = [UIFont systemFontOfSize:14.0];
    _nickName.backgroundColor = [UIColor clearColor];
    [_nickName setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_nickName];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headBtn.frame)+8, SCREEN_WIDTH + 14+20, 120, 16)];
    _timeL = timeL;
    _timeL.font = [UIFont systemFontOfSize:11.0];
    _timeL.backgroundColor = [UIColor clearColor];
    [_timeL setTextColor:LIGHT_BLACK_COLOR];
    [self.contentView addSubview:_timeL];
    
    
    //喜欢按钮
    CatZanButton *favButton = [[CatZanButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, SCREEN_WIDTH + 17, 30, 30)
                                                         zanImage:[UIImage imageNamed:@"icon_praise1_selected.png"]
                                                       unZanImage:[UIImage imageNamed:@"icon_praise1.png"]];
    _favButton = favButton;
    [_favButton setType:CatZanButtonTypeFirework];
    [self.contentView addSubview:_favButton];
    
    //商品评论
    MLEmojiLabel *desLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    _desLabel = desLabel;
    _desLabel.numberOfLines = 0;
    _desLabel.font = [UIFont systemFontOfSize:14.0];
    _desLabel.delegate = self;
    _desLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _desLabel.customEmojiPlistName = @"MLEmoji_ExpressionImage";
    _desLabel.textAlignment = NSTextAlignmentLeft;
    _desLabel.backgroundColor = [UIColor clearColor];
    _desLabel.isNeedAtAndPoundSign = YES;
    [self addSubview:_desLabel];
    
    
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineV = lineV;
    [_lineV setBackgroundColor:[UIColor colorWithHex:0xcdcdcd]];
    [self addSubview:_lineV];
    

//    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headBtn.frame)+10, 8, SCREEN_WIDTH - CGRectGetMaxX(_headBtn.frame)-24 , 24)];
//    _nameL = nameL;
//    [_nameL setFont:[UIFont systemFontOfSize:20.0]];
//    [self.contentView addSubview:_nameL];
//    
//    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headBtn.frame)+10, 45, 100 , 18)];
//    _priceL = priceL;
//    [_priceL setTextColor:PINK_COLOR];
//    [_priceL setFont:[UIFont systemFontOfSize:16.0]];
//    [self.contentView addSubview:_priceL];
//    
//    UILabel *brandL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headBtn.frame)+10, 70, CGRectGetMaxX(_headBtn.frame)-24 , 18)];
//    _brandL = brandL;
//    [_brandL setTextColor:BLACK_COLOR];
//    [_brandL setFont:[UIFont systemFontOfSize:15.0]];
//    [self.contentView addSubview:_brandL];

}

- (CGFloat)setCellWithCellInfo:(DynamicInfo *)dInfo
{
    
    _dInfo = dInfo;
    
    _favButton.isZan = [dInfo.pInfo.isLike boolValue];
    
    [_favButton setClickHandler:^(CatZanButton *favButton) {
        if (favButton.isZan) {
            //喜欢
            [self favorableMagazine];
        }
        else
        {
            [self unFavorableMagazine];
        }
    }];
    
    
    if (dInfo.pInfo.proImg) {
        [_imageBtn sd_setImageWithURL:[NSURL URLWithString:dInfo.pInfo.proImg] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    }
    else{
        [_imageBtn setImage:[UIImage imageNamed:@"default_image.png"]];
    }
    
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dInfo.userInfo.portraitUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
    
    [_nickName setText:dInfo.userInfo.userName];
    [_timeL setText:dInfo.pInfo.time];
    
    
    [_desLabel setText:dInfo.pInfo.desc];
    CGSize size = [_desLabel preferredSizeWithMaxWidth:SCREEN_WIDTH- 28];
    [_desLabel setFrame:CGRectMake(14, CGRectGetMaxY(_headBtn.frame)+16, size.width, size.height)];
    
    [_lineV setFrame:CGRectMake(0, CGRectGetMaxY(_desLabel.frame) + 19.5, SCREEN_WIDTH, 0.5)];
    
    return CGRectGetMaxY(_desLabel.frame) + 20;
    
    
//    [_nameL setText:pInfo.title];
//    [_priceL setText:[NSString stringWithFormat:@"￥%@", pInfo.price]];
//    [_brandL setText:[NSString stringWithFormat:@"#%@", pInfo.brand]];
}


- (void)imageButtonTapped:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(commentsHeadCellClickGoods)]) {
        [_delegate commentsHeadCellClickGoods];
    }
}

//点赞
- (void)favorableMagazine {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:_dInfo.pInfo.showId forKey:@"show_id"];
    [dic setObject:_dInfo.userInfo.userId forKey:@"show_userid"];
    
    
    [[CommunityLogic sharedInstance] getShowPraise:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _dInfo.pInfo.isLike = [NSNumber numberWithBool:YES];
            _dInfo.pInfo.likeCount = [NSNumber numberWithInteger:[_dInfo.pInfo.likeCount integerValue]+1];
        }
        else
            [theAppDelegate.window makeToast:result.stateDes];
    }];
}

//取消点赞
- (void)unFavorableMagazine {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:_dInfo.userInfo.userId forKey:@"show_userid"];
    [dic setObject:_dInfo.pInfo.showId forKey:@"show_id"];
    
    [[CommunityLogic sharedInstance] getShowUnPraise:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _dInfo.pInfo.isLike = [NSNumber numberWithBool:NO];
            _dInfo.pInfo.likeCount = [NSNumber numberWithInteger:[_dInfo.pInfo.likeCount integerValue]-1];
        }
        else
            [theAppDelegate.window makeToast:result.stateDes];
    }];
}


@end
