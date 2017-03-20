//
//  Requirement.h
//  NaoNao
//
//  Created by sunlin on 15/8/21.
//  Copyright (c) 2015年 HentenWasiky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemandMenu.h"


/**
 *  发布的需求
 */
@interface Requirement : NSObject

@property (nonatomic, strong) NSNumber *categoryID;         //商品类型
@property (nonatomic, strong) NSNumber *sceneID;            //场景类型
@property (nonatomic, strong) NSNumber *styleID;            //风格类型

@property (nonatomic, strong) NSString *categoryN;
@property (nonatomic, strong) NSString *sceneN;
@property (nonatomic, strong) NSString *styleN;


@property (nonatomic, strong) NSString *desc;               //需求描述


@end
