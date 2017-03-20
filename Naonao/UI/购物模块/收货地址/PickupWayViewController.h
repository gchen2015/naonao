//
//  PickupWayViewController.h
//  Naonao
//
//  Created by 刘敏 on 2016/9/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"

@class PickupWayViewController;
@protocol PickupWayViewControllerDelegate <NSObject>

- (void)pickView:(PickupWayViewController *)mView selectedCellRow:(NSInteger)mRow;

@end



@interface PickupWayViewController : STChildViewController

@property (nonatomic, weak) id<PickupWayViewControllerDelegate> delegate;
@end
