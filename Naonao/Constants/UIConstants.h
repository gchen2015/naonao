//
//  UIConstants.h
//  NaoNao
//
//  Created by sunlin on 15/7/31.
//  Copyright (c) 2015年 HentenWasiky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Extension.h"

//屏幕大小
#define MAINSCREEN   [UIScreen mainScreen].applicationFrame
//屏幕尺寸
#define MAINBOUNDS   [UIScreen mainScreen].bounds

#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//淘宝商品图片
#define  IMAGE_320_320_TAOBAO         @"_320x320.jpg"

//版本号
#define APP_Version       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#define CREATCONTROLLER(ClassName)          [[ClassName alloc] initWithNibName:[NSString stringWithFormat:@"%s",#ClassName] bundle:nil];


// 2. Your AppID (found in iTunes Connect)
#define kHarpyAppID                 @"1062732158"

// 3. Customize the alert title and action buttons
#define kHarpyAlertViewTitle        @"有新版本"
#define kHarpyCancelButtonTitle     @"下次再说"
#define kHarpyUpdateButtonTitle     @"更新"

#define kMinProgress 0.0001

/*****************************  系统控件相关 ****************************/
//系统版本
#define isIOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
#define isIOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
#define IOS9_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )



#define YELLOW_DARK                    [UIColor colorWithHex:0xB5A06F]

#define PUBLISH_BUTTON_DISABLE_COLOR   [UIColor colorWithHex:0xe0e2e1]
#define NAVI_BAR_COLOR                 [UIColor colorWithHex:0xF85246]
#define NN_BUTTON_HIGHLIGHT_COLOR      [UIColor colorWithHex:0x373737]



//新的颜色
#define PINK_COLOR                     [UIColor colorWithHex:0xFF6A66]

#define BLACK_COLOR                    [UIColor colorWithHex:0x575754]      //主字体
#define LIGHT_BLACK_COLOR              [UIColor colorWithHex:0x6D6A6A]      //次字体
#define GARY_COLOR                     [UIColor colorWithHex:0x8A8787]
#define LIGHT_GARY_COLOR               [UIColor colorWithHex:0xB0A9A7]      //弱灰色

#define BACKGROUND_GARY_COLOR          [UIColor colorWithHex:0xEEEBEB]      //背景灰
#define STROKE_GARY_COLOR              [UIColor colorWithHex:0xE0DEDE]      //描边

#define GOLDEN_YELLOW                  [UIColor colorWithHex:0xD3AF76]      //金黄
#define BROWN_COLOR                    [UIColor colorWithHex:0x7C4F4F]      //棕色

#define LINE_COLOR                     [UIColor colorWithHex:0xD2CFCE]      //线条颜色





#define Bottom_H                        49.0f                                                           //底部Tabbar的高度
#define NaviBar_H                       44.0f                                                           //导航栏高度
#define StatusBar_H                     [UIApplication sharedApplication].statusBarFrame.size.height    //状态栏的高度


#define IS_IPAD                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE                       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA                       ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH                    ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                   ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_MAX_LENGTH               (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH               (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


//iPhone4
#define   isIphone4                     [UIScreen mainScreen].bounds.size.height < 500

#define IS_IPHONE_4_OR_LESS             (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5                     (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6                     (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P                    (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


//返回码(Token失效)
const static NSUInteger kProtocolCodeInvalidToken =  1009;

//购物说明
#define K_Shop_Instructions             @"您在挠挠的旅程\n这是您要做的：\n发布问题——挑选推荐——平台下单——收到商品或——预约体验——享受服务（仅限深圳）\n\n我们为您准备的：\n接收问题——精挑细选——达人精心解答——品牌发货——商品入店——专业准备——服务试穿（部分商品）——接收订单——量体改衣（体验店用户）——美妆美拍（体验店用户）——美照制作（体验店用户）——精心包装——快递配送"


//退货说明
#define K_Good_Instructions             @"一．原创正品保证\n挠挠平台保证在售产品均为原创设计，品牌均为原创品牌。\n\n二．包邮\n挠挠为所有在售商品提供发货包邮服务，客户下单时实际付款金额即为订单总金额，无需额外承担发货运费。\n\n三．2个工作日发货\n挠挠将在订单成功支付后的2个工作日内通过快递完成订单发货。\n\n四．7日退换货\n如商品有任何非人为性的质量问题，可在收货后7日内发起退货申请，运费由挠挠承担。\n如因个人主观因素要求换货的，请在7日内联系客服，运费由客户承担。"



// 图片最多显示4张，超过8张取消单击事件
static NSInteger const KPhotoShowMaxCount = 6;

#define XG_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
