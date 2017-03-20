//
//  FilterCellModel.m
//  Artery
//
//  Created by 刘敏 on 14-10-23.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FilterCellModel.h"

@implementation FilterCellModel

+ (FilterCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"FilterCell";
    FilterCell *cell = (FilterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
