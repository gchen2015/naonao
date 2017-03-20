//
//  FlipTableView.h
//  Naonao
//
//  Created by 刘敏 on 16/3/25.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipTableViewDelegate <NSObject>

// 滑动回调，对应的下标（从1开始）
- (void)scrollChangeToIndex:(NSInteger)index;

@end

@interface FlipTableView : UIView<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
// 存放对应的内容控制器
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) id<FlipTableViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)contentArray;

// 手动选中某个页面
- (void)selectIndex:(NSInteger)index;

@end
