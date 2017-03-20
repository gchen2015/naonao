//
//  RudderTTCell.m
//  Naonao
//
//  Created by 刘敏 on 16/8/5.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "RudderTTCell.h"

@implementation RudderTTCell

+ (RudderTTCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"RudderTTCell";
    
    RudderTTCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[RudderTTCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.userInteractionEnabled = YES;
        
        UILabel *titL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 44)];
        [titL setText:@"收藏的商品"];
        [titL setTextColor:BLACK_COLOR];
        [titL setTextAlignment:NSTextAlignmentCenter];
        [titL setFont:[UIFont systemFontOfSize:15.0]];
        [self.contentView addSubview:titL];
        
        UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        [lineV setBackgroundColor:STROKE_GARY_COLOR];
        [self.contentView addSubview:lineV];
    }
    
    return self;
}

@end
