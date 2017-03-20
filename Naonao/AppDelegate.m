//
//  AppDelegate.m
//  Naonao
//
//  Created by Richard Liu on 15/11/19.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼            BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？


#import "AppDelegate.h"
#import <SDWebImage/SDImageCache.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <UMSocialCore/UMSocialCore.h>
#import "DemandLogic.h"
#import "LoginViewController.h"
#import "STNavigationController.h"
#import "Harpy.h"
#import "MagazineLogic.h"
#import <Pingpp/Pingpp.h>
#import <MeiQiaSDK/MQManager.h>
#import "ShoppingLogic.h"
#import "SquareViewController.h"
#import "CALayer+Transition.h"
#import "STGoodsMainViewController.h"
#import "NaonaoViewController.h"
#import "MQServiceToViewInterface.h"
#import "NSArray+MQFunctional.h"
#import "Units.h"
#import "JPUSHService.h"
#import "MineViewController.h"
#import "OrdersViewController.h"
#import "ShopCartViewController.h"
#import "FavoritesViewController.h"


@interface AppDelegate ()

@property (strong, nonatomic) UIView *lunchView;

@end

@implementation AppDelegate


+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//移除注册到消息中心的通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Private methods
// 弹出发布需求页面
- (void)popCenterView {
    //获取根目录
    STNavigationController *currentController = self.tabBarController.selectedViewController;
    [currentController popToRootViewControllerAnimated:YES];
    
    if ([currentController.topViewController isKindOfClass:[SquareViewController class]]){
        //获取导航控制器的top
        SquareViewController *mV = (SquareViewController *)currentController.topViewController;
        //延迟
        double delayInSeconds = 0.8;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [mV addBtnTapped:nil];
        });
    }
    else
    {
        CLog(@"失败");
    }
}

// 弹出登录框
- (void)popLoginView {
    //注销
    [[UserLogic sharedInstance] cleanDataWhenLogout];
    [[ShoppingLogic sharedInstance] cleanDataWhenLogout];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FIRST_LAODMAGAZINELIST"];
    
    User* user = [[UserLogic sharedInstance] getUser];
    if (!user) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
        [self.tabBarController presentViewController:nc animated:YES completion:nil];
    }
}

// 登录成功
- (void)loginSuccess
{
    _tabBarController.selectedIndex = 0;
    
    User* user = [[UserLogic sharedInstance] getUser];
    if (user) {
        //登录成功后重新注册远程推送服务
        [[PushCenter sharedInstance] initXGPush:nil];
    }

    //获取未读消息数目
    [[PushCenter sharedInstance] getUnReadMessage];
    
    //获取配置数据
    [[DemandLogic sharedInstance] getConfigsData];
    
    //获取默认地址
    [[ShoppingLogic sharedInstance] requestDefaulAddress];
}

// 跳转到未回应详情页
- (void)popToNotRespondView
{
    self.tabBarController.selectedIndex = 1;
    //获取根目录
    STNavigationController *currentController = self.tabBarController.selectedViewController;
    [currentController popToRootViewControllerAnimated:YES];
    
    if ([currentController.topViewController isKindOfClass:[SquareViewController class]]){
        //获取导航控制器的top
        SquareViewController *mV = (SquareViewController *)currentController.topViewController;
        //延迟
        double delayInSeconds = 0.8;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [mV updateTableView];
        });
    }
    else
    {
        CLog(@"失败");
    }
}


//跳转到商品详情页面
- (void)jumpToSTGoodsMainViewController:(NSNumber *)productId{
    
    self.tabBarController.selectedIndex = 0;
    //获取根目录
    STNavigationController *currentController = self.tabBarController.selectedViewController;
    [currentController popToRootViewControllerAnimated:YES];
    
    if ([currentController.topViewController isKindOfClass:[NaonaoViewController class]]){
        //获取导航控制器的top
        NaonaoViewController *mV = (NaonaoViewController *)currentController.topViewController;

        
        MagazineContentInfo *mcInfo = [[MagazineContentInfo alloc] init];
        mcInfo.productId = productId;
        
        STGoodsMainViewController *goodsVC = [[STGoodsMainViewController alloc] init];
        goodsVC.hidesBottomBarWhenPushed = YES;
        goodsVC.mInfo = mcInfo;

        //延迟执行
        double delayInSeconds = 0.8;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [mV.navigationController pushViewController:goodsVC animated:YES];
        });
        
        
    }
}

- (void)initComponent
{
    //集成友盟社会化组件
    [[UMSocialManager defaultManager]  setUmSocialAppkey:K_YOUMENG_APPKEY];
    
    //集成友盟分析组件(数据分析、bug分析)
    [UMAnalyticsConfig sharedInstance].appKey = K_YOUMENG_APPKEY;
    [UMAnalyticsConfig sharedInstance].channelId = @"App Store";
    [MobClick startWithConfigure:[UMAnalyticsConfig sharedInstance]];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
      
    //设置微信的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                          appKey:K_WEIXIN_APP_KEY
                                       appSecret:K_WEIXIN_APPSECRET
                                     redirectURL:@"http://mobile.umeng.com/social"];

    //设置新浪的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:K_WEIBO_APP_KEY
                                       appSecret:K_WEIBO_APPSECRET
                                     redirectURL:K_REDIRECT_URL];
    
    //设置分享到QQ互联的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                          appKey:K_QQ_APP_KEY
                                       appSecret:K_QQ_APPSECRET
                                     redirectURL:@"http://mobile.umeng.com/social"];
    

    //Ping++打印日志
    [Pingpp setDebugMode:YES];
    
    //美恰
    [MQManager initWithAppkey:K_MEIQIA_APPKEY completion:^(NSString *clientId, NSError *error) {
        CLog(@"%@", error.userInfo);
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onlineSuccessed) name:MQ_CLIENT_ONLINE_SUCCESS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadMessageCount) name:MQ_RECEIVED_NEW_MESSAGES_NOTIFICATION object:nil];
}

//告诉代理进程启动但还没进入状态保存
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //创建window
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [self.window setBackgroundColor:[UIColor whiteColor]];

    [self initTabbar];

    [self.window makeKeyAndVisible];
    
    //网络监测
    [self monitoringNetwork];
    
    //判断是否是新版本
    if ([Units canShowNewFeature]) {
        //TODO：更新版本后以便设置极光推送别名，需要注销用户重新登录
        [[UserLogic sharedInstance] cleanDataWhenLogout];
        [[ShoppingLogic sharedInstance] cleanDataWhenLogout];
    }
    
    return YES;
}

//告诉代理启动基本完成程序准备开始运行
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化
    _HUDManager = [[JGProgressHUDManager alloc] initManager];
    
    //初始化第三方组件
    [self initComponent];
    
    //加载STTabBarController
    [self initTabbar];
    
    //初始化极光推送
    [[PushCenter sharedInstance] initXGPush:launchOptions];
    
    if ([UserLogic sharedInstance].user.basic.userId)
    {
        [self loginSuccess];
    }
    
    //初始化Tabbar Badge
    [[PushCenter sharedInstance] initializeTabbarBadge];
    
    //清除icon角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if (launchOptions) {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [[PushCenter sharedInstance] application:application didReceiveRemoteNotification:dictionary];
  
    }

    return YES;
}

- (void)initTabbar
{
    //初始化tabbar
    if (!self.tabBarController) {
        self.tabBarController = [[STTabBarController alloc] init];
        self.tabBarController.delegate = (id)self;
    }
    
    [self.window setRootViewController:self.tabBarController];
    
    [[PushCenter sharedInstance] setupBadgeView];
}

// 如果App是从快速入口启动的，则会执行这个方法。该方法的shortcutItem参数携带了从快速入口进入app时的标签参数。
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    if ([shortcutItem.type isEqualToString:@"first"]) {
        [self jumpToTuchIndex:0];
    }
    else if ([shortcutItem.type isEqualToString:@"second"]) {
        [self jumpToTuchIndex:1];
    }
    else if ([shortcutItem.type isEqualToString:@"third"]) {
        [self jumpToTuchIndex:2];
    }
}

- (void)jumpToTuchIndex:(NSUInteger)row{
    
    self.tabBarController.selectedIndex = 0;
    //获取根目录
    STNavigationController *currentController = self.tabBarController.selectedViewController;
    [currentController popToRootViewControllerAnimated:YES];
    
    if ([currentController.topViewController isKindOfClass:[NaonaoViewController class]]){
        //获取导航控制器的top
        NaonaoViewController *mV = (NaonaoViewController *)currentController.topViewController;
        
        switch (row) {
            case 0:
            {
                // 延迟
                ShopCartViewController *sVC = [[ShopCartViewController alloc] init];
                sVC.hidesBottomBarWhenPushed = YES;
                
                //延迟执行
                double delayInSeconds = 0.8;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [mV.navigationController pushViewController:sVC animated:YES];
                });
            }
                break;
                
            case 1:
            {
                OrdersViewController *sVC = [[OrdersViewController alloc] init];
                sVC.hidesBottomBarWhenPushed = YES;
                
                //延迟执行
                double delayInSeconds = 0.8;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [mV.navigationController pushViewController:sVC animated:YES];
                });
            }
                break;
                
            case 2:
            {
                FavoritesViewController *sVC = [[FavoritesViewController alloc] init];
                sVC.hidesBottomBarWhenPushed = YES;
                
                //延迟执行
                double delayInSeconds = 0.8;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [mV.navigationController pushViewController:sVC animated:YES];
                });
            }
                break;
                
                
            default:
                break;
        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [MQManager closeMeiqiaService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [MQManager openMeiqiaService];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //版本检测
    [Harpy checkVersion];
    
    //获取未读消息数目
    [[PushCenter sharedInstance] getUnReadMessage];
    
    //大于100M自动清空缓存
    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    if (tmpSize > 100.0f) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [[UMSocialManager defaultManager] handleOpenURL:url];
}


//接收并处理交易结果Ping++ (ios8)
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlS = [url absoluteString];
    
    if ([urlS hasPrefix:@"http://m.naonaome.com/goodsDetails/productId="]) {
        //进入商品详情
        NSArray *temA = [urlS componentsSeparatedByString:@"="];
        NSNumber *proId = [NSNumber numberWithInteger:[[temA objectAtIndex:1] integerValue]];
        //进入商品详情
        [self jumpToSTGoodsMainViewController:proId];
    }
    else{
        if([urlS hasPrefix:@"wb3738145493:"] || [urlS hasPrefix:@"wx9f1a57d2034d2d7e:"] || [urlS hasPrefix:@"tencent1105376612:"]) {
            //微博、微信、QQ
            return  [[UMSocialManager defaultManager] handleOpenURL:url];
        }
        else if ([urlS hasPrefix:@"naonaoApp:"])
        {
            BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
            return canHandleURL;
        }
    }
    
    return NO;
}

//接收并处理交易结果Ping++ (ios9及以上)
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    NSString *urlS = [url absoluteString];
    
    if ([urlS hasPrefix:@"http://m.naonaome.com/goodsDetails/productId="]) {
        //进入商品详情
        NSArray *temA = [urlS componentsSeparatedByString:@"="];
        NSNumber *proId = [NSNumber numberWithInteger:[[temA objectAtIndex:1] integerValue]];
        //进入商品详情
        [self jumpToSTGoodsMainViewController:proId];
    }
    else{
        if([urlS hasPrefix:@"wb3738145493:"] || [urlS hasPrefix:@"wx9f1a57d2034d2d7e://oauth?"] || [urlS hasPrefix:@"tencent1105376612:"]) {
            //微博、微信、QQ
            return  [[UMSocialManager defaultManager] handleOpenURL:url];
        }
        else if ([urlS hasPrefix:@"naonaoApp://"] || [urlS hasPrefix:@"wx9f1a57d2034d2d7e://pay"])
        {
            //支付
            BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
            return canHandleURL;
        }
    }

    return NO;
}

#pragma mark 注册推送设备deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[PushCenter sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[PushCenter sharedInstance] application:app didFailToRegisterForRemoteNotificationsWithError:error];
}


//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

// 执行远程推送（后台唤醒）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    CLog(@"%@", userInfo);
    [[PushCenter sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

// 执行远程推送（前台）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
                                                       fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    [[PushCenter sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    User *user = [[UserLogic sharedInstance] getUser];
    if (user && tabBarController.selectedIndex == 2) {
        //清空消息
        [[PushCenter sharedInstance] readMessage];
    }
}

//#pragma mark 启动动画
//- (void)loadLaunch
//{
//    _lunchView = [[NSBundle mainBundle ]loadNibNamed:@"STLaunchView" owner:nil options:nil][0];
//    _lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
//    [self.window addSubview:_lunchView];
//    
//    
//    UIImageView *imageA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_2.png"]];
//    [imageA setFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_WIDTH)];
//    [_lunchView addSubview:imageA];
//    
//    /* 旋转 */
//    // 对Y轴进行旋转（指定Z轴的话，就和UIView的动画一样绕中心旋转）
//    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    
//    // 设定动画选项
//    rotationAnimation.duration = 20; // 持续时间
//    rotationAnimation.repeatCount = 1; // 重复次数
//    // 设定旋转角度
//    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];       // 起始角度
//    rotationAnimation.toValue = [NSNumber numberWithFloat:1 * M_PI];    // 终止角度
//    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    [imageA.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//    
//    
//    UIImageView *imageB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_1.png"]];
//    [imageB setFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_WIDTH)];
//    [_lunchView addSubview:imageB];
//    
//    /* 旋转 */
//    // 对Y轴进行旋转（指定Z轴的话，就和UIView的动画一样绕中心旋转）
//    CABasicAnimation *rotationAnimationB = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    
//    // 设定动画选项
//    rotationAnimationB.duration = 30;   // 持续时间
//    rotationAnimationB.repeatCount = 1; // 重复次数
//    // 设定旋转角度
//    rotationAnimationB.fromValue = [NSNumber numberWithFloat:0.0];       // 起始角度
//    rotationAnimationB.toValue = [NSNumber numberWithFloat:2 * M_PI];    // 终止角度
//    rotationAnimationB.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    [imageB.layer addAnimation:rotationAnimationB forKey:@"rotationAnimation"];
//    
//    
//    [self.window bringSubviewToFront:_lunchView];
//    
//    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
//}
//
//- (void)removeLun
//{
//    //转场动画
//    [self.window.layer transitionWithAnimType:TransitionAnimTypeOglFlip subType:TransitionSubtypesFromLeft curve:TransitionCurveEaseIn duration:1.0f];
//    [_lunchView removeFromSuperview];
//}

- (void)onlineSuccessed {
    CLog(@"客服启动成功");
}


- (void)updateUnreadMessageCount {
    [MQServiceToViewInterface getUnreadMessagesWithCompletion:^(NSArray *messages, NSError *error) {
        NSUInteger count = [[messages filter:^BOOL(MQMessage *message) {
            return message.fromType != MQMessageFromTypeClient;
        }] count];
        
        CLog(@"未读消息条数： %lu", count);
        
//        MQMessage *message = [messages objectAtIndex:0];
//        [[PushCenter sharedInstance] addMessage:message];
        
    }];
}

#pragma mark 网络监测
- (void)monitoringNetwork
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                CLog(@"未识别的网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                CLog(@"不可达的网络(未连接)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                CLog(@"2G,3G,4G...的网络");
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Network_Connection_Normal" object:nil];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                CLog(@"wifi的网络");
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Network_Connection_Normal" object:nil];
                break;
            default:
                break;
        }
    }];
    
    //开始监听
    [manager startMonitoring];
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//
//    // Required
//    
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
//
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler();  // 系统要求执行这个方法
}

@end
