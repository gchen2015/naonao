//
//  FavArticleCell.h
//  Naonao
//
//  Created by 刘敏 on 16/8/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineInfo.h"

@interface FavArticleCell : UITableViewCell

+ (FavArticleCell *)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithCellInfo:(MagazineInfo *)mInfo;

@end
