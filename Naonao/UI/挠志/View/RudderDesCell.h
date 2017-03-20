//
//  RudderDesCell.h
//  Naonao
//
//  Created by 刘敏 on 16/8/5.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RudderDesModeFrame.h"

@class RudderDesCell;

@protocol RudderDesCellDelegate <NSObject>

- (void)rudderDesCell:(RudderDesCell *)mView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface RudderDesCell : UITableViewCell

@property (nonatomic, weak) id<RudderDesCellDelegate> delegate;

@property (nonatomic, weak) RudderDesModeFrame *modeFrame;

+ (RudderDesCell *)cellWithTableView:(UITableView *)tableView;

@end
