//
//  DelegateContainer.h
//  Naonao
//
//  Created by 刘敏 on 16/7/29.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DelegateContainer : NSObject<UIScrollViewDelegate>

@property (nonatomic, weak) id firstDelegate;
@property (nonatomic, weak) id secondDelegate;

+ (instancetype)containerDelegateWithFirst:(id)firstDelegate second:(id)secondDelegate;

@end
