//
//  AnswerToolbarView.m
//  Naonao
//
//  Created by 刘敏 on 16/6/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnswerToolbarView.h"
#import "CatZanButton.h"
#import "SquareLogic.h"


@interface AnswerToolbarView ()
//喜欢按钮
@property (nonatomic, weak) CatZanButton *favButton;
//喜欢数量
@property (nonatomic, weak) UILabel *favLabel;
//评论
@property (nonatomic, weak) UIButton *commentButton;

@end

@implementation AnswerToolbarView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView{
    //喜欢按钮
    CatZanButton *favButton = [[CatZanButton alloc] initWithFrame:CGRectMake(8, 7.5, 30, 30)
                                                         zanImage:[UIImage imageNamed:@"icon_praise_selected.png"]
                                                       unZanImage:[UIImage imageNamed:@"icon_praise.png"]];
    _favButton = favButton;
    [_favButton setType:CatZanButtonTypeFirework];
    [self addSubview:_favButton];
    
    
    //喜欢的数量
    UILabel *favLabel = [[UILabel alloc] init];
    _favLabel = favLabel;
    [_favLabel setTextColor:LIGHT_BLACK_COLOR];
    [_favLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self addSubview:_favLabel];
    
    //评论
    UIButton *commentButton = [[UIButton alloc] init];
    _commentButton = commentButton;
    [_commentButton setImage:[UIImage imageNamed:@"iconfont_pinglun.png"] forState:UIControlStateNormal];
    [_commentButton setTitle:@" 添加评论" forState:UIControlStateNormal];
    [_commentButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_commentButton setTitleColor:LIGHT_BLACK_COLOR forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(commentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentButton];
    
}


- (void)setAnFrame:(AnswerModeFrame *)anFrame {
    _anFrame = anFrame;
    _favLabel.frame = anFrame.favLabelFrame;
    _commentButton.frame = anFrame.commentButtonFrame;
    
    [self setUpChildData];
}

- (void)setUpChildData
{
    _favButton.isZan = [_anFrame.aMode.isLike boolValue];
    
    [_favButton setClickHandler:^(CatZanButton *favButton) {
        
        //判断是否登录
        if (![UserLogic sharedInstance].user.basic.userId) {
            [theAppDelegate popLoginView];
            return;
        }
        
        if (favButton.isZan) {
            //喜欢
            [self favorableMagazine];
        }
        else
        {
            [self unFavorableMagazine];
        }
    }];
    
    [_favLabel setText:[NSString stringWithFormat:@"%ld", (long)[_anFrame.aMode.likeCount integerValue]]];
}



//评论
- (void)commentButtonTapped:(id)sender
{
    //进入评论列表
    if ([self.delegate respondsToSelector:@selector(answerToolsbarView:answerMode:index:)]) {
        [self.delegate answerToolsbarView:self answerMode:_anFrame.aMode index:_anFrame.index];
    }
}

//点赞
- (void)favorableMagazine {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_anFrame.aMode.answerId forKey:@"answer_id"];
    
    
    [[SquareLogic sharedInstance] getShowPraise:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _anFrame.aMode.isLike = [NSNumber numberWithBool:YES];
            [_favLabel setText:[NSString stringWithFormat:@"%ld", (long)[_anFrame.aMode.likeCount integerValue]+1]];
            _anFrame.aMode.likeCount = [NSNumber numberWithInteger:[_anFrame.aMode.likeCount integerValue]+1];
        }
        else
            [theAppDelegate.window makeToast:result.stateDes];
    }];
}

//取消点赞
- (void)unFavorableMagazine {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_anFrame.aMode.answerId forKey:@"answer_id"];
    
    [[SquareLogic sharedInstance] getShowUnPraise:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _anFrame.aMode.isLike = [NSNumber numberWithBool:NO];
            [_favLabel setText:[NSString stringWithFormat:@"%ld", (long)[_anFrame.aMode.likeCount integerValue]-1]];
            _anFrame.aMode.likeCount = [NSNumber numberWithInteger:[_anFrame.aMode.likeCount integerValue]-1];
        }
        else
            [theAppDelegate.window makeToast:result.stateDes];
    }];
}



@end
