//
//  AnswerMode.h
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "TagsMode.h"

@class GoodsMode;
@class AnUserInfo;
@class STCommentInfo;

@interface AnswerMode : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) GoodsMode *proData;
@property (nonatomic, strong) AnUserInfo *userInfo;
@property (nonatomic, strong) NSArray *links;
@property (nonatomic, strong) STCommentInfo *comments;

@property (nonatomic, strong) NSNumber *answerId;
@property (nonatomic, strong) NSNumber *isLike;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *match_score;

@end


@interface AnUserInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *isContract;         //是否是舵主
@property (nonatomic, strong) NSNumber *isFollow;
@property (nonatomic, strong) NSString *nickname;           //昵称
@property (nonatomic, strong) NSString *avatar;             //头像

@end


@interface STCommentInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSArray *commentList;

@end



@interface STCommentData : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* content;        //评论内容

@property (nonatomic, strong) NSNumber* userId;         //评论者ID
@property (nonatomic, strong) NSString* nickName;       //评论者昵称
@property (nonatomic, strong) NSString* avatorUrl;      //评论者头像

@property (nonatomic, strong) NSNumber* at_userId;      //被评论者ID
@property (nonatomic, strong) NSString* at_nickName;    //被评论者昵称
@property (nonatomic, strong) NSString* at_avatorUrl;   //被评论者头像

@property (nonatomic, strong) NSNumber* commentId;      //评论ID

@property (nonatomic, strong) NSString* createTime;

@end