//
//  SquareModel.m
//  Naonao
//
//  Created by 刘敏 on 16/5/31.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SquareModel.h"
#import "ProductModeFrame.h"
#import "TimeUtil.h"

@implementation SquareModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"answerInfo" : @"answers",
             @"userInfo" : @"userinfo",
             @"orderInfo" : @"orderinfo"
             };
}

+ (NSValueTransformer *)answerInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SAnswerInfo class]];
}

+ (NSValueTransformer *)userInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SUserInfo class]];
}

+ (NSValueTransformer *)orderInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SOrderInfo class]];
}

@end




@implementation  SAnswerInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"care" : @"care",
             @"num" : @"num",
             @"isCare" : @"is_care"
             };
}

@end


@implementation SUserInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId" : @"userid",
             @"isContract" : @"is_contract",
             @"nickname" : @"nickname",
             @"isRobot" : @"is_robot",
             @"avatar" : @"avatar"
             };
}

//转换content
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"nickname"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
        
    }
    
    return nil;
}

@end


@implementation SOrderInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"content" : @"content",
             @"orderId" : @"order_id",
             @"care" : @"care",
             @"createTime" : @"create_time",
             @"orderImg" : @"order_img",
             @"categoryId" : @"category",
             @"styleId" : @"style",
             @"sceneId" : @"scene"
             };
}


//转换content
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"content"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
        
    }
    
    return nil;
}

@end


// 解析系统自动回复的数据
@implementation RecommandDAO

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"productId" : @"productId",
             @"wrapTitle" : @"wrapTitle",
             @"imgurl" : @"imgUrl",
             @"brand" : @"brand",
             @"sourceType" : @"source_type",
             @"favor" : @"favor",
             @"desc" : @"desc",
             @"wrap_words" : @"wrap_words",
             @"price" : @"price",
             @"shopId" : @"shopId",
             @"userId" : @"userId",
             @"website" : @"website"
             };
}

@end



@implementation  ProductData

- (instancetype)initWithParsData:(NSDictionary *)dict {
    
    self.tag = [dict objectForKeyNotNull:@"tag"];
    self.desc = [dict objectForKeyNotNull:@"desc"];
    self.wrapTitle = [dict objectForKeyNotNull:@"wrapTitle"];
    self.website = [dict objectForKeyNotNull:@"website"];
    self.imgurl = [dict objectForKeyNotNull:@"imgUrl"] ;
    self.brand = [dict objectForKeyNotNull:@"brand"];
    
    self.shopId = [dict objectForKeyNotNull:@"shopId"];
    self.productId = [dict objectForKeyNotNull:@"productId"];
    self.price = [dict objectForKeyNotNull:@"price"];
    self.sourceType = [[dict objectForKeyNotNull:@"source_type"] integerValue];
    
    
    self.favor = [[dict objectForKeyNotNull:@"favor"] boolValue];
    
    if ([dict objectForKeyNotNull:@"wrap_words"]) {
        self.wrap_words = [dict objectForKeyNotNull:@"wrap_words"];
    }
    else if([dict objectForKeyNotNull:@"flag_desc"])
    {
        NSMutableArray *temA = [[NSMutableArray alloc] init];
        
        if ([[dict objectForKeyNotNull:@"flag_desc"] isKindOfClass:[NSArray class]]) {
            [temA addObjectsFromArray:[dict objectForKeyNotNull:@"flag_desc"]];
        }
        else if([[dict objectForKeyNotNull:@"flag_desc"] isKindOfClass:[NSString class]]){
            [temA addObject:[dict objectForKeyNotNull:@"flag_desc"]];
        }
        
        if ([[dict objectForKeyNotNull:@"scene_desc"] isKindOfClass:[NSArray class]]) {
            [temA addObjectsFromArray:[dict objectForKeyNotNull:@"scene_desc"]];
        }
        else if([[dict objectForKeyNotNull:@"scene_desc"] isKindOfClass:[NSString class]]){
            [temA addObject:[dict objectForKeyNotNull:@"scene_desc"]];
        }
        
        self.wrap_words = [temA componentsJoinedByString:@""];
    }
    
    if ([dict objectForKeyNotNull:@"scene_desc"]) {
        
    }
    
    

    NSDictionary *dic = [dict objectForKeyNotNull:@"duozhu"];
    if(dic)
    {
        self.duozhu = [MTLJSONAdapter modelOfClass:[SUserInfo class] fromJSONDictionary:dic error:nil];
    }

    
    return self;
}


@end




@implementation  SameModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId" : @"id",
             @"imgurl" : @"img",
             @"price" : @"price",
             @"originalPrice" : @"original_price",
             @"title" : @"title",
             @"sourceType" : @"source_type"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}


@end