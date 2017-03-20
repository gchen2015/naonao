//
//  ResponseModel.h
//  Naonao
//
//  Created by 刘敏 on 16/4/22.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ResponseModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;
@property (nonatomic, strong) NSString* img;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* createTime;
@property (nonatomic, strong) NSString* category;

@end





