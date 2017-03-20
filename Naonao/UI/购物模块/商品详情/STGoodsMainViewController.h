//
//  STGoodsMainViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STPopViewController.h"
#import "STGoodsDetailsViewController.h"

@interface STGoodsMainViewController : STPopViewController

@property (nonatomic, strong) MagazineContentInfo *mInfo;
@property (nonatomic, strong) NSNumber *re_userId;         //推荐者UserID,用于返现

@end
