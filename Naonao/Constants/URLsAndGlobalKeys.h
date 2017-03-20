//
//  URLsAndGlobalKeys.h
//  NaoNao
//
//  Created by Richard Liu on 15/11/19.
//  Copyright © 2015年 HentenWasiky. All rights reserved.
//  存储网络接口（宏定义）


//#ifdef DEBUG

// 调试环境
#define URL_CommonString(path)      @"http://cento.naonaome.com/" path
#define URL_Domain                  @"http://cento.naonaome.com/"


//#else
//
//// 正式环境
//#define URL_CommonString(path)      [NSString stringWithFormat:@"http://v%@.naonaome.com/%@", @"2.3", path]
//#define URL_Domain                  [NSString stringWithFormat:@"http://v%@.naonaome.com/", @"2.3"]
//
//#endif


/**************************************  GET 请求  *********************************/

//用户注册
#define URL_UserRegister            URL_CommonString(@"user/register?")

//用户登录（自建帐号）8·  ]3
#define URL_UserLogin               URL_CommonString(@"user/login?")

//绑定第三方账号
#define URL_UserBindOpenID          URL_CommonString(@"user/bind_openid?")

//绑定手机号
#define URL_UserBindTelephone       URL_CommonString(@"user/bind_telephone?")

//修改用户密码
#define URL_UserUpdatePassword      URL_CommonString(@"user/modify_password?")

//获取短信验证码
#define URL_AuthenticationCode      URL_CommonString(@"user/get_registration_code?")

//检查手机号是否已注册
#define URL_UserPhoneCheckRegister  URL_CommonString(@"user/check_registration?")

//短信注册码验证
#define URL_UserCheckcode           URL_CommonString(@"user/verify_code?")

//修改用户资料
#define URL_UserModify              URL_CommonString(@"user/modify_info?")

//用户退出登录
#define URL_Userlogout              URL_CommonString(@"user/logout?")

//修改用户身材参数
#define URL_SaveBodyParam           URL_CommonString(@"user/save_bodyparam?")

//保存身材特点数据
#define URL_SaveBodyDefect          URL_CommonString(@"user/save_bodydefect?")

//重置身材数据
#define URL_RestBodyParams          URL_CommonString(@"user/reset_bodyparams?")

//获取播报模块的banner
#define URL_GetBannerList           URL_CommonString(@"magazine/list_banners?")

//查看资讯（播报）列表
#define URL_GetMagazineList         URL_CommonString(@"magazine/list_magazine?")

//查看品牌（播报）列表
#define URL_GetListBrands           URL_CommonString(@"magazine/list_brands?")

//品牌详情
#define URL_GetMagazineContent      URL_CommonString(@"magazine/get_magazine?")

//获取推荐的舵主
#define URL_GetRecommandUsers       URL_CommonString(@"magazine/recommand_users?")

//商品详情
#define URL_GetGoodsContent         URL_CommonString(@"product/detail?")

//查看商品的SKU列表
#define URL_GetGoodsSKUList         URL_CommonString(@"cart/sku_list?")

//查看购物车
#define URL_GetShopCart             URL_CommonString(@"cart/list_cart?")

//删除购物车中的商品
#define URL_DeleteItemsInCart       URL_CommonString(@"cart/delete_cart?")

//添加商品进购物车
#define URL_AddItemsInCart          URL_CommonString(@"cart/add_cart?")

//用户可用优惠券的个数
#define URL_GetCouponCount          URL_CommonString(@"coupon/count?")

//查看优惠券列表
#define URL_GetCouponList           URL_CommonString(@"coupon/list_coupon?")

//使用优惠券
#define URL_UseCoupon               URL_CommonString(@"coupon/use_coupon?")

//发放优惠券
#define URL_SendCoupon              URL_CommonString(@"user/add_coupon?")

//领取优惠券
#define URL_BindCoupon              URL_CommonString(@"user/bind_referrer?")

//获取支付要素
#define URL_PrePayOrder             URL_CommonString(@"pay/pre_pay?")

//创建订单
#define URL_CreateOrder             URL_CommonString(@"order/gen_order?")

//订单详情
#define URL_OrderDetail             URL_CommonString(@"order/order_detail?")

//我的订单
#define URL_MineOrderList           URL_CommonString(@"order/list_order?")

//更新收货地址
#define URL_UpdateAddress           URL_CommonString(@"user/update_address?")

//添加收货地址
#define URL_AddAddress              URL_CommonString(@"user/add_address?")

//获取地址列表
#define URL_GetAddressList          URL_CommonString(@"user/list_address?")

//设置成默认收货地址
#define URL_SetDefaultAddress       URL_CommonString(@"user/set_default_address?")

//获取默认收货地址
#define URL_GetDefaultAddress       URL_CommonString(@"user/get_default_address?")

//删除收货地址
#define URL_delete_DeleteAddress    URL_CommonString(@"user/delete_address?")

//发布需求（发表问题）
#define URL_UserPublish             URL_CommonString(@"publish/ask?")

//用户喜欢的商品列表
#define URL_LikeProducts            URL_CommonString(@"user/like_products?")

//用户喜欢商品
#define URL_UserFavorProduct        URL_CommonString(@"product/like?")

//用户不喜欢商品
#define URL_UserUnFavorProduct      URL_CommonString(@"product/unlike?")

//取消订单
#define URL_UserCancelOrder         URL_CommonString(@"order/cancel_order?")

//删除订单
#define URL_UserDeleteOrder         URL_CommonString(@"order/delete_order?")

//签收订单
#define URL_UserSignOrder           URL_CommonString(@"order/sign_order?")

//关联订单地址
#define URL_AssociatedOrderAddress  URL_CommonString(@"order/update_address?")

//获取配置数据
#define URL_GetConfigs              URL_CommonString(@"config/get_configs?")

//获取用户推荐列表
#define URL_GetRecommandList        URL_CommonString(@"show/recommand?")

//获取用户评论列表
#define URL_GetCommentList          URL_CommonString(@"show/list_comment?")

//发表评论
#define URL_GetPublishedComment     URL_CommonString(@"show/add_comment?")

//获取个人中心
#define URL_GetHobbyUserInfo        URL_CommonString(@"show/user_info?")

//关注用户
#define URL_GetHobbyFollow          URL_CommonString(@"show/follow?")

//取消关注用户
#define URL_GetHobbyUnfollow        URL_CommonString(@"show/unfollow?")

//同好点赞
#define URL_UserShowPraise          URL_CommonString(@"show/like?")

//同好取消点赞
#define URL_UserShowUnPraise        URL_CommonString(@"show/unlike?")

//获取物流状态
#define URL_GetLogisticsInfo        URL_CommonString(@"logistics/delivery_info?")

//发表评价（商品）
#define URL_GetPoductComment        URL_CommonString(@"product/add_comment?")

//获取所有兴趣标签
#define URL_GetInterestList         URL_CommonString(@"user/list_interest?")

//查看用户的兴趣标签
#define URL_GetInterest             URL_CommonString(@"user/get_interest?")

//查看用户身材数据
#define URL_GetBodyParam            URL_CommonString(@"user/get_bodyparam?")

//查看用户的风格标签
#define URL_GetUserStyles           URL_CommonString(@"user/get_styles?")

//保存用户的兴趣标签
#define URL_GetSaveInterest         URL_CommonString(@"user/save_interest?")

//申请七牛上传凭证
#define URL_GetQiniuToken           URL_CommonString(@"config/get_qiniu_token?")

//商品评论列表
#define URL_GetPCommentsList        URL_CommonString(@"product/list_comments?")

//发布买家秀
#define URL_GetShowCommit           URL_CommonString(@"show/commit?")

//收到的点赞
#define URL_GetNotificationPraise   URL_CommonString(@"notification/star?")

//收到的回答
#define URL_GetNotificationAnswers  URL_CommonString(@"notification/answers?")

//获取通知
#define URL_GetNotificationMix      URL_CommonString(@"notification/mix?")

//读取消息回执
#define URL_ReadNotification        URL_CommonString(@"notification/read?")

//查看未读消息数目
#define URL_UnReadMsgNotification   URL_CommonString(@"notification/unread_msg?")

//查看用户试穿的商品列表
#define URL_GetTryProducts          URL_CommonString(@"user/try_products?")

//第三方登录
#define URL_ThirdLogin              URL_CommonString(@"user/login_thirdparty?")

//更新用户头像
#define URL_UploadPictures          URL_CommonString(@"upload_img?")

//提交建议
#define URL_SaveSuggest             URL_CommonString(@"config/save_suggest?")

//获取我的钱包
#define URL_GetMyWallet             URL_CommonString(@"wallet/frontpage?")

//提现记录
#define URL_GetWithdrawalRecords    URL_CommonString(@"wallet/withdraw_records?")

//提现申请
#define URL_ApplyWithdrawal         URL_CommonString(@"wallet/withdraw?")

//提现详情
#define URL_WithdrawalDetails       URL_CommonString(@"wallet/withdraw_details?")

//单个商品返现明细
#define URL_GoodsCashbackDetails    URL_CommonString(@"wallet/details?")

//问答广场
#define URL_PublishSquare           URL_CommonString(@"publish/square?")

//查看用户答案列表
#define URL_PublishAnswer           URL_CommonString(@"publish/get_answers?")

//问题回应（算法推荐 + 机器人）
#define URL_PublishRobotAnswer      URL_CommonString(@"publish/order_detail?")

//关心广场上的问题
#define URL_PublishCareAnswer       URL_CommonString(@"publish/care?")

//取消关心广场上的问题
#define URL_PublishUncareAnswer     URL_CommonString(@"publish/uncare?")

//添加答案
#define URL_PublishAddAnswer        URL_CommonString(@"publish/answer?")

//我发布的问题列表
#define URL_PublishMyOrders         URL_CommonString(@"publish/my_orders?")

//删除提问（广场）
#define URL_PublishDeleteOrder      URL_CommonString(@"publish/delete_order?")

//根据子类别搜索商品
#define URL_SearchTagsWithProduct   URL_CommonString(@"product/search?")

//获取用户评论列表
#define URL_GetAnswerComments       URL_CommonString(@"publish/get_answer_comments?")

//添加答案的评论
#define URL_AddAnswerComments       URL_CommonString(@"publish/add_answer_comment?")

//答案点赞
#define URL_LikeAnswer              URL_CommonString(@"publish/like_answer?")

//答案取消点赞
#define URL_UnlikeAnswer            URL_CommonString(@"publish/unlike_answer?")

//删除答案中的评论
#define URL_DeleteAnswerComment     URL_CommonString(@"publish/delete_answer_comment?")

//获取收藏的问题列表
#define URL_PublishCareOrders       URL_CommonString(@"publish/care_orders?")

//查看用户等级和积分
#define URL_UserLevelScore          URL_CommonString(@"user/level_score?")

//获取答案评论消息
#define URL_NotAnswerComment        URL_CommonString(@"notification/answer_comment?")

//粉丝列表
#define URL_UserFollower            URL_CommonString(@"user/follower?")

//关注列表
#define URL_UserFollowing           URL_CommonString(@"user/following?")

//我的回答
#define URL_UserAnswers             URL_CommonString(@"user/answers?")

//我的评论
#define URL_UserComments            URL_CommonString(@"user/comments?")

//喜欢的资讯（专题）
#define URL_MagazineLike            URL_CommonString(@"magazine/like?")

//不喜欢的资讯
#define URL_MagazineDislike         URL_CommonString(@"magazine/dislike?")

//喜欢的资讯列表
#define URL_LikeMagazines           URL_CommonString(@"user/like_magazines?")

//获取单条问题
#define URL_PublishOrderBasic       URL_CommonString(@"publish/order_basic?")

//预约日历
#define URL_ChicdateMyTryCalender   URL_CommonString(@"chicdate/try_dress_calender?")

//预约日历(上门取货)
#define URL_TakeOrderCalender       URL_CommonString(@"chicdate/take_order_calender?")

//我的预约
#define URL_ChicdateMyTryDress      URL_CommonString(@"chicdate/my_try_dress?")

//预约试穿
#define URL_ChicdateTryDress        URL_CommonString(@"chicdate/try_dress?")

//预约上门取货
#define URL_ChicdateTakeOrder       URL_CommonString(@"chicdate/take_order?")

//我的预约
#define URL_ChicdateMyTakeOrder     URL_CommonString(@"chicdate/my_take_order?")

//我的写真
#define URL_BuyyerShow              URL_CommonString(@"user/buyyer_show?")

//删除我的广场回答
#define URL_SquareDelAnswer         URL_CommonString(@"user/del_answer?")


/**************************************  静态地址  *********************************/
//帮助
#define K_HELP_URL                   @"http://vvshop.naonaome.com/app/help.html"

//注册协议
#define K_AGREEMENT_URL              @"http://vvshop.naonaome.com/app/protocol.html"

//微信提现说明
#define K_WX_CASH                    @"http://vvshop.naonaome.com/app/wx_cash.html"

//网页跳转到商品详情
#define URL_NAONAOAPP_PRODUCT_URL    @"http://www.naonaome.com/naonaoApp/productId"


