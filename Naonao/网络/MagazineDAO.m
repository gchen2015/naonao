//
//  MagazineDAO.m
//  Naonao
//
//  Created by Richard Liu on 15/11/24.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MagazineDAO.h"
#import "RequestModel.h"

@implementation MagazineDAO


// 用户喜欢的商品列表
- (void)requestUserLikeProducts:(NSDictionary *)dict
                   successBlock:(MagazineSuccessBlock)successBlock
                 setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_LikeProducts
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



// 用户喜欢商品
- (void)requestUserFavorProduct:(NSDictionary *)dict
                   successBlock:(MagazineSuccessBlock)successBlock
                 setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserFavorProduct
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 用户不喜欢商品
- (void)requestUserUnFavorProduct:(NSDictionary *)dict
                     successBlock:(MagazineSuccessBlock)successBlock
                   setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_UserUnFavorProduct
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 获取播报页面banner
- (void)requestBannerList:(NSDictionary *)dict
             successBlock:(MagazineSuccessBlock)successBlock
           setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetBannerList
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 查看杂志列表
- (void)requestMagazineList:(NSDictionary *)dict
               successBlock:(MagazineSuccessBlock)successBlock
             setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetMagazineList
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

//获取品牌列表
- (void)requestBrandsList:(NSDictionary *)dict
             successBlock:(MagazineSuccessBlock)successBlock
           setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetListBrands
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 查看品牌详情
- (void)requestMagazineContent:(NSDictionary *)dict
                  successBlock:(MagazineSuccessBlock)successBlock
                setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetMagazineContent
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 获取推荐舵主列表
- (void)requestRecommandUsers:(NSDictionary *)dict
                 successBlock:(MagazineSuccessBlock)successBlock
               setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_GetRecommandUsers
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 用户喜欢商品
- (void)requestLikeArticle:(NSDictionary *)dict
              successBlock:(MagazineSuccessBlock)successBlock
            setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_MagazineLike
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}


// 用户不喜欢商品
- (void)requestDislikeArticle:(NSDictionary *)dict
                 successBlock:(MagazineSuccessBlock)successBlock
               setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_MagazineDislike
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}

// 获取收藏的文章列表
- (void)requestLikeArticleList:(NSDictionary *)dict
                  successBlock:(MagazineSuccessBlock)successBlock
                setFailedBlock:(MagazineFailedBlock)failedBlock
{
    [[RequestModel shareInstance] requestModelWithAPI:URL_LikeMagazines
                                              getDict:dict
                                         successBlock:successBlock
                                       setFailedBlock:failedBlock];
}



@end
