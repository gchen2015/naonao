//
//  MixMode.h
//  Naonao
//
//  Created by 刘敏 on 16/5/20.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface MixMode : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *like;
@property (nonatomic, strong) NSNumber *follow;
@property (nonatomic, strong) NSNumber *mix;

@end

