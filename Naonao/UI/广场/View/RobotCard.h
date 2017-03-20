//
//  RobotCard.h
//  Naonao
//
//  Created by 刘敏 on 16/7/24.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareModel.h"
#import "SHLUILabel.h"


@interface RobotCard : UIView

@property (nonatomic, weak) IBOutlet UIImageView *goodsV;

@property (nonatomic, weak) IBOutlet UILabel *nameL;
@property (nonatomic, weak) IBOutlet UILabel *priceL;
@property (nonatomic, weak) IBOutlet UILabel *sysL;
@property (nonatomic, weak) IBOutlet SHLUILabel *contentL;

- (void)setCradInfo:(RecommandDAO *)rInfo;

@end
