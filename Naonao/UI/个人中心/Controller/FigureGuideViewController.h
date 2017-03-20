//
//  FigureGuideViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/6/13.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "SHLUILabel.h"

@interface FigureGuideViewController : STChildViewController

@property (weak, nonatomic) IBOutlet UILabel *labelA;
@property (weak, nonatomic) IBOutlet UILabel *labelB;

@property (weak, nonatomic) IBOutlet SHLUILabel *labelData;
@property (weak, nonatomic) IBOutlet SHLUILabel *labelC;

@property (nonatomic, assign) BOOL isPOP;


@end
