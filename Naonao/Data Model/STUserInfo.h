//
//  STUserInfo.h
//  Naonao
//
//  Created by 刘敏 on 16/4/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>

@class STBodyStyle;
@class STScores;
@class STCollect;

@interface STUserInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *portraitUrl;    //头像
@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) STScores *scoresInfo;
@property (nonatomic, strong) STCollect *collect;

@property (nonatomic, strong) NSNumber *isFollow;


@end


@interface STBodyStyle : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *bust;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSNumber *waistline;

@property (nonatomic, strong) NSNumber *hipline;
@property (nonatomic, strong) NSNumber *shoes;

@end



@interface STCollect : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *follower;       //粉丝
@property (nonatomic, strong) NSNumber *following;      //我关注的人
@property (nonatomic, strong) NSNumber *like;           //收藏夹个数

@end



@interface STScores : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *body;           //身材
@property (nonatomic, strong) NSNumber *style;          //风格
@property (nonatomic, strong) NSNumber *interest;       //兴趣
@property (nonatomic, strong) NSNumber *total;

@end
