//
//  SquareLogic.m
//  Naonao
//
//  Created by 刘敏 on 16/5/31.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SquareLogic.h"
#import "SquareDAO.h"
#import "SquareModel.h"
#import "SearchDAO.h"
#import "TagsMode.h"
#import "AnswerMode.h"
#import "AnswerModeFrame.h"
#import "LoginDAO.h"
#import "QNUploadManager.h"
#import "CommentsModelFrame.h"
#import "MagazineInfo.h"
#import "DemandLogic.h"


@implementation SquareLogic

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static SquareLogic* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[SquareLogic alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]) {
        _fData = [[FilterData alloc] init];
    }
    
    return self;
}

- (void)setGMode:(GoodsMode *)gMode
{
    _gMode = gMode;
}

- (NSArray *)readSquareBanner {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Units getProfilePath:kSquareBanner]];
}

- (NSArray *)readSquareList {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[Units getProfilePath:kSquareList]];
}


//添加图片
- (void)addselectImages:(NSArray *)array{
    if (!_selectImages) {
        _selectImages = [[NSMutableArray alloc] init];
    }
    
    [_selectImages addObjectsFromArray:array];
}

- (void)temporaryStorageAnswerInfo:(StorageAnswer *)sT{
    _sT = [[StorageAnswer alloc] init];
    _sT = sT;
    
    if (_sT.imageArray) {
        //上传图片
        [self getQiniuToken];
    }
    else{
        //直接发布
        [self sendMessage];
    }
}

//获取单条问题
- (void)getSquareBasic:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPublishBasic:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            CLog(@"%@", [result objectForKey:@"orderinfo"]);
            SquareModel *sModel = [MTLJSONAdapter modelOfClass:[SquareModel class] fromJSONDictionary:result error:nil];
            [self summarizeString:sModel.orderInfo];

            cb.mObject = sModel;
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 获取问答广场
- (void)getSquareList:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPublishSquare:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            NSArray *tA = [MTLJSONAdapter modelsOfClass:[SquareModel class] fromJSONArray:(NSArray *)[result objectForKey:@"questions"] error:nil];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:tA.count];
            
            for (int i = 0; i <tA.count; i++) {
                SquareModel *sModel = tA[i];
                [self summarizeString:sModel.orderInfo];
                [temp addObject:sModel];
            }
            
            cb.mObject = temp;
            if ([self saveSquareListToFile:temp]) {
                CLog(@"保存成功");
            }
            
            cb.otherObject = [MTLJSONAdapter modelsOfClass:[STBanInfo class] fromJSONArray:(NSArray *)[result objectForKey:@"links"] error:nil];
            if ([self saveSquareBannerToFile:(NSArray *)cb.otherObject]) {
                CLog(@"保存成功");
            }
            
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//归集品类、场景、风格
- (void)summarizeString:(SOrderInfo *)sInfo {
    NSMutableString *st = [NSMutableString stringWithCapacity:0];

    //品类
    for (categoryModel *mode in [DemandLogic sharedInstance].categoryArray) {
        if ([mode.mId integerValue] == [sInfo.categoryId integerValue])
        {
            [st appendString:[NSString stringWithFormat:@"%@  |  ", mode.name]];
            break;
        }
    }

    //场景
    for (sceneModel *mode in [DemandLogic sharedInstance].sceneArray) {
        if ([mode.mId integerValue] == [sInfo.sceneId integerValue])
        {
            [st appendString:[NSString stringWithFormat:@"%@  |  ", mode.name]];
            break;
        }
    }
    
    //风格
    for (styleModel *mode in [DemandLogic sharedInstance].styleArray) {
        if ([mode.mId integerValue] == [sInfo.styleId integerValue])
        {
            [st appendString:[NSString stringWithFormat:@"%@", mode.name]];
            break;
        }
    }

    sInfo.summarize = st;
}

// 获取机器自动回复的内容
- (void)getPublishRobotAnswerList:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPublishRobotAnswer:dic successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            //传递解析的数据
            cb.mObject = [MTLJSONAdapter modelsOfClass:[RecommandDAO class] fromJSONArray:[result objectForKey:@"recommands"] error:nil];
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 查看用户答案列表(真实的舵主回复)
- (void)getAnswerList:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPublishAnswer:dic successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            
            NSArray *tA = [MTLJSONAdapter modelsOfClass:[AnswerMode class] fromJSONArray:(NSArray *)result error:nil];
            NSMutableArray *mA = [NSMutableArray arrayWithCapacity:tA.count];
            
            for (AnswerMode *amode in tA) {
                AnswerModeFrame *aFrame = [[AnswerModeFrame alloc] init];
                aFrame.aMode = amode;
                
                [mA addObject:aFrame];
            }
            cb.mObject = mA;
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 关心问题
- (void)getCareAnswer:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPublishCareAnswer:dic successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 不关心问题
- (void)getUnCareAnswer:(NSDictionary *)dic withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPublishUncareAnswer:dic successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//获取用户答案的评论
- (void)getAnswerComments:(NSDictionary *)param withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestAnswerComments:param successBlock:^(NSDictionary *result) {
        
        [cb success];
        
        if (result.count <= 0) {
            results(cb);
            return ;
        }
        
        NSArray *tA = [MTLJSONAdapter modelsOfClass:[STCommentData class] fromJSONArray:(NSArray *)result error:nil];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:tA.count];
        
        for (int i = 0; i<tA.count; i++) {
            CommentsModelFrame *cModel = [[CommentsModelFrame alloc] init];
            cModel.authorID = [param objectForKey:@"hobby_userid"];          //答案发布者
            cModel.tData = [tA objectAtIndex:i];
            
            [temp addObject:cModel];
        }
        
        cb.mObject = temp;
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
    
}

//添加答案评论
- (void)addAnswerComment:(NSDictionary *)param withCallback:(SquareLogicCommonCallback)results {
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestAddComments:param publicDict:nil successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

// 通过关键词搜索商品
- (void)searchKeywordWithGoods:(NSDictionary *)param withCallback:(SquareLogicCommonCallback)results
{
    SearchDAO *dao = [[SearchDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestSearchTagsWithProduct:param successBlock:^(NSDictionary *result) {
        [cb success];
        NSArray *array = [MTLJSONAdapter modelsOfClass:[GoodsMode class] fromJSONArray:(NSArray*)result error:nil];
        if (array.count > 0) {
            cb.mObject = array;
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//我的问题列表
- (void)getMyOrders:(NSDictionary *)param withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPublishMyOrders:param successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            
            NSArray *tA = [MTLJSONAdapter modelsOfClass:[SquareModel class] fromJSONArray:(NSArray *)result error:nil];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:tA.count];
            
            for (int i = 0; i <tA.count; i++) {
                SquareModel *sModel = tA[i];
                [self summarizeString:sModel.orderInfo];
                [temp addObject:sModel];
            }
            
            cb.mObject = temp;
        }
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 买家删除需求
- (void)getDeleteOrder:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestDeleteOrder:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
        
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

//点赞
- (void)getShowPraise:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPraise:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
    
}

//取消点赞
- (void)getShowUnPraise:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetUnPraise:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


#pragma mark - 添加答案
//获取七牛云key
- (void)getQiniuToken {
    LoginDAO *dao = [[LoginDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetQiniuToken:nil successBlock:^(NSDictionary *result) {
        NSString *token = [result objectForKeyNotNull:@"token"];
        NSString *preF = [result objectForKeyNotNull:@"prefix"];
        if (token) {
            [self uploadImagesToQiniuKey:token imagePrefix:preF];
        }
        else
        {
            [cb failure:nil];
        }
     
     } setFailedBlock:^(ResponseHeader *result) {
         [cb failure:result];
     }];
}



- (void)uploadImagesToQiniuKey:(NSString *)key imagePrefix:(NSString *)preF {
    __block NSMutableArray *temA = [NSMutableArray arrayWithCapacity:_sT.imageArray.count];
    
    NSInteger i = 1000;
    __typeof (&*self) __weak weakSelf = self;
    
    for (UIImage *image in _sT.imageArray) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        [upManager putData:data key:nil token:key
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      NSLog(@"上传的图片信息：%@", resp);
                      
                      if ([resp[@"hash"] length] < 1) {
                          CLog(@"文件上传失败");
                      }
                      
                      
                      NSString *imageS = [NSString stringWithFormat:@"%@/%@", preF, resp[@"hash"]];
                      [temA addObject:imageS];
                      
                      if (temA.count == weakSelf.sT.imageArray.count) {
                          weakSelf.sT.links = temA;
                          [self sendMessage];
                      }
                      
                  } option:nil];
        
        i++;
    }
}


// 添加答案网络请求
- (void)publishAddAnswer:(NSDictionary *)param withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestGetPublishAddAnswer:param publicDict:nil successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


// 添加答案
- (void)sendMessage {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (_sT.productId) {
        [dict setObject:_sT.productId forKey:@"product_id"];
    }
    
    if (_sT.orderId) {
        [dict setObject:_sT.orderId forKey:@"order_id"];
    }
    
    if (_sT.content) {
        [dict setObject:_sT.content forKey:@"content"];
    }
    
    // 图片拼接
    if (_sT.links) {
        [dict setObject:[_sT.links componentsJoinedByString:@"|"] forKey:@"links"];
    }
    
    __typeof (&*self) __weak weakSelf = self;
    [self publishAddAnswer:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //发送添加答案消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAnswerCompletionNotification" object:nil];
        }
        else
        {
            
        }
        
        weakSelf.sT = nil;
    }];
}


//删除评论的答案
- (void)deleteAnswerComment:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results {
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestDeleteAnswerComment:dict successBlock:^(NSDictionary *result) {
        [cb success];
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}


//获取我收藏的问题列表
- (void)getCareAnswers:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestCareOrdersAnswer:dict successBlock:^(NSDictionary *result) {
        [cb success];
        if (result.count > 0) {
            NSArray *tA = [MTLJSONAdapter modelsOfClass:[SquareModel class] fromJSONArray:(NSArray *)result error:nil];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:tA.count];
            
            for (int i = 0; i <tA.count; i++) {
                SquareModel *sModel = tA[i];
                [self summarizeString:sModel.orderInfo];
                [temp addObject:sModel];
            }
            
            cb.mObject = temp;
        }
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}
        
// 缓存广场列表
- (BOOL)saveSquareListToFile:(NSArray *)array
{
    return [NSKeyedArchiver archiveRootObject:array toFile:[Units getProfilePath:kSquareList]];
}

// 缓存banner信息
- (BOOL)saveSquareBannerToFile:(NSArray *)array
{
    return [NSKeyedArchiver archiveRootObject:array toFile:[Units getProfilePath:kSquareBanner]];
}

// 删除我的回答
- (void)deleteSquareAnswer:(NSDictionary *)dict withCallback:(SquareLogicCommonCallback)results
{
    SquareDAO *dao = [[SquareDAO alloc] init];
    LogicResult* cb = [[LogicResult alloc] init];
    
    [dao requestUserSquareDelAnswer:dict successBlock:^(NSDictionary *result) {
        
        results(cb);
    } setFailedBlock:^(ResponseHeader *result) {
        [cb failure:result];
        results(cb);
    }];
}

@end



@implementation FilterData


@end
