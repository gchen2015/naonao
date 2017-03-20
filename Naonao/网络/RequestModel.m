;//
//  RequestModel.m
//  Artery
//
//  Created by 刘敏 on 14-9-15.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//
//  封装网络请求

#import "RequestModel.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "NSString+Hash.h"
#import "GTMBase64.h"


@implementation RequestModel


+ (instancetype)shareInstance {
    
    static dispatch_once_t predicate;
    static RequestModel *instance = nil;
    
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (NSDictionary *)getToken {

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    NSString* time = [Units getTimeStrWithDateFormat:@"yyyyMMddHHmm" withTime:[[NSDate date] timeIntervalSince1970]];
    NSString* sequenceId = [NSString stringWithFormat:@"%d", arc4random() % RAND_MAX];
    NSString* md5Origin = [[kMD5Key stringByAppendingString:sequenceId] stringByAppendingString:time];
    
    [dic setObject:[md5Origin md5String] forKey:@"sv"];
    [dic setObject:sequenceId forKey:@"sequenceId"];
    
    //登录之后必传参数
    User* user = [[UserLogic sharedInstance] getUser];
    if (user) {
        [dic setObject:[UserLogic sharedInstance].user.basic.userId forKey:@"userid"];
        [dic setObject:[UserLogic sharedInstance].user.basic.token forKey:@"token"];
    }
    
    return dic;
}


- (NSDictionary* )insertTokenValidation:(NSDictionary* )dic {
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    if (dic) {
        [mDic addEntriesFromDictionary:dic];
    }
    
    //device type,也就是设备类型 如android: 0表示(默认), ios:1
    [mDic addEntriesFromDictionary:[self getToken]];
    [mDic setObject:@"json" forKey:@"otype"];
    
    
    return mDic;
}


// GET请求
- (void)requestModelWithAPI:(NSString *)api
                    getDict:(NSDictionary *)getDict
               successBlock:(RequestModelBlock)successBlock
             setFailedBlock:(RequestFailedBlock)failedBlock
{
    ASIHTTPRequest *request = nil;
    
    NSString *urlStr = api;
    
    getDict = [self insertTokenValidation:getDict];
    
    if ([getDict count] > 0) {
        
        // 存储get数据
        NSMutableArray *getArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray *allKeys = [getDict allKeys];
        for (int i=0; i<[allKeys count]; i++) {
            
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [getDict objectForKey:key];
            
            if (value) {
                [getArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
            }
        }
        
        urlStr = [NSString stringWithFormat:@"%@%@", urlStr, [getArray componentsJoinedByString:@"&"]];
        CLog(@"%@", urlStr);
        
        //中文字符转UTF8
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [request setRequestMethod:@"GET"];
        
    }
    else {
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    }
    
    
//    //加载SSL证书
//    NSData *cerFile = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"naonaoSSL" ofType:@"crt"]];
//    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerFile);
//    NSArray *array = [NSArray arrayWithObjects:(__bridge id)cert, nil];
//    [request setClientCertificates:array];
//    [request setValidatesSecureCertificate:NO];

    
    [request startAsynchronous];
    
    ASIHTTPRequest *requestTemp = request;

    [request setCompletionBlock:^{
        //解析返回数据
        NSDictionary *dict = nil;
        if (requestTemp.responseData) {
            dict = [STJSONSerialization JSONObjectWithData:requestTemp.responseData];
        }
        
        CLog(@"%@", dict);
        
        if (dict) {
            ResponseHeader *resHeader = [[ResponseHeader alloc] initWithParsData:[dict objectForKeyNotNull:@"response_header"]];
            
            if ([resHeader.status integerValue] == 0 ) {
                //成功
                successBlock([dict objectForKeyNotNull:@"response"]);
            }
            else
            {
                if ([resHeader.status integerValue] == kProtocolCodeInvalidToken)
                {
                    //注销
                    [theAppDelegate popLoginView];
                }
                
                //业务处理失败
                failedBlock(resHeader);
            }
        }
        else{
            //服务端处理异常
            failedBlock(nil);
        }

    }];
    
    
    [request setFailedBlock:^{
        //网络异常（未收到服务端返回）
        failedBlock(nil);

    }];

}

// POST请求(带参)
- (void)requestModelWithAPI:(NSString *)api
                   postDict:(id)postDict
                 publicDict:(NSDictionary *)publicDict
               successBlock:(RequestModelBlock)successBlock
             setFailedBlock:(RequestFailedBlock)failedBlock
{
    
    publicDict = [self insertTokenValidation:publicDict];
    
    if ([publicDict count] > 0) {
        // 存储get数据
        NSMutableArray *pubArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray *allKeys = [publicDict allKeys];
        for (int i=0; i<[allKeys count]; i++) {
            
            NSString *key = [allKeys objectAtIndex:i];
            // Emoji转码
            NSString *value = [publicDict objectForKey:key];
            
            if (value) {
                [pubArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
            }
        }
        
        api = [NSString stringWithFormat:@"%@%@", api, [pubArray componentsJoinedByString:@"&"]];
        CLog(@"%@", api);
        
        //中文字符转UTF8
        api = [api stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:api]];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    //以Data的形式提交
    [request setPostBody:tempJsonData];
    [request addRequestHeader:@"Content-Type" value:@"pplication/json"];
    [request setRequestMethod:@"POST"];

//    //加载SSL证书
//    NSData *cerFile = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"naonaoSSL" ofType:@"crt"]];
//    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerFile);
//    NSArray *array = [NSArray arrayWithObjects:(__bridge id)cert,nil];
//    [request setClientCertificates:array];
//    [request setValidatesSecureCertificate:NO];
    
    [request startAsynchronous];
    
    ASIHTTPRequest *requestTemp = request;
    
    [request setCompletionBlock:^{
        //解析返回数据
        NSDictionary *dict = nil;
        if (requestTemp.responseData) {
            dict = [STJSONSerialization JSONObjectWithData:requestTemp.responseData];
        }
        CLog(@"%@", dict);
        
        if (dict) {
            ResponseHeader *resHeader = [[ResponseHeader alloc] initWithParsData:[dict objectForKeyNotNull:@"response_header"]];
            
            if ([resHeader.status integerValue] == 0 ) {
                //成功
                successBlock([dict objectForKeyNotNull:@"response"]);
            }
            else
            {
                
                if ([resHeader.status integerValue] == kProtocolCodeInvalidToken)
                {
                    
                    [theAppDelegate popLoginView];
                }

                //业务处理失败
                failedBlock(resHeader);
            }
        }
        else{
            //服务端处理异常
            failedBlock(nil);
        }
    }];
    
    
    [request setFailedBlock:^{
        //网络异常（未收到服务端返回）
        failedBlock(nil);
        
    }];
}

@end
