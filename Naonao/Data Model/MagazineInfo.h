//
//  MagazineInfo.h
//  Naonao
//
//  Created by Richard Liu on 15/12/1.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "Mantle.h"

@interface MagazineInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *author;                  
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSNumber *isLike;                 //是否已经收藏
@property (nonatomic, strong) NSNumber *mId;
@property (nonatomic, strong) NSNumber *type;                   //版式类型（1、2）
@property (nonatomic, strong) NSString *publishTime;            //创建时间


@end



@interface MagazineContentInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSString *coverUrl;

@property (nonatomic, strong) NSNumber *type;                   //版式类型（1、2）
@property (nonatomic, strong) NSNumber *productPrice;

@property (nonatomic, strong) NSNumber *like;                   //0（不喜欢）， 1（喜欢）
@property (nonatomic, strong) NSString *productImg;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *productTitle;

@end



@interface STBanInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *mId;
@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *bgUrl;
@property (nonatomic, strong) NSString *title;

@end




@class ExtraInfo;
@interface STDuozhu : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* contract;          //是否舵主

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) ExtraInfo *extraInfo;

@property (nonatomic, strong) NSNumber *isFollow;           //是否关注
@property (nonatomic, strong) NSNumber *userid;             //用户ID
@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSNumber *fans;               //粉丝
@property (nonatomic, strong) NSNumber *follower;           //关注的人

@end

@interface ExtraInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *background;         //背景图片URL
@property (nonatomic, strong) NSString *introduce;          //自我介绍
@property (nonatomic, strong) NSString *job;                //职业
@property (nonatomic, strong) NSString *constellation;      //星座
@property (nonatomic, strong) NSArray *photos;              //照片URL

@end


@class STBrand_Content;
@interface STBrand : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *author;                  //封面图片
@property (nonatomic, strong) STBrand_Content *content;
@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSNumber *isLike;                 //是否已经收藏
@property (nonatomic, strong) NSNumber *mId;
@property (nonatomic, strong) NSNumber *type;                   //版式类型（1、2）
@property (nonatomic, strong) NSString *publishTime;            //创建时间

@end


@interface STBrand_Content : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *background;             //背景图片
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *story;
@property (nonatomic, strong) NSNumber *pickUp;                 //是否支持上门（YES为可以上门）

@property (nonatomic, strong) NSArray *proArray;
@property (nonatomic, strong) NSArray *brandArray;

@end


@interface STBrand_Product : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *mId;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imgUrl;
@end


@interface STBrand_C : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *imgUrl;

@end
