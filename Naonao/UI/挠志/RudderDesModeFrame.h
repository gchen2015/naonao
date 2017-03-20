//
//  RudderDesModeFrame.h
//  Naonao
//
//  Created by 刘敏 on 16/8/5.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagazineInfo.h"


@interface RudderDesModeFrame : NSObject

@property (nonatomic, strong) STDuozhu *sData;

@property (nonatomic, assign) CGRect relationshipFrame;
@property (nonatomic, assign) CGRect focusFrame;

@property (nonatomic, assign) CGRect nickFrame;
@property (nonatomic, assign) CGRect roleFrame;

@property (nonatomic, assign) CGRect desFrame;
@property (nonatomic, assign) CGRect scrollViewFrame;


@property (nonatomic, assign) CGFloat rowHeight;            //cell高度

@end
