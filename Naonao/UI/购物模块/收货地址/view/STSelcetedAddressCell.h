//
//  STSelcetedAddressCell.h
//  Naonao
//
//  Created by 刘敏 on 16/4/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfo.h"


@interface STSelcetedAddressCell : UITableViewCell

@property (nonatomic, weak) UIButton *selctBtn;
@property (nonatomic, assign) NSInteger clickCount;

+ (STSelcetedAddressCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(AddressInfo *)mInfo compareAddressInfo:(AddressInfo *)selectModel;

@end
