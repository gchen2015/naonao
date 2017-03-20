//
//  EditAddressCell.h
//  Naonao
//
//  Created by 刘敏 on 16/4/12.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressInfo.h"

@class EditAddressCell;
@protocol EditAddressCellDelegate <NSObject>

//设置默认地址
- (void)editAddressCell:(EditAddressCell *)cell setDefaultCellInfo:(AddressInfo *)mInfo;

//编辑
- (void)editAddressCell:(EditAddressCell *)cell edictCellInfo:(AddressInfo *)mInfo;

//删除
- (void)editAddressCell:(EditAddressCell *)cell deleteCellInfo:(AddressInfo *)mInfo;

@end




@interface EditAddressCell : UITableViewCell

@property (nonatomic, weak) id<EditAddressCellDelegate> delegate;

+ (EditAddressCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(AddressInfo *)mInfo;

@end


