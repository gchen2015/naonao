//
//  DynamicInfo.m
//  Naonao
//
//  Created by 刘敏 on 16/4/22.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "DynamicInfo.h"
#import "AnswerMode.h"

@implementation DynamicInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.pInfo = [MTLJSONAdapter modelOfClass:[ProductInfo class] fromJSONDictionary:[dict objectForKeyNotNull:@"show_info"] error:nil];
    self.userInfo = [MTLJSONAdapter modelOfClass:[UserInfo class] fromJSONDictionary:[dict objectForKeyNotNull:@"user_info"] error:nil];
    
    NSDictionary *dic = [dict objectForKeyNotNull:@"comment_info"];
    if (dic.count > 0) {
        self.comInfo = [MTLJSONAdapter modelOfClass:[STCommentInfo class] fromJSONDictionary:[dict objectForKeyNotNull:@"comment_info"] error:nil];
    }
    
    
    
    return self;
}

@end




@implementation UserInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId": @"userid",
             @"userName": @"name",
             @"portraitUrl": @"url",
             @"isFollow": @"is_follower"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

//转换UserName
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"userName"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            NSString *userName = [Units decodeFromPercentEscapeString:value];
            
            return userName;
        }];
        
    }
    
    return nil;
}

@end



@implementation ProductInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"proId": @"product_id",
             @"showId": @"show_id",
             @"proImg": @"img",
             @"title": @"title",
             @"price": @"price",
             @"isLike": @"is_like",
             @"likeCount": @"like_cnt",
             @"desc": @"desc",
             @"time": @"create_time"
             };
}

- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
}

@end


//@implementation STCommentInfo
//
//- (instancetype)initWithParsData:(NSDictionary *)dict
//{
//    if(!dict)
//    {
//        return nil;
//    }
//        
//    
//    self.total = [dict objectForKeyNotNull:@"total"];
//    self.commentList = [MTLJSONAdapter modelsOfClass:[STCommentData class] fromJSONArray:[dict objectForKeyNotNull:@"list"] error:nil];
//
//    
//    return self;
//}
//
//@end
//
//
//@implementation STCommentData
//
//+ (NSDictionary *)JSONKeyPathsByPropertyKey {
//    return @{
//             @"commentId": @"id",
//             @"content": @"content",
//             @"userId": @"userid",
//             @"nickName": @"nickname",
//             @"avatorUrl": @"avatar",
//             @"at_userId": @"at_userid",
//             @"at_nickName": @"at_nickname",
//             @"createTime": @"create_time"
//             };
//}
//
//- (instancetype)decodeValueForKey:(NSString *)key withCoder:(NSCoder *)coder modelVersion:(NSUInteger)modelVersion {
//    return [super decodeValueForKey:key withCoder:coder modelVersion:modelVersion];
//}
//
//
//@end