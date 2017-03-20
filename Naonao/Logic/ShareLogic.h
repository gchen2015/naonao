//
//  ShareLogic.h
//  Naonao
//
//  Created by 刘敏 on 16/4/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SquareModel.h"
#import "DynamicInfo.h"
#import "GoodsInfo.h"

//进入SKU的渠道
typedef NS_ENUM(NSInteger, ShareType){
    KShare_Brand         =  1,       //品牌
    KShare_Product       =  2,       //商品
    KShare_App           =  3        //分享App（优惠码）
};


@class SProData;

@interface ShareLogic : NSObject

//@property (nonatomic, strong) OrderDes *oInfo;          //回应
@property (nonatomic, strong) DynamicInfo *dInfo;       //同好
@property (nonatomic, strong) SProData *sData;          //商品详情


@property (nonatomic, assign) ShareType mType;

+ (instancetype)sharedInstance;

- (void)showActionView:(id)viewController;


@end



@interface SProData : NSObject

@property (nonatomic, strong) NSNumber *proId;          //商品ID
@property (nonatomic, strong) NSString *proDes;         //商品描述
@property (nonatomic, strong) NSString *proName;        //商品名称
@property (nonatomic, strong) NSString *proImage;       //商品图片

@end
