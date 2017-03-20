//
//  FavGoodsModel.h
//  Naonao
//
//  Created by Richard Liu on 15/12/29.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MTLModel.h"

@interface FavGoodsModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* productId;        //商品ID
@property (nonatomic, strong) NSString* imgUrl;
@property (nonatomic, strong) NSString* productName;
@property (nonatomic, strong) NSNumber* productPrice;


@end


@interface FavTopicModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;

@property (nonatomic, copy) NSString* magazineCover;
@property (nonatomic, copy) NSString* title;


@end



@interface questionModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* answerA;        //答案
@property (nonatomic, strong) NSString* answerB;
@property (nonatomic, strong) NSString* answerC;
@property (nonatomic, strong) NSString* answerD;
@property (nonatomic, strong) NSString* question;       //问题

@end