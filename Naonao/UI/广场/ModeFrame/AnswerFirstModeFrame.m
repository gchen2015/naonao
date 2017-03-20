//
//  AnswerFirstModeFrame.m
//  Naonao
//
//  Created by 刘敏 on 16/7/24.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnswerFirstModeFrame.h"
#import "SHLUILabel.h"

@implementation AnswerFirstModeFrame

- (void)setSModel:(SquareModel *)sModel
{
    _sModel = sModel;
    [self setUpAllFrame];
}

- (void)setUpAllFrame{
    SHLUILabel *contentL = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    [contentL setFont:[UIFont systemFontOfSize:16.0]];
    contentL.lineBreakMode = NSLineBreakByWordWrapping;
    contentL.numberOfLines = 0;
    [contentL setText:_sModel.orderInfo.content];
    CGFloat mH = [contentL getAttributedStringHeightWidthValue:SCREEN_WIDTH - 28];
    
    _contentFrame = CGRectMake(14, 12, SCREEN_WIDTH-28, mH);
    _desFrame = CGRectMake(14, CGRectGetMaxY(_contentFrame)+14, 200, 18);
    _timeFrame = CGRectMake(SCREEN_WIDTH -114, CGRectGetMaxY(_contentFrame)+12, 100, 18);
    _lineFrame = CGRectMake(0, CGRectGetMaxY(_desFrame)+12, SCREEN_WIDTH, 0.5);
    
    _answerFrame = CGRectMake(SCREEN_WIDTH - 114, CGRectGetMaxY(_lineFrame)+14, 100, 30);
    _careFrame = CGRectMake(14, CGRectGetMaxY(_lineFrame)+14, 100, 30);
    
    _rowHeight = CGRectGetMaxY(_careFrame)+14;
}

@end
