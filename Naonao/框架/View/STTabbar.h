//
//  STTabbar.h
//  Naonao
//
//  Created by 刘敏 on 16/5/31.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)();

@interface STTabBar : UITabBar

@property (nonatomic, copy) ClickBlock clickBlock;

@end

