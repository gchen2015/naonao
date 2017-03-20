//
//  CircleCollectionCell.h
//  MeeBra
//
//  Created by Richard Liu on 15/9/17.
//  Copyright © 2015年 广州杉川投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavGoodsModel.h"
#import "MagazineInfo.h"

@interface CircleCollectionCell : UICollectionViewCell

- (void)initWithParsData:(FavGoodsModel *)cInfo;

- (void)initWithCellBrandsInfo:(STBrand_Product *)cInfo;

@end
