//
//  MerchantAddressCell.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsOData.h"


@interface MerchantAddressCell : UITableViewCell

+ (MerchantAddressCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(StoreData *)store;

@end
