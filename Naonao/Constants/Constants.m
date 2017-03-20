//
//  Constants.m
//  NaoNao
//
//  Created by sunlin on 15/7/31.
//  Copyright (c) 2015年 HentenWasiky. All rights reserved.
//

#import "Constants.h"

// 官方微博账号UID
NSString* const    K_WEIBO_UID            = @"5579081497";

// 微博的KEY
NSString* const    K_WEIBO_APP_KEY        = @"3738145493";
NSString* const    K_WEIBO_APPSECRET      = @"ab8b4569556d682b0958e5037fad89f2";
NSString* const    K_REDIRECT_URL         = @"http://sns.whalecloud.com/sina2/callback";

// 微信的KEY
NSString* const    K_WEIXIN_APP_KEY       = @"wx9f1a57d2034d2d7e";
NSString* const    K_WEIXIN_APPSECRET     = @"d4624c36b6795d1d99dcf0547af5443d";

// QQ的KEY
NSString* const    K_QQ_APP_KEY           = @"1105376612";
NSString* const    K_QQ_APPSECRET         = @"RxaRs7tzUVAHuJNg";

// 友盟
NSString* const    K_YOUMENG_APPKEY       = @"5594a9cc67e58e4070000e2a";

//极光推送
NSString* const    K_JG_APPKEY            = @"837e4f76081823ef957ae4c8";
NSString* const    K_JG_APPSECRET         = @"63dc3ba113c85c8f6d22f34c";

//科大讯飞
NSString* const    K_KDXF_APPID           = @"56cec666";

//MD5的秘钥
NSString* const    kMD5Key                = @"6c0f56ad5d374551ae801920d72bf5a5";            //计算sv
NSString* const    kPKey                  = @"6c0f56ad5d374551ae801920d72bf512";            //登录密码

//美恰
NSString* const    K_MEIQIA_APPKEY        = @"04c810020df3d3973c9c455ecfb98683";
NSString* const    K_MEIQIA_APPSECRET     = @"$2a$12$5OEt3o/Hfj35701k2QMWEulfj07zF0enNwYrAi0MbHA9eoBSFNNPC";



//存储（文件名）
NSString* const kConfigName               = @"Config";            //支付方式
NSString* const kProfileName              = @"profile";           //用户信息
NSString* const kDemandMenu               = @"demandMenu";        //发布的各种配置信息
NSString* const kDefaultAddress           = @"defaultAddress";    //默认地址
NSString* const kMessageCenter            = @"MessageCenter";     //消息缓存文件;
NSString* const kRequirements             = @"requirements";      //发布需求的配置文件

NSString* const kSquareList               = @"squareList";        //广场列表
NSString* const kSquareBanner             = @"squareBanner";

NSString* const kHomeBanner               = @"homeBanner";        //播报广告
NSString* const kHomeInfo                 = @"homeInfo";          //资讯
NSString* const kHomeBrand                = @"homeBrand";         //品牌
NSString* const kHomeDuozhu               = @"homeDuozhu";        //舵主

//字体名
NSString* const kAkzidenzGroteskBQ        = @"AkzidenzGroteskBQ-MdCndAlt";


//七牛云图片处理
NSString* const kQNY_OriginImage_WEB      = @"imageView2/0/format/webp";       //转换成web格式
NSString* const kQNY_Compression_WEB      = @"imageView2/0/format/webp/q/80";  //转换成web格式,默认图像质量压缩为原图的80%
NSString* const kQNY_Small_Head           = @"imageView2/2/w/100";             //头像小图宽度为100 （以宽度为准）
NSString* const kQNY_Middle_Image         = @"imageView2/2/w/300";             //中图宽度为300 （以宽度为准）


