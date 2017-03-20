//
//  DesModeFrame.m
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "DesModeFrame.h"
#import "SHLUILabel.h"

#define K_ImageW     SCREEN_WIDTH-28

@implementation DesModeFrame


- (void)setDesInfo:(GoodsDetailInfo *)desInfo
{
    _desInfo = desInfo;
    [self setUpAllFrame];
}

- (void)setSizeInfo:(SizeUrlInfo *)sizeInfo
{
    _sizeInfo = sizeInfo;
}

- (void)setUpAllFrame{
    
    _leftFrame = CGRectMake(SCREEN_WIDTH/4-32, 20, 64, 64);
    _rightFrame = CGRectMake(SCREEN_WIDTH*3/4-32, 20, 64, 64);
    
    // 文字描述
    SHLUILabel *contentLab = [[SHLUILabel alloc] init];
    contentLab.text = _desInfo.desc;
    [contentLab setTextColor:[UIColor grayColor]];
    [contentLab setFont:[UIFont systemFontOfSize:14.0]];
    contentLab.lineBreakMode = NSLineBreakByWordWrapping;
    contentLab.numberOfLines = 0;
    
    //根据字符串长度和Label显示的宽度计算出contentLab的高
    int labelHeight = [contentLab getAttributedStringHeightWidthValue:SCREEN_WIDTH-28];
    _desFrame = CGRectMake(14, 110, SCREEN_WIDTH-28, labelHeight);
    
//    if (_sizeInfo.sizeArray.count > 0) {
//        ImageM *mode = _sizeInfo.sizeArray[0];
//        
//        _desFrame = CGRectMake(14, 110, SCREEN_WIDTH-28, labelHeight);
//    }
//    else{
//        _desFrame = CGRectMake(14, 110, SCREEN_WIDTH-28, labelHeight);
//    }
    

    CGFloat mH = 0.0;
    for (ImageM *item in _desInfo.imgArray) {
        mH +=[self calculateImageHigh:item];
    }

    _imageFrame = CGRectMake(0, CGRectGetMaxY(_desFrame)+20, SCREEN_WIDTH, mH);
    
    _rowHeight = CGRectGetMaxY(_imageFrame)+20;
    
    _modeFrame = CGRectMake(0, 0, SCREEN_WIDTH, _rowHeight);
}

- (CGFloat)calculateImageHigh:(ImageM *)item
{
    //科学计数法，精确度高
    NSDecimalNumber *m_width = [NSDecimalNumber decimalNumberWithString:[item.width stringValue]];
    NSDecimalNumber *m_height = [NSDecimalNumber decimalNumberWithString:[item.height stringValue]];
    
    //系数（除法）
    NSDecimalNumber *cof = [m_width decimalNumberByDividingBy:m_height];
    
    NSDecimalNumber *mw = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.0f", K_ImageW]];
    
    NSDecimalNumber *mH = [mw decimalNumberByDividingBy:cof];
    
    
    return mH.floatValue+5.0;
}


@end
