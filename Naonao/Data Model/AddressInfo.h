//
//  AddressInfo.h
//  Naonao
//
//  Created by 刘敏 on 16/3/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AddressInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* province;
@property (nonatomic, strong) NSString* city;           //城市
@property (nonatomic, strong) NSString* country;        //区域

@property (nonatomic, strong) NSNumber* addressId;
@property (nonatomic, strong) NSNumber* isDefault;

@property (nonatomic, strong) NSString* zipcode;
@property (nonatomic, strong) NSString* telephone;
@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) NSNumber* isSelected;     //选中


@end



@class LogisticsInfo;
@interface CourierInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *deliverTime;
@property (nonatomic, strong) NSString *expressNo;          //快递单号
@property (nonatomic, strong) NSString *expressType;        //快递名称
@property (nonatomic, strong) NSNumber *deliveryId;
@property (nonatomic, strong) NSString *expressCode;        //快递编号
@property (nonatomic, strong) NSNumber *deliveryStatus;     //物流状态
@property (nonatomic, strong) LogisticsInfo *logis;

@end


//物流
@interface LogisticsInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *state;             //物流状态: 2-在途中，3-签收,4-问题件
@property (nonatomic, strong) NSString *logisticCode;      //快递单号
@property (nonatomic, strong) NSString *shipperCode;       //快递公司编号

@property (nonatomic, strong) NSString *businessID;
@property (nonatomic, strong) NSNumber *success;

@property (nonatomic, strong) NSArray *stationArray;

@end



@interface AcceptStation : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString* time;
@property (nonatomic, strong) NSString* station;    //站点说明
@property (nonatomic, strong) NSString* remark;

@end
