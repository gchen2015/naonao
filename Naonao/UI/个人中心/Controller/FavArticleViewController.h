//
//  FavArticleViewController.h
//  Naonao
//
//  Created by 刘敏 on 16/8/1.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoritesViewController;  

@interface FavArticleViewController : UITableViewController

@property (nonatomic, weak) FavoritesViewController *rootVC;

@end
