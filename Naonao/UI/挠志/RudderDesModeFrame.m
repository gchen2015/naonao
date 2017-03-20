//
//  RudderDesModeFrame.m
//  Naonao
//
//  Created by 刘敏 on 16/8/5.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "RudderDesModeFrame.h"
#import "SHLUILabel.h"


@implementation RudderDesModeFrame

- (void)setSData:(STDuozhu *)sModel
{
    _sData = sModel;
    [self setUpAllFrame];
}

- (void)setUpAllFrame{
    _relationshipFrame = CGRectMake(15, 20, SCREEN_WIDTH - 30, 14);
    _focusFrame = CGRectMake((SCREEN_WIDTH - 66)/2, CGRectGetMaxY(_relationshipFrame)+8, 66, 30);
    
    _nickFrame = CGRectMake(15, CGRectGetMaxY(_focusFrame)+20, SCREEN_WIDTH - 30, 20);
    _roleFrame = CGRectMake(15, CGRectGetMaxY(_nickFrame)+5, SCREEN_WIDTH - 30, 15);
    
    SHLUILabel *desL = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    desL.numberOfLines = 0;
    [desL setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightLight]];
    [desL setText:_sData.extraInfo.introduce];
    CGFloat mH = [desL getAttributedStringHeightWidthValue:SCREEN_WIDTH - 20];
    _desFrame = CGRectMake(15, CGRectGetMaxY(_roleFrame)+12, SCREEN_WIDTH-30, mH);
    
    
    _scrollViewFrame = CGRectMake(0, CGRectGetMaxY(_desFrame)+20, SCREEN_WIDTH, 130);

    _rowHeight = CGRectGetMaxY(_scrollViewFrame)+15;
}


@end
