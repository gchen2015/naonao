//
//  InterestModel.h
//  Naonao
//
//  Created by Richard Liu on 15/12/16.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface InterestModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;        //答案
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, strong) NSString* name;


@end
