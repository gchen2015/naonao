//
//  ProductModeFrame.m
//  Naonao
//
//  Created by Richard Liu on 16/2/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ProductModeFrame.h"
#import "SHLUILabel.h"


@implementation ProductModeFrame

- (void)setPData:(ProductData *)pData
{
    _pData = pData;
    [self setUpAllFrame];
}

- (void)setUpAllFrame{
    
    //顶部
    [self setUpHeadFrame];
    
    //文字说明
    [self setUpCenterFrame];
    
    //推荐的商品
    [self setUpToolsFrame];
    
}


- (void)setUpHeadFrame
{
    _headFrame = CGRectMake(14, 14, 30, 30);
    //计算文字
    CGSize textSize = [_pData.duozhu.nickname boundingRectWithSize:CGSizeMake(200, 100)
                                                            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0],}
                                                            context:nil].size;
    
    _nikeFrame = CGRectMake(CGRectGetMaxX(_headFrame)+8, 14, textSize.width, 30);
    //是舵主
    if ([_pData.duozhu.isContract boolValue]) {
        _tipFrame = CGRectMake(CGRectGetMaxX(_nikeFrame)+2, 20, 18, 18);
    }
    _aboveFrame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_headFrame)+10);
}

- (void)setUpCenterFrame
{

    SHLUILabel *mL = [[SHLUILabel alloc] init];
    [mL setFont:[UIFont systemFontOfSize:14.0]];
    mL.lineBreakMode = NSLineBreakByWordWrapping;
    mL.numberOfLines = 0;
    mL.text = _pData.wrap_words;
    
    
    CGFloat mH = [mL getAttributedStringHeightWidthValue:SCREEN_WIDTH - 28];
    //文字
    _flagLFrame = CGRectMake(14, 0, SCREEN_WIDTH - 28, mH);

    _centerFrame = CGRectMake(0, CGRectGetMaxY(_aboveFrame), SCREEN_WIDTH, CGRectGetMaxY(_flagLFrame)+15);
}


- (void)setUpToolsFrame
{
    _garyFrame = CGRectMake(14, 0, SCREEN_WIDTH-28, 70);
    _goodsFrame = CGRectMake(15, 1, 68, 68);

    CGFloat mW = CGRectGetWidth(_garyFrame) - CGRectGetMaxX(_goodsFrame) - 8;
    
    _goodsNFrame = CGRectMake(CGRectGetMaxX(_goodsFrame) + 10, 4, mW , 20);
    _brandFrame  = CGRectMake(CGRectGetMaxX(_goodsFrame) + 10, 24, mW, 20);
    _priceFrame = CGRectMake(CGRectGetMaxX(_goodsFrame) + 8, 45, mW, 20);
    
    _bottomFrame = CGRectMake(0, CGRectGetMaxY(_centerFrame), SCREEN_WIDTH, CGRectGetMaxY(_garyFrame)+20);
    _rowHeight = CGRectGetMaxY(_bottomFrame);
}


@end
