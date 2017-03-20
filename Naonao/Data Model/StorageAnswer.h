//
//  StorageAnswer.h
//  Naonao
//
//  Created by 刘敏 on 16/7/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagsMode.h"
#import <Mantle/Mantle.h>


@interface StorageAnswer : NSObject

@property (nonatomic, copy) NSNumber *orderId;         //题主的问题ID
@property (nonatomic, copy) NSNumber *productId;       //推荐的商品ID
@property (nonatomic, copy) NSString *content;         //文字描述

@property (nonatomic, copy) NSArray *links;            //图片链接

@property (nonatomic, copy) NSArray *imageArray;       //要发布的图片

@property (nonatomic, copy) GoodsMode *gMode;

@end


@interface UserAnswer : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSNumber *orderId;
@property (nonatomic, copy) NSNumber *mId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *orderT;

@end

@class MY_Answer;
@class MY_Comment;
@class MY_Order;

@interface MY_C : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) MY_Answer *answer;
@property (nonatomic, copy) MY_Comment *comment;
@property (nonatomic, copy) MY_Order *order;

@end


@interface MY_Answer : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSNumber *mId;
@property (nonatomic, copy) NSNumber *userid;
@property (nonatomic, copy) NSString *avatar;

@end


@interface MY_Comment : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSNumber *mId;

@end

@interface MY_Order : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSNumber *mId;

@end
