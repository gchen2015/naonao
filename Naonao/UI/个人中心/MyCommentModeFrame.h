//
//  MyCommentModeFrame.h
//  Naonao
//
//  Created by 刘敏 on 16/8/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StorageAnswer.h"


@interface MyCommentModeFrame : NSObject

@property (nonatomic, strong) MY_C *sModel;

@property (nonatomic, assign) CGRect linvAFrame;
@property (nonatomic, assign) CGRect bigImageViewFrame;
@property (nonatomic, assign) CGRect desFrame;
@property (nonatomic, assign) CGRect headFrame;
@property (nonatomic, assign) CGRect timeFrame;

@property (nonatomic, assign) CGRect nickFrame;
@property (nonatomic, assign) CGRect tipFrame;
@property (nonatomic, assign) CGRect followFrame;

@property (nonatomic, assign) CGRect linvBFrame;
@property (nonatomic, assign) CGRect intervalFrame;

@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end
