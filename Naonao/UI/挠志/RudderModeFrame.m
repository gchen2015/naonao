//
//  RudderModeFrame.m
//  Naonao
//
//  Created by 刘敏 on 16/8/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "RudderModeFrame.h"
#import "SHLUILabel.h"


@implementation RudderModeFrame

- (void)setSModel:(STDuozhu *)sModel
{
    _sModel = sModel;
    [self setUpAllFrame];
}

- (void)setUpAllFrame{
    
    _linvAFrame = CGRectMake(0, 0, SCREEN_WIDTH, 0.2);
    _bigImageViewFrame = CGRectMake(15, 15, SCREEN_WIDTH-30, SCREEN_WIDTH-30);
    
    
    SHLUILabel *desL = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    desL.numberOfLines = 0;
    [desL setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightLight]];
    [desL setText:_sModel.extraInfo.introduce];
    CGFloat mH = [desL getAttributedStringHeightWidthValue:SCREEN_WIDTH - 20];
    _desFrame = CGRectMake(15, CGRectGetMaxY(_bigImageViewFrame)+28, SCREEN_WIDTH-30, mH);
    
    
    _headFrame = CGRectMake(15, CGRectGetMaxY(_desFrame)+20, 40, 40);
    _timeFrame = CGRectMake(CGRectGetMaxX(_headFrame)+10, CGRectGetMaxY(_desFrame)+20, 100, 15);
    
    //计算size
    CGSize nickSize = [_sModel.nickname boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 67, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                        context:nil].size;
    _nickFrame = CGRectMake(CGRectGetMaxX(_headFrame)+10, CGRectGetMaxY(_desFrame)+40, nickSize.width, 15);
    
    //舵主标识
    _tipFrame = CGRectMake(CGRectGetMaxX(_nickFrame)+3, CGRectGetMaxY(_desFrame)+40, 15, 15);
 
    
    _followFrame = CGRectMake(SCREEN_WIDTH - 81, CGRectGetMaxY(_desFrame)+25, 66, 30);
    _linvBFrame = CGRectMake(0, CGRectGetMaxY(_headFrame)+16, SCREEN_WIDTH, 0.2);
    _intervalFrame = CGRectMake(0, CGRectGetMaxY(_linvBFrame), SCREEN_WIDTH, 10);
    
    _rowHeight = CGRectGetMaxY(_intervalFrame);
}


@end
