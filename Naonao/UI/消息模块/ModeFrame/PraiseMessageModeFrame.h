//
//  PraiseMessageModeFrame.h
//  Naonao
//
//  Created by 刘敏 on 16/8/19.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMessagePraise.h"

@interface PraiseMessageModeFrame : NSObject

@property (nonatomic, strong) STMessagePraise *pMode;

@property (nonatomic, assign) CGRect nickNameFrame;
@property (nonatomic, assign) CGRect contentFrame;

@property (nonatomic, assign) CGRect commentsFrame;

@property (nonatomic, assign) CGRect picFrame;
@property (nonatomic, assign) CGRect numFrame;

@property (nonatomic, assign) CGRect desFrame;
@property (nonatomic, assign) CGRect lineVFrame;

@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end
