//
//  GoodsInfo.h
//  Naonao
//
//  Created by 刘敏 on 16/3/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "GoodsOData.h"

@class BrandInfo;
@class GoodsDetailInfo;
@class SizeUrlInfo;

// 商品信息
@interface GoodsInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *like;
@property (nonatomic, strong) NSArray* commentArray;        //评论
@property (nonatomic, strong) NSNumber* commentsNum;        //评论数量
@property (nonatomic, strong) NSString* goodsImg;           //商品图片（顶部）
@property (nonatomic, strong) NSNumber* originalPrice;      //原价
@property (nonatomic, strong) NSNumber* price;              //价格
@property (nonatomic, strong) NSString* sizeUrl;
@property (nonatomic, strong) BrandInfo* bInfo;             //商品信息
@property (nonatomic, strong) NSString* mTitle;
@property (nonatomic, strong) NSNumber* brandId;
@property (nonatomic, strong) NSString* detailInfo;

@property (nonatomic, strong) NSNumber *isDown;             //是否已下架（true已下架，false未下架）
@property (nonatomic, strong) NSNumber *canTry;             //是否可以试衣
@property (nonatomic, strong) NSNumber *sourceType;

@property (nonatomic, strong) NSArray *recommandArray;     //搭配

@property (nonatomic, strong) StoreData *store;

@end

// 品牌信息
@interface BrandInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* en_name;
@property (nonatomic, strong) NSString* story;
@property (nonatomic, strong) NSString* ch_name;
@property (nonatomic, strong) NSString* logoUrl;

@end

// 商品详情
@interface GoodsDetailInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSArray* imgArray;
@property (nonatomic, strong) NSString* desc;

@end

@interface SizeUrlInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSArray *sizeArray;

@end


// 图片信息
@interface ImageM : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSNumber* width;
@property (nonatomic, strong) NSNumber* height;

@end

// 评论信息
@interface CommentInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* content;        //评论内容
@property (nonatomic, strong) NSNumber* userId;         //评论者ID
@property (nonatomic, strong) NSString* createTime;
@property (nonatomic, strong) NSString* cName;          //评论者昵称
@property (nonatomic, strong) NSString* avatorUrl;      //评论者头像

@end


// 商品SKU
@interface ProductCategory : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* pName;
@property (nonatomic, strong) NSNumber* originalPrice;      //原价
@property (nonatomic, strong) NSNumber* price;              //价格
@property (nonatomic, strong) NSString* goodsImg;           //商品图片

@property (nonatomic, strong) NSNumber* productId;
@property (nonatomic, strong) NSString* logoUrl;

@end



//订单数据（后台返回）
@interface OrderData : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* order_no;           //订单编号
@property (nonatomic, strong) NSNumber* order_id;           //订单ID

@end



