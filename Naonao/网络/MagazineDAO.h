//
//  MagazineDAO.h
//  Naonao
//
//  Created by Richard Liu on 15/11/24.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^MagazineSuccessBlock)(NSDictionary *result);
typedef void (^MagazineFailedBlock)(ResponseHeader *result);

@interface MagazineDAO : NSObject

/**
 *  用户喜欢的商品列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestUserLikeProducts:(NSDictionary *)dict
                   successBlock:(MagazineSuccessBlock)successBlock
                 setFailedBlock:(MagazineFailedBlock)failedBlock;

/**
 *  用户喜欢商品
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestUserFavorProduct:(NSDictionary *)dict
                   successBlock:(MagazineSuccessBlock)successBlock
                 setFailedBlock:(MagazineFailedBlock)failedBlock;



/**
 *  用户不喜欢商品
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestUserUnFavorProduct:(NSDictionary *)dict
                     successBlock:(MagazineSuccessBlock)successBlock
                   setFailedBlock:(MagazineFailedBlock)failedBlock;


/**
 *  获取播报页面banner
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestBannerList:(NSDictionary *)dict
             successBlock:(MagazineSuccessBlock)successBlock
           setFailedBlock:(MagazineFailedBlock)failedBlock;

/**
 *  查看杂志列表/杂志内容
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestMagazineList:(NSDictionary *)dict
               successBlock:(MagazineSuccessBlock)successBlock
             setFailedBlock:(MagazineFailedBlock)failedBlock;



/**
 *  获取品牌列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestBrandsList:(NSDictionary *)dict
             successBlock:(MagazineSuccessBlock)successBlock
           setFailedBlock:(MagazineFailedBlock)failedBlock;



/**
 *  查看杂志详情
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestMagazineContent:(NSDictionary *)dict
                  successBlock:(MagazineSuccessBlock)successBlock
                setFailedBlock:(MagazineFailedBlock)failedBlock;

/**
 *  获取推荐舵主列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestRecommandUsers:(NSDictionary *)dict
                 successBlock:(MagazineSuccessBlock)successBlock
               setFailedBlock:(MagazineFailedBlock)failedBlock;



/**
 *  用户喜欢商品
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestLikeArticle:(NSDictionary *)dict
              successBlock:(MagazineSuccessBlock)successBlock
            setFailedBlock:(MagazineFailedBlock)failedBlock;


/**
 *  用户不喜欢商品
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestDislikeArticle:(NSDictionary *)dict
                 successBlock:(MagazineSuccessBlock)successBlock
               setFailedBlock:(MagazineFailedBlock)failedBlock;


/**
 *  获取收藏的文章列表
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestLikeArticleList:(NSDictionary *)dict
                  successBlock:(MagazineSuccessBlock)successBlock
                setFailedBlock:(MagazineFailedBlock)failedBlock;
@end
