//
//  Constants.h
//  NaoNao
//
//  Created by sunlin on 15/7/31.
//  Copyright (c) 2015年 HentenWasiky. All rights reserved.
//

#import <Foundation/Foundation.h>

//App URLScheme
#define MY_APP_URL              @"naonaoApp"

//官方微博账号UID
UIKIT_EXTERN NSString* const    K_WEIBO_UID;

// 微博的KEY
UIKIT_EXTERN NSString* const    K_WEIBO_APP_KEY;
UIKIT_EXTERN NSString* const    K_WEIBO_APPSECRET;
UIKIT_EXTERN NSString* const    K_REDIRECT_URL;

//微信的KEY
UIKIT_EXTERN NSString* const    K_WEIXIN_APP_KEY;


UIKIT_EXTERN NSString* const    K_WEIXIN_APPSECRET;

// QQ的KEY
UIKIT_EXTERN NSString* const    K_QQ_APP_KEY;
UIKIT_EXTERN NSString* const    K_QQ_APPSECRET;

//友盟
UIKIT_EXTERN NSString* const    K_YOUMENG_APPKEY;

//极光推送
UIKIT_EXTERN NSString* const    K_JG_APPKEY;
UIKIT_EXTERN NSString* const    K_JG_APPSECRET;

//科大讯飞
UIKIT_EXTERN NSString* const    K_KDXF_APPID;


//MD5的秘钥
UIKIT_EXTERN NSString* const    kMD5Key;
UIKIT_EXTERN NSString* const    kPKey;

//美恰
UIKIT_EXTERN NSString* const    K_MEIQIA_APPKEY;
UIKIT_EXTERN NSString* const    K_MEIQIA_APPSECRET;



//业务处理返回状态（逻辑层）
typedef NS_ENUM(NSInteger, LogicStatus) {
    KLogicStatusSuccess  = 0,               //业务处理成功
    KLogicProcessFailure,                   //业务处理失败
    KLoginNetworkFailure                    //网络连接失败
};


//第三方登录方式
typedef NS_ENUM(NSInteger, ThirdLoginType) {
    KLoginWX  = 1,          //微信登录
    KLoginQQ,               //QQ登录
    KLoginWB                //微博登录
};


//挠志版式
typedef NS_ENUM(NSInteger, MagazineType){
    kMagazineTypeA = 1,     //版式一
    kMagazineTypeB = 2      //版式二
};


//身体特点
typedef NS_ENUM(NSInteger, BodyCharacterType) {
    KBodyCharacterNone  = 0,        //无缺陷
    KWaistThick         = 1,        //腰粗
    KShoulderBreadth    = 2,        //肩宽
    KArmCoarse          = 3,        //胳膊粗
    KHaveBelly          = 4,        //有肚腩
    KLegThick           = 5,        //腿粗
    KNeckCoarse         = 6,        //脖子粗
    KBigChest           = 7,        //大胸
    KFlatChest          = 8,        //平胸
    KBigHips            = 9,        //PP大
    KShortLegs          = 10,       //腿短
    KBigFace            = 11        //脸大
};


//更具入口不同进入不同的获取短信界面
typedef NS_ENUM(NSInteger, ChangePasswordEntrance) {
    KChangePassword_Login       = 0,        //找回密码
    KChangePassword_Setting     = 1,        //设置
    KChangePassword_Register    = 2,        //注册
    KChangePassword_BindPhone   = 3         //绑定手机
};


//支付渠道
typedef NS_ENUM(NSInteger, PaymentChannel){
    KPaymentChannel_WechatPay  = 2,    //微信支付
    KPaymentChannel_Alipay     = 4,    //支付宝App支付
//    KPaymentChannel_ApplePay   = 3,    //Apple Pay
//    KPaymentChannel_Unionpay   = 4,    //银联手机支付
};


//进入SKU的渠道
typedef NS_ENUM(NSInteger, EnterSKUType){
    KSKU_Order      =  1,
    KSKU_Cart       =  2,
};


//订单类型
typedef NS_ENUM(NSInteger, OrderType){
    KOrder_All              = -1,   //全部
    KOrder_WaitingPayment   = 0,    //待支付
    KOrder_Cancel           = 1,    //已取消
    KOrder_PaySuccess       = 2,    //支付成功
    KOrder_Signed           = 3,    //已收货
    KOrder_HaveEvaluation   = 4,    //已评价
};

//订单按钮状态
typedef NS_ENUM(NSInteger, OrderBtnType){
    K_ORDER_PAY              = 0,    //等待支付
    K_ORDER_DELETE           = 1,    //删除
    K_ORDER_GOODS            = 2,    //收货
    K_ORDER_EVALUATION       = 3,    //评价
    K_ORDER_CANCEL           = 4,    //取消订单
    K_ORDER_LOGISTICS        = 5,    //查看物流
};


//消息类型
typedef NS_ENUM(NSInteger, MessageType){
    MSG_TYPE_COMMENT            = 1,    //收到的评论
    MSG_TYPE_STAR               = 2,    //点赞
    MSG_TYPE_FOLLOW             = 3,    //关注
    MSG_TYPE_CUSTOMER           = 4,    //客服
    MSG_TYPE_SYS                = 5,    //系统消息
    MSG_TYPE_ANSWER             = 6,    //回答了提问
    MSG_TYPE_CARE               = 7,    //关心了提问
    MSG_TYPE_ANSWER_COMMENT     = 8,    //答案的评论
};


//图片显示器分类
typedef NS_ENUM(NSInteger, STShowImageType) {
    STShowImageTypeImagePicker  = 0,    //照片选择器
    STShowImageTypeImageBroswer,        //照片浏览器
    STShowImageTypeImageURL,            //网络图片浏览器
};

//方向类型(发布需求，菜单弹出方向)
typedef NS_ENUM(NSInteger, DirectionType){
    kDirectionTypeRight = 0,
    kDirectionTypeLeft
};

//文件名
UIKIT_EXTERN NSString* const kConfigName;
UIKIT_EXTERN NSString* const kProfileName;
UIKIT_EXTERN NSString* const kDemandMenu;
UIKIT_EXTERN NSString* const kDefaultAddress;
UIKIT_EXTERN NSString* const kMessageCenter;
UIKIT_EXTERN NSString* const kRequirements;



UIKIT_EXTERN NSString* const kSquareList;
UIKIT_EXTERN NSString* const kSquareBanner;

UIKIT_EXTERN NSString* const kHomeBanner;        
UIKIT_EXTERN NSString* const kHomeInfo;
UIKIT_EXTERN NSString* const kHomeBrand;
UIKIT_EXTERN NSString* const kHomeDuozhu;




//字体名
UIKIT_EXTERN NSString* const kAkzidenzGroteskBQ;     


//七牛云图片处理
UIKIT_EXTERN NSString* const kQNY_OriginImage_WEB;
UIKIT_EXTERN NSString* const kQNY_Compression_WEB;
UIKIT_EXTERN NSString* const kQNY_Small_Head;              
UIKIT_EXTERN NSString* const kQNY_Middle_Image;

