//
//  DynamicInfo.h
//  Naonao
//
//  Created by 刘敏 on 16/4/22.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@class ProductInfo;
@class STCommentInfo;
@class UserInfo;

@interface DynamicInfo: NSObject

@property (nonatomic, strong) ProductInfo *pInfo;        //商品
@property (nonatomic, strong) STCommentInfo *comInfo;    //评论
@property (nonatomic, strong) UserInfo *userInfo;        //用户信息

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end


@interface  UserInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *portraitUrl;
@property (nonatomic, strong) NSNumber *isFollow;

@end



@interface ProductInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *proId;      //商品ID
@property (nonatomic, strong) NSString *proImg;     //商品图片
@property (nonatomic, strong) NSString *title;      //商品名称
@property (nonatomic, strong) NSNumber *price;      //价格
@property (nonatomic, strong) NSNumber *showId;     //同好ID
@property (nonatomic, strong) NSNumber *isLike;
@property (nonatomic, strong) NSNumber *likeCount;  //喜欢的个数
@property (nonatomic, strong) NSString *desc;       //商品描述
@property (nonatomic, strong) NSString *time;

@end

//
//@interface STCommentInfo : NSObject
//
//@property (nonatomic, strong) NSNumber *total;
//@property (nonatomic, strong) NSArray *commentList;
//
//- (instancetype)initWithParsData:(NSDictionary *)dict;
//
//@end
//
//
//@interface STCommentData : MTLModel<MTLJSONSerializing>
//
//@property (nonatomic, strong) NSNumber* commentId;      //评论ID
//
//@property (nonatomic, strong) NSString* content;        //评论内容
//
//@property (nonatomic, strong) NSNumber* userId;         //评论者ID
//@property (nonatomic, strong) NSString* nickName;       //评论者昵称
//@property (nonatomic, strong) NSString* avatorUrl;      //评论者头像
//
//@property (nonatomic, strong) NSNumber* at_userId;      //被评论者ID
//@property (nonatomic, strong) NSString* at_nickName;    //被评论者昵称
//
//@property (nonatomic, strong) NSString* createTime;
//
//@end