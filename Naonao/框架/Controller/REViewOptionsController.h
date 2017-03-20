//
//  REViewOptionsController.h
//  Naonao
//
//  Created by Richard Liu on 15/11/24.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "RETableViewManager.h"

@interface REViewOptionsController : STChildViewController <RETableViewManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (weak, readwrite, nonatomic) RETableViewItem *item;
@property (strong, readwrite, nonatomic) NSArray *options;
@property (strong, readonly, nonatomic) RETableViewManager *tableViewManager;
@property (strong, readonly, nonatomic) RETableViewSection *mainSection;
@property (assign, readwrite, nonatomic) BOOL multipleChoice;
@property (copy, readwrite, nonatomic) void (^completionHandler)(void);
@property (strong, readwrite, nonatomic) RETableViewCellStyle *style;
@property (weak, readwrite, nonatomic) id<RETableViewManagerDelegate> delegate;

- (id)initWithItem:(RETableViewItem *)item
           options:(NSArray *)options
    multipleChoice:(BOOL)multipleChoice
 completionHandler:(void(^)(void))completionHandler;


@end
