//
//  LogisticsHeaderCell.m
//  Naonao
//
//  Created by 刘敏 on 2016/10/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "LogisticsHeaderCell.h"
#import "UICopyLabel.h"

@interface LogisticsHeaderCell ()

@property (nonatomic, weak) UILabel *tittleLabel;
@property (nonatomic, weak) UILabel *logisticsCom;          //快递公司
@property (nonatomic, weak) UICopyLabel *logisticsCode;     //订单编号

@end

@implementation LogisticsHeaderCell

+ (LogisticsHeaderCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"LogisticsHeaderCell";
    
    LogisticsHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LogisticsHeaderCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.userInteractionEnabled = YES;  //用户交互的总开关
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView
{
    UILabel *lA = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
    [lA setText:@"物流状态"];
    [lA setTextColor:BLACK_COLOR];
    [lA setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentView addSubview:lA];
    
    UILabel *tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 10, 200, 20)];
    _tittleLabel = tittleLabel;
    [_tittleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_tittleLabel setTextColor:PINK_COLOR];
    [self.contentView addSubview:_tittleLabel];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 100, 15)];
    [lb setText:@"承运来源："];
    [lb setTextColor:LIGHT_GARY_COLOR];
    [lb setFont:[UIFont systemFontOfSize:12.0]];
    [self.contentView addSubview:lb];
    
    
    UILabel *logisticsCom = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 100, 15)];
    _logisticsCom = logisticsCom;
    [_logisticsCom setFont:[UIFont systemFontOfSize:12.0]];
    [_logisticsCom setTextColor:LIGHT_GARY_COLOR];
    [self.contentView addSubview:_logisticsCom];
    
    UILabel *lc = [[UILabel alloc] initWithFrame:CGRectMake(15, 56, 100, 15)];
    [lc setText:@"运单编号："];
    [lc setTextColor:LIGHT_GARY_COLOR];
    [lc setFont:[UIFont systemFontOfSize:12.0]];
    [self.contentView addSubview:lc];
    

    UICopyLabel *logisticsCode = [[UICopyLabel alloc] initWithFrame:CGRectMake(80, 46, 100, 35)];
    _logisticsCode = logisticsCode;
    [_logisticsCode setFont:[UIFont systemFontOfSize:12.0]];
    [_logisticsCode setTextColor:LIGHT_GARY_COLOR];
    [self.contentView addSubview:_logisticsCode];

}

- (void)setCellWithCellInfo:(CourierInfo *)cInfo{
    [_logisticsCom setText:@"暂无"];
    [_logisticsCode setText:@"暂无"];
    
    //已经发货
    if (cInfo.logis.logisticCode) {
        //物流状态: 2-在途中，3-签收,4-问题件
        if ([cInfo.logis.state integerValue] == 2 ) {
            [_tittleLabel setText:@"运输中"];
        }
        else if ([cInfo.logis.state integerValue] == 3 ) {
            [_tittleLabel setText:@"已签收"];
        }
        else if ([cInfo.logis.state integerValue] == 4 ) {
            [_tittleLabel setText:@"问题件"];
        }
        
        [_logisticsCom setText:cInfo.expressType];
        [_logisticsCode setText:cInfo.expressNo];
    }
    else{
        if ([cInfo.deliveryStatus integerValue] == 0) {
            [_tittleLabel setText:@"等待开始配送流程"];
        }
        else if ([cInfo.deliveryStatus integerValue] == 1) {
            [_tittleLabel setText:@"备货中"];
        }
        else if ([cInfo.deliveryStatus integerValue] == 2) {
            [_tittleLabel setText:@"运输中"];
        }
        else if ([cInfo.deliveryStatus integerValue] == 3) {
            [_tittleLabel setText:@"已签收"];
        }
        else if ([cInfo.deliveryStatus integerValue] == 99) {
            [_tittleLabel setText:@"问题件"];
        }
    }

    

}

@end
