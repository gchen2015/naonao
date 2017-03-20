//
//  SquareModel.h
//  Naonao
//
//  Created by 刘敏 on 16/5/31.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>

@class SUserInfo;
@class SOrderInfo;
@class SAnswerInfo;

@interface SquareModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) SAnswerInfo *answerInfo;
@property (nonatomic, strong) SUserInfo *userInfo;
@property (nonatomic, strong) SOrderInfo *orderInfo;

@end


@interface SAnswerInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *care;      //关心
@property (nonatomic, strong) NSNumber *num;       //答案
@property (nonatomic, strong) NSNumber *isCare;    //是否关心这个问题

@end


@interface SUserInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *isContract;         //是否是舵主
@property (nonatomic, strong) NSNumber *isRobot;            //是否是机器人

@property (nonatomic, strong) NSString *nickname;           //昵称
@property (nonatomic, strong) NSString *avatar;             //头像

@end


@interface SOrderInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *orderId;            //订单ID
@property (nonatomic, strong) NSNumber *createTime;         //创建时间
@property (nonatomic, strong) NSNumber *care;               //收藏

@property (nonatomic, strong) NSString *content;            //评论
@property (nonatomic, strong) NSString *orderImg;

@property (nonatomic, strong) NSNumber *categoryId;         //品类
@property (nonatomic, strong) NSNumber *styleId;            //风格ID
@property (nonatomic, strong) NSNumber *sceneId;            //场景ID

@property (nonatomic, strong) NSString *summarize;          //归集品类、风格、场景

@end


// 解析系统自动回复的数据
@interface RecommandDAO : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSString *wrapTitle;
@property (nonatomic, strong) NSString *imgurl;

@property (nonatomic, strong) NSString *brand;
@property (nonatomic, assign) NSUInteger sourceType;    //0是自营， 1是淘宝

@property (nonatomic, assign) BOOL favor;               //是否收藏
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *wrap_words;     //标签描述

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSString *website;

@end


@interface ProductData : NSObject

@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *wrapTitle;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *brand;

@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, strong) NSNumber *productId;
@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSString *wrap_words;     //标签描述

@property (nonatomic, assign) NSUInteger sourceType;    //0是自营， 1是淘宝

@property (nonatomic, assign) BOOL favor;               //是否收藏

@property (nonatomic, strong) SUserInfo *duozhu;        //舵主的信息


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end


//该mode用于推荐搭配和同款推荐
@interface SameModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *mId;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *originalPrice;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *sourceType;    //0是自营， 1是淘宝

@end


