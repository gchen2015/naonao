//
//  PushCenter.m
//  Naonao
//
//  Created by 刘敏 on 16/5/20.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PushCenter.h"
#import "JSBadgeView.h"
#import "MessageCenter.h"
#import "TimeUtil.h"
#import "JPUSHService.h"

@implementation PushCenter

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static PushCenter* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[PushCenter alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        //消息
        _news = [NSKeyedUnarchiver unarchiveObjectWithFile:[Units getProfilePath:kMessageCenter]];
        
        if(!_news){
            [self laodMessageCenterPlist];
        }
    }
    
    return self;
}


- (BOOL)deleteProfile
{
    BOOL suc = [Units removeFileAtPath:[Units getProfilePath:kMessageCenter]];
    if (suc) {
        _news = nil;
    }
    return suc;
}


- (MixMode *)getNews
{
    return _news;
}


- (void)laodMessageCenterPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kMessageCenter ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    _news = [MTLJSONAdapter modelOfClass:[MixMode class] fromJSONDictionary:dict error:nil];
}

- (void)initializeTabbarBadge
{
    NSInteger m = [_news.like integerValue] + [_news.mix integerValue];
    //初始化
    [self updateTabbarBadgeAtIndex:2 enable:m];
}

// 缓存推送信息到本地
- (BOOL)saveNewsToFile:(MixMode*)news
{
    _news = news;
    return [NSKeyedArchiver archiveRootObject:_news toFile:[Units getProfilePath:kMessageCenter]];
}


// 注册极光推送
- (void)initXGPush:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    
#ifdef DEBUG
    
    // 调试环境
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:K_JG_APPKEY
                          channel:@"IOS"
                 apsForProduction:NO];
#else
    
    // 正式环境
    [JPUSHService setupWithOption:launchOptions appKey:K_JG_APPKEY
                          channel:@"IOS"
                 apsForProduction:YES];
    
#endif
}

- (void)setupBadgeView {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    
    CGFloat mX = 0.0;
    if (SCREEN_WIDTH == 320.0) {
        mX = 28.0;
    }
    else if (SCREEN_WIDTH == 375.0) {
        mX = 33.0;
    }
    else if (SCREEN_WIDTH > 375.0) {
        mX = 38.0;
    }
    
    for (int i = 0; i< 4; i++) {
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:theAppDelegate.tabBarController.tabBar
                                                               alignment:JSBadgeViewAlignmentTopLeft];
        
        CGFloat mc = SCREEN_WIDTH/4.0;
        badgeView.badgeOverlayColor = [UIColor clearColor];
        badgeView.badgeStrokeColor = [UIColor clearColor];
        badgeView.badgeShadowColor = [UIColor clearColor];
        
        [badgeView setBadgePositionAdjustment:CGPointMake(mc*(i+1)-mX, 12)];
        [badgeView setBadgeText:nil];
        [badgeView setBadgeTextFont:[UIFont systemFontOfSize:13.0]];
        [array addObject:badgeView];
    }
    
    self.badgeViewArray = array;
}


- (void)updateTabbarBadgeAtIndex:(int)index enable:(NSInteger)count {
    JSBadgeView *badgeView = [self.badgeViewArray objectAtIndex:index];
    if (count > 0) {
        [badgeView setBadgeText:[NSString stringWithFormat:@"%ld",(long)count]];
    }
    else {
        [badgeView setBadgeText:nil];
    }
}

#pragma mark 注册推送设备deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //注册设备
    [JPUSHService registerDeviceToken:deviceToken];
}

// 如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *str = [NSString stringWithFormat: @"Error: %@",error];
    CLog(@"%@",str);
    
}


// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    //    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    //    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
    
}

// 执行推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    CLog(@"%@", userInfo);
    
    //获取未读消息条数
    [self getUnReadMessage];
    
    //本身就在前台模式
    if(application.applicationState == UIApplicationStateActive)
    {

    }
    else
    {
        //跳转到消息模块
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[MessageCenter sharedInstance] jumpToMesage];
        });
    }
    
    if([self saveNewsToFile:_news])
    {
        CLog(@"保存成功");
    }
}

//获取未读的消息条数
- (void)getUnReadMessage
{
    User* user = [[UserLogic sharedInstance] getUser];
    if (!user) {
        return;
    }
    
    [[MessageCenter sharedInstance] getMessageCenterWithUnReadMessage:nil withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _news = result.mObject;
            // 统计数据
            NSInteger m = [_news.like integerValue] + [_news.mix integerValue];
            [self updateTabbarBadgeAtIndex:2 enable:m];
            
            NSInteger k = [_news.follow integerValue];
//            [self updateTabbarBadgeAtIndex:3 enable:k];
            
            if([self saveNewsToFile:_news])
            {
                CLog(@"保存成功");
            }
        }
        else
        {

        }
    }];
}

//读取未读消息
- (void)readMessage
{
    //通知服务器
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:@"mix" forKey:@"type"];
    [[MessageCenter sharedInstance] getMessageCenterWithReadMessage:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _news.mix = [NSNumber numberWithInteger:0];
            NSInteger m = [_news.like integerValue] + [_news.mix integerValue];
            //初始化
            [self updateTabbarBadgeAtIndex:2 enable:m];
            
            if([self saveNewsToFile:_news])
            {
                CLog(@"保存成功");
            }
        }
    }];
    
    
    if ([_news.like integerValue] > 0){
        //延迟执行
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //读取点赞消息
            [self readPraise];
        });
    }

}

- (void)readPraise{
    //通知服务器
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:@"like" forKey:@"type"];
    [[MessageCenter sharedInstance] getMessageCenterWithReadMessage:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            _news.like = [NSNumber numberWithInteger:0];
            NSInteger m = [_news.like integerValue] + [_news.mix integerValue];
            //初始化
            [self updateTabbarBadgeAtIndex:2 enable:m];
            
            if([self saveNewsToFile:_news])
            {
                CLog(@"保存成功");
            }
        }
    }];
}

// 更新数据
- (void)upLocalNewsMode
{
    //    NSInteger total = [_news.commentModel.number integerValue] + [_news.praiseModel.number integerValue] +
    //    [_news.focusModel.number integerValue] + [_news.customerModel.number integerValue] + [_news.systemModel.number integerValue] +
    //    [_news.answerModel.number integerValue] + [_news.careModel.number integerValue];
    //
    //    _news.mtotal = [NSNumber numberWithInteger:total];
    //
    //    //消息栏增加上标提醒
    //    [self updateTabbarBadgeAtIndex:2 enable:total];
    
    if([self saveNewsToFile:_news])
    {
        CLog(@"保存成功");
    }
    
}


@end
