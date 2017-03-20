//
//  RobotCard.m
//  Naonao
//
//  Created by 刘敏 on 16/7/24.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "RobotCard.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation RobotCard

- (void)setCradInfo:(RecommandDAO *)rInfo
{
    self.userInteractionEnabled = YES;
    
    [_goodsV sd_setImageWithURL:[NSURL URLWithString:[rInfo.imgurl middleImage]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    //填充方式
    [_goodsV setContentMode:UIViewContentModeScaleAspectFill];
    _goodsV.layer.masksToBounds = YES;
    
    [_nameL setText:rInfo.wrapTitle];
    [_priceL setText:[NSString stringWithFormat:@"￥%@", rInfo.price]];
    
    [_sysL setTextColor:PINK_COLOR];
    
    [_contentL setTextColor:[UIColor colorWithHex:0x757372]];
    [_contentL setText:[NSString stringWithFormat:@"                  %@", rInfo.wrap_words]];
}

@end
