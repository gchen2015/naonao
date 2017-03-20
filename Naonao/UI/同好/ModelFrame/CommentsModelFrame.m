//
//  CommentsModelFrame.m
//  Naonao
//
//  Created by 刘敏 on 16/4/7.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "CommentsModelFrame.h"
#import "MLEmojiLabel.h"
#import "SHLUILabel.h"

@implementation CommentsModelFrame

- (void)setTData:(STCommentData *)tData
{
    _tData = tData;
    
    [self setUpAllFrame];
}

- (void)setAuthorID:(NSNumber *)authorID
{
    _authorID = authorID;
}

- (void)setUpAllFrame{
    _headVFrame = CGRectMake(14, 14, 30, 30);
    _nameLabelFrame = CGRectMake(CGRectGetMaxX(_headVFrame)+10, 14, 200, 18);
    _timeFrame = CGRectMake(SCREEN_WIDTH - 134, 14, 120, 18);
    _contentFrame = CGRectMake(CGRectGetMaxX(_headVFrame)+10, CGRectGetMaxY(_nameLabelFrame)+12, SCREEN_WIDTH- CGRectGetMaxX(_headVFrame)-24, [self calculatecontentFrameHeight]);
    
    _rowHeight = CGRectGetMaxY(_contentFrame)+15;
}

- (CGFloat)calculatecontentFrameHeight
{
    MLEmojiLabel *commentLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    commentLabel.numberOfLines = 0;
    commentLabel.font = [UIFont systemFontOfSize:14.0];
    commentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    commentLabel.customEmojiPlistName = @"MLEmoji_ExpressionImage";
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.isNeedAtAndPoundSign = YES;
    
    NSString *tempS = @"";

    //计算评论区域高度
    if ([_tData.at_userId integerValue] == [_authorID integerValue]) {
        //评论作者
        tempS = [NSString stringWithFormat:@"%@", _tData.content];
    }
    else
    {
        //A评论B
        tempS = [NSString stringWithFormat:@"@%@  %@", _tData.at_nickName, _tData.content];
    }
    
    commentLabel.text = [tempS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGSize size = [commentLabel preferredSizeWithMaxWidth:SCREEN_WIDTH- CGRectGetMaxX(_headVFrame)-10  - 14];
    
    return size.height;
}

@end



@implementation CommentsProductFrame

- (void)setTData:(CommentInfo *)tData
{
    _tData = tData;
    
    [self setUpAllFrame];
}


- (void)setUpAllFrame{
    _headVFrame = CGRectMake(14, 14, 36, 36);
    _nameLabelFrame = CGRectMake(CGRectGetMaxX(_headVFrame)+10, 14, 200, 36);
    _timeFrame = CGRectMake(SCREEN_WIDTH - 134, 14, 120, 36);
    _contentFrame = CGRectMake(14.0, CGRectGetMaxY(_headVFrame) + 14, SCREEN_WIDTH-28, [self calculatecontentFrameHeight]);
    
    _rowHeight = CGRectGetMaxY(_contentFrame)+16;
}


- (CGFloat)calculatecontentFrameHeight
{
    SHLUILabel *commentLabel = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    commentLabel.numberOfLines = 0;
    commentLabel.font = [UIFont systemFontOfSize:15.0];
    commentLabel.textAlignment = NSTextAlignmentLeft;

    [commentLabel setText:_tData.content];
    
    return [commentLabel getAttributedStringHeightWidthValue:SCREEN_WIDTH-28];
}


@end
