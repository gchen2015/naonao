//
//  AnswerModeFrame.m
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnswerModeFrame.h"
#import "SHLUILabel.h"
#import "MLEmojiLabel.h"

#define OFFSET_X_RIGHT          14
#define kBottomMargin           15


@implementation AnswerModeFrame

- (void)setAMode:(AnswerMode *)aMode
{
    _aMode = aMode;
    [self setUpAllFrame];
}

- (void)setUpAllFrame{
    
    //顶部
    [self setUpHeadFrame];
    
    //文字说明
    [self setUpCenterFrame];
    
    //推荐的商品
    [self setUpToolsFrame];
    
    //评论区域
    [self setUpComFrame];
    
    //底部菜单区域
    [self setUpMenuFrame];
}


- (void)setUpHeadFrame
{
    _headFrame = CGRectMake(OFFSET_X_RIGHT, OFFSET_X_RIGHT, 30, 30);
    //计算文字
    CGSize textSize = [_aMode.userInfo.nickname boundingRectWithSize:CGSizeMake(200, 100)
                                                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],}
                                                           context:nil].size;
    
    _nikeFrame = CGRectMake(CGRectGetMaxX(_headFrame)+8, OFFSET_X_RIGHT, textSize.width, 30);
    //是舵主
    if ([_aMode.userInfo.isContract boolValue]) {
        _tipFrame = CGRectMake(CGRectGetMaxX(_nikeFrame)+2, 20, 18, 18);
    }
    
    _similarFrame  = CGRectMake(SCREEN_WIDTH - 170, OFFSET_X_RIGHT-4, 156, 30);
    
    _aboveFrame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_headFrame)+10);
}

- (void)setUpCenterFrame
{
    SHLUILabel *mL = [[SHLUILabel alloc] init];
    [mL setFont:[UIFont systemFontOfSize:14.0]];
    mL.lineBreakMode = NSLineBreakByWordWrapping;
    mL.numberOfLines = 0;
    mL.text = _aMode.content;
    
    
    CGFloat mH = [mL getAttributedStringHeightWidthValue:SCREEN_WIDTH - 28];
    //文字
    _flagLFrame = CGRectMake(OFFSET_X_RIGHT, 0, SCREEN_WIDTH - 28, mH);
    
    
    if (_aMode.links.count > 0 ) {
        //单个图片大小
        CGFloat s_W = (SCREEN_WIDTH - 28 - 4*2)/3.0f;
        if(_aMode.links.count > 1){
            
            NSUInteger row = (_aMode.links.count - 1)/3 + 1;
            
            CGFloat s_H = s_W * row + 4*(row-1);
            
            _picFrame = CGRectMake(OFFSET_X_RIGHT, CGRectGetMaxY(_flagLFrame)+10, SCREEN_WIDTH - 28, s_H+8);
        }
        else
            _picFrame = CGRectMake(OFFSET_X_RIGHT, CGRectGetMaxY(_flagLFrame)+10, s_W*2, s_W*2+8);
    }
    else
        _picFrame = CGRectMake(OFFSET_X_RIGHT, CGRectGetMaxY(_flagLFrame)+0, 0, 0);
    
    
    _centerFrame = CGRectMake(0, CGRectGetMaxY(_aboveFrame), SCREEN_WIDTH, CGRectGetMaxY(_picFrame)+10);
}


- (void)setUpToolsFrame
{
    if (_aMode.proData) {
        _garyFrame = CGRectMake(OFFSET_X_RIGHT, 0, SCREEN_WIDTH-28, 70);
        _goodsFrame = CGRectMake(15, 1, 68, 68);
        
        CGFloat mW = CGRectGetWidth(_garyFrame) - CGRectGetMaxX(_goodsFrame) - 8;
        
        _goodsNFrame = CGRectMake(CGRectGetMaxX(_goodsFrame) + 10, 4, mW , 20);
        _brandFrame  = CGRectMake(CGRectGetMaxX(_goodsFrame) + 10, 24, mW, 20);
        _priceFrame = CGRectMake(CGRectGetMaxX(_goodsFrame) + 8, 45, mW, 20);
        
        _bottomFrame = CGRectMake(0, CGRectGetMaxY(_centerFrame), SCREEN_WIDTH, CGRectGetMaxY(_garyFrame)+20);
    }
    else
    {
        _bottomFrame = CGRectMake(0, CGRectGetMaxY(_centerFrame), SCREEN_WIDTH, 0);
    }
}

- (void)setUpComFrame {
    //评论
    CGFloat height = 0;
    
    if (_aMode.comments.commentList.count > 0) {
        height = [self setComments:_aMode.comments.commentList imageAuthor:_aMode.userInfo.userId];
        _commentLabelFrame = CGRectMake(OFFSET_X_RIGHT, 0 , SCREEN_WIDTH - OFFSET_X_RIGHT*2, height);
        _comFrame = CGRectMake(0, CGRectGetMaxY(_bottomFrame), SCREEN_WIDTH, CGRectGetMaxY(_commentLabelFrame)+kBottomMargin);
    }
    else
        _comFrame = CGRectMake(0, CGRectGetMaxY(_bottomFrame), SCREEN_WIDTH, 0.5);
    

    _lineViewFrame = CGRectMake(0, CGRectGetHeight(_comFrame)-0.5, SCREEN_WIDTH, 0.5);

}

- (void)setUpMenuFrame {
    _favLabelFrame = CGRectMake(38, 7.5, 50, 30);
    _commentButtonFrame = CGRectMake(SCREEN_WIDTH/2 - 50, 7.5, 100, 30);
    _toolsFrame = CGRectMake(0, CGRectGetMaxY(_comFrame), SCREEN_WIDTH, 45);
    
    _rowHeight = CGRectGetMaxY(_toolsFrame);
}


//设置评论
- (CGFloat)setComments:(NSArray *)cArray imageAuthor:(NSNumber *)authorID
{
    //排序（以时间降序排列）
    NSSortDescriptor *sorter  = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:&sorter count:1];
    
    //排列后的数组（时间从小到大排列）
    NSMutableArray *sortArray = [[NSMutableArray alloc] initWithArray:[cArray sortedArrayUsingDescriptors:sortDescriptors]];
    
    NSInteger i = 0;
    CGFloat tempHeight = 0.0;
    
    //查看更多评论
    for(STCommentData *cInfo in sortArray)
    {
        MLEmojiLabel *commentLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        commentLabel.numberOfLines = 0;
        commentLabel.font = [UIFont systemFontOfSize:13.0];
        commentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        commentLabel.customEmojiPlistName = @"MLEmoji_ExpressionImage";
        commentLabel.textAlignment = NSTextAlignmentLeft;
        commentLabel.backgroundColor = [UIColor clearColor];
        commentLabel.isNeedAtAndPoundSign = YES;
        
        NSString *tempS = @"";
        
        //计算评论区域高度
        if ([cInfo.at_userId integerValue] == [authorID integerValue]) {
            //评论作者
            tempS = [NSString stringWithFormat:@"%@:  %@", cInfo.nickName, cInfo.content];
        }
        else
        {
            //A评论B
            tempS = [NSString stringWithFormat:@"%@:  @%@  %@", cInfo.nickName, cInfo.at_nickName, cInfo.content];
        }
        
        commentLabel.text = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        CGSize size = [commentLabel preferredSizeWithMaxWidth:SCREEN_WIDTH- OFFSET_X_RIGHT  - OFFSET_X_RIGHT];
        tempHeight += size.height+4;
        
        i++;
    }
    
    return tempHeight;
}

@end
