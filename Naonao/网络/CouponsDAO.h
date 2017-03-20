//
//  CouponsDAO.h
//  Naonao
//
//  Created by 刘敏 on 16/3/16.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseHeader.h"

typedef void (^CouponsSuccessBlock)(NSDictionary *result);
typedef void (^CouponsFailedBlock)(ResponseHeader *result);

@interface CouponsDAO : NSObject

/**
 *  获取优惠券
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetCouponList:(NSDictionary *)dict
                successBlock:(CouponsSuccessBlock)successBlock
              setFailedBlock:(CouponsFailedBlock)failedBlock;


/**
 *  用户可用优惠券的个数
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestGetCouponCount:(NSDictionary *)dict
                 successBlock:(CouponsSuccessBlock)successBlock
               setFailedBlock:(CouponsFailedBlock)failedBlock;


/**
 *  使用优惠券
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestUseCoupon:(NSDictionary *)dict
            successBlock:(CouponsSuccessBlock)successBlock
          setFailedBlock:(CouponsFailedBlock)failedBlock;



/**
 *  发送优惠券
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestSendCoupon:(NSDictionary *)dict
             successBlock:(CouponsSuccessBlock)successBlock
           setFailedBlock:(CouponsFailedBlock)failedBlock;



/**
 *  领取优惠券（扫一扫）
 *  GET
 *
 *  @param dict
 *  @param successBlock
 *  @param failedBlock
 */
- (void)requestScanQRCodeCoupon:(NSDictionary *)dict
                   successBlock:(CouponsSuccessBlock)successBlock
                 setFailedBlock:(CouponsFailedBlock)failedBlock;


@end
