//
//  AnswerCommentsView.m
//  Naonao
//
//  Created by 刘敏 on 16/6/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnswerCommentsView.h"
#import "MLEmojiLabel.h"
#import "AnswerMode.h"


#define COMMENTS_MORE   @"COMMENTS_MORE"        //查看全部评论


@interface AnswerCommentsView () <MLEmojiLabelDelegate, TTTAttributedLabelDelegate>

@property (nonatomic, weak) MLEmojiLabel *desLabel;
//评论内容
@property (nonatomic, weak) UIView *commentLabelView;
@property (nonatomic, weak) UILabel *lineV;

@end



@implementation AnswerCommentsView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
        //添加点击事件
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                    action:@selector(labelTouchUpInside:)];
        [self addGestureRecognizer:labelTapGestureRecognizer];
        
    }
    return self;
}

- (void)setUpChildView {
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
    
    
    UIView *commentLabelView = [[UIView alloc] init];
    self.commentLabelView = commentLabelView;
    [self addSubview:self.commentLabelView];
    
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineV = lineV;
    [_lineV setBackgroundColor:STROKE_GARY_COLOR];
    [self addSubview:self.lineV];
}

- (void)setAnFrame:(AnswerModeFrame *)anFrame {
    _anFrame = anFrame;
    //评论
    _commentLabelView.frame = self.anFrame.commentLabelFrame;
    
    //分割线
    _lineV.frame = self.anFrame.lineViewFrame;
    
    [self setUpChildData];
}

- (void)setUpChildData {
    [self setComments:_anFrame.aMode.comments.commentList imageAuthor:_anFrame.aMode.userInfo.userId];
}

#pragma mark - 评论列表
- (void)setComments:(NSArray *)cArray imageAuthor:(NSNumber *)authorID{
    
    for (MLEmojiLabel *commentLabel in self.commentLabelView.subviews) {
        [commentLabel removeFromSuperview];
    }
    //排序（以时间降序排列）
    NSSortDescriptor *sorter  = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sorter count:1];
    
    //排列后的数组（时间从小到大排列）
    NSMutableArray *sortArray = [[NSMutableArray alloc] initWithArray:[cArray sortedArrayUsingDescriptors:sortDescriptors]];
    
    NSInteger i = 0;
    CGFloat tempHeight = 0.0;
    
    //查看更多评论
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    for(STCommentData *cInfo in sortArray)
    {
        MLEmojiLabel *commentLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        commentLabel.numberOfLines = 0;
        commentLabel.font = [UIFont systemFontOfSize:13.0];
        commentLabel.delegate = self;
        commentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        commentLabel.customEmojiPlistName = @"MLEmoji_ExpressionImage";
        commentLabel.textAlignment = NSTextAlignmentLeft;
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.isNeedAtAndPoundSign = YES;
        
        NSString *tempS = @"";

        /**
         *  @param  cInfo.userId            评论发布者
         *  @param  cInfo.at_userId         被评论者
         */
        if ([cInfo.at_userId integerValue] == [authorID integerValue]) {
            //评论作者
            tempS = [NSString stringWithFormat:@"%@:  %@", cInfo.nickName, cInfo.content];
            commentLabel.text = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //评论者
            [dic setObject:[cInfo.userId stringValue] forKey:@"userID"];
            [commentLabel addLinkToTransitInformation:dic withRange:[commentLabel.text rangeOfString:cInfo.nickName]];
            CGSize size = [commentLabel preferredSizeWithMaxWidth:self.commentLabelView.frame.size.width];
            
            commentLabel.frame = CGRectMake(0, tempHeight, self.commentLabelView.frame.size.width, size.height);
            
            [self.commentLabelView addSubview:commentLabel];
            
            tempHeight += size.height+4;
        }
        else
        {
            //A评论B
            tempS = [NSString stringWithFormat:@"%@:  @%@  %@", cInfo.nickName, cInfo.at_nickName, cInfo.content];
            commentLabel.text = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            /********************************* 评论者 *************/
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[cInfo.userId stringValue] forKey:@"userID"];
            [commentLabel addLinkToTransitInformation:dic withRange:NSMakeRange(0, cInfo.nickName.length)];
            
            NSUInteger m_l = [[NSString stringWithFormat:@"%@:  ", cInfo.nickName] length];
            /********************************* 被评论者 *************/
            [dic setObject:[cInfo.at_userId stringValue] forKey:@"userID"];
            [commentLabel addLinkToTransitInformation:dic withRange:NSMakeRange(m_l, cInfo.at_nickName.length+1)];
            
            CGSize size = [commentLabel preferredSizeWithMaxWidth:self.commentLabelView.frame.size.width];
            commentLabel.frame = CGRectMake(0,  tempHeight, self.commentLabelView.frame.size.width, size.height);
            [self.commentLabelView addSubview:commentLabel];
            
            tempHeight += size.height+4;
        }
        
        i++;
    }
}



#pragma mark - MLEmojiDelegate

#pragma mark - MLEmojiLabelDelegate
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"点击了某个自添加链接%@",url);
    
}


- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    NSLog(@"点击了某个自添加链接%@",addressComponents);
}


- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    NSString *status = [components objectForKey:@"userID"];
    
    if ([status isEqualToString:COMMENTS_MORE]) {
        //进入评论列表
        if ([self.delegate respondsToSelector:@selector(answerCommentsView:answerMode:index:)]) {
            [self.delegate answerCommentsView:self answerMode:_anFrame.aMode index:_anFrame.index];
        }
    }
    else{
        //点击用户昵称
        if ([self.delegate respondsToSelector:@selector(answerCommentsView:WithUserId:)]) {
            [self.delegate answerCommentsView:self WithUserId:[NSNumber numberWithInteger:[status integerValue]]];
        }
    }
}

- (void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    if ([self.delegate respondsToSelector:@selector(answerCommentsView:answerMode:index:)]) {
        [self.delegate answerCommentsView:self answerMode:_anFrame.aMode index:_anFrame.index];
    }
    
}

@end
