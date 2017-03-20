//
//  PushCenter.h
//  Naonao
//
//  Created by 刘敏 on 16/5/20.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixMode.h"
#import <MeiQiaSDK/MQManager.h>


#define kNotificationCategoryIdentifile             @"ACTIONABLE"
#define kNotificationActionOneIdent                 @"ACTION_ONE"
#define kNotificationActionTwoIdent                 @"ACTION_TWO"



@interface PushCenter : NSObject

@property (strong, nonatomic) NSArray *badgeViewArray;
@property (strong, nonatomic) MixMode *news;

+ (instancetype)sharedInstance;

- (void)laodMessageCenterPlist;

// 删除缓存文件
- (BOOL)deleteProfile;

// 更新数据
- (void)upLocalNewsMode;

// 获取未读的消息条数
- (void)getUnReadMessage;

- (void)initializeTabbarBadge;

//读取未读消息
- (void)readMessage;

// 获取缓存消息
- (MixMode *)getNews;

// 缓存推送信息到本地
- (BOOL)saveNewsToFile:(MixMode*)news;

// 初始化信鸽推送
- (void)initXGPush:(NSDictionary *)launchOptions;

//设置tabar的Badge
- (void)setupBadgeView;

//重新调整消息计数
//- (void)adjustMessage:(NSInteger)index;

// 注册推送设备deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

// 如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

// 执行推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;


@end
