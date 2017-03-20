//
//  CouponsModel.h
//  Naonao
//
//  Created by 刘敏 on 16/5/11.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CouponsModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *mId;

@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *startTime;

@property (nonatomic, strong) NSNumber *type;

@end
