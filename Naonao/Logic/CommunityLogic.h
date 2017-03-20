//
//  CommunityLogic.h
//  Naonao
//
//  Created by 刘敏 on 16/4/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogicResult.h"


typedef void (^CommunityLogicCommonCallback)(LogicResult* result);

@interface CommunityLogic : NSObject

@property (nonatomic, strong) NSNumber *proID;   //商品ID

+ (instancetype)sharedInstance;

//获取推荐用户列表
- (void)getRecommandList:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results;

//关注好友
- (void)getAttentionUserInfo:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results;

//取消关注好友
- (void)getUnAttentionUserInfo:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results;

//获取评论列表
- (void)getCommentsList:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results;

//发表评论
- (void)sendComments:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results;

//获取个人中心
- (void)getUserInfo:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results;

//点赞
- (void)getShowPraise:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results;

//取消点赞
- (void)getShowUnPraise:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results;

//上传图片到七牛云
- (void)uploadPicturesToQiniu:(NSData *)imageData withCallback:(UserLogicCommonCallback)results;

//发布买家秀
- (void)sendBuyersShow:(NSDictionary *)dict withCallback:(CommunityLogicCommonCallback)results;


@end
