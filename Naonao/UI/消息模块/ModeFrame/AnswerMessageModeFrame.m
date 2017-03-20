//
//  AnswerMessageModeFrame.m
//  Naonao
//
//  Created by 刘敏 on 16/8/21.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnswerMessageModeFrame.h"
#import "SHLUILabel.h"
#import "MLEmojiLabel.h"


@implementation AnswerMessageModeFrame

- (void)setPMode:(STMessageCare *)pMode{
    _pMode = pMode;
    [self setUpAllFrame];
}

- (void)setUpAllFrame{
    //计算高度
    CGSize titleSize = [_pMode.content.name boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 67, MAXFLOAT)
                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}
                                                         context:nil].size;
    
    _nickNameFrame = CGRectMake(15, 15, titleSize.width, titleSize.height);
    _contentFrame = CGRectMake(CGRectGetMaxX(_nickNameFrame)+5, 15, 200, titleSize.height);
    
    
    MLEmojiLabel *commentsL = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    commentsL.numberOfLines = 0;
    commentsL.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    commentsL.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    commentsL.customEmojiPlistName = @"MLEmoji_ExpressionImage";
    commentsL.textAlignment = NSTextAlignmentLeft;
    commentsL.backgroundColor = [UIColor clearColor];
    commentsL.isNeedAtAndPoundSign = YES;
    [commentsL setText:_pMode.content.question.orderInfo.content];
    
    CGFloat mH = [commentsL preferredSizeWithMaxWidth:SCREEN_WIDTH - 30].height;
    _commentsFrame = CGRectMake(15, CGRectGetMaxY(_nickNameFrame)+8, SCREEN_WIDTH-30, mH);
    _lineVFrame = CGRectMake(0, CGRectGetMaxY(_commentsFrame)+14.5, SCREEN_WIDTH, 0.5);
    
    _rowHeight = CGRectGetMaxY(_commentsFrame)+15;
}


@end
