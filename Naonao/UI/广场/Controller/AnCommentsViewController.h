//
//  AnCommentsViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/6/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "AnswerMode.h"


@interface AnCommentsViewController : STChildViewController

@property (nonatomic, strong) AnswerMode *aMode;
@property (nonatomic, strong) NSNumber *orderID;

@end
