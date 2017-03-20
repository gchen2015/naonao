//
//  AppDelegate.h
//  Naonao
//
//  Created by Richard Liu on 15/11/19.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//
// ---------------------------------------------------------------------------*/
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
//                   ___`. .` /--.--\ `. .`___
//                ."" '< `.___\_<|>_/___.' >' "".
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
// ---------------------------------------------------------------------------*/



#import <UIKit/UIKit.h>
#import "STTabBarController.h"
#import "JGProgressHUDManager.h"
#import "PushCenter.h"




@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) JGProgressHUDManager *HUDManager;
@property (strong, nonatomic) STTabBarController *tabBarController;

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedAppDelegate;

// 弹出发布需求页面
- (void)popCenterView;

// 弹出登录框
- (void)popLoginView;

// 登录成功
- (void)loginSuccess;

// 跳转到未回应详情页
- (void)popToNotRespondView;


@end

