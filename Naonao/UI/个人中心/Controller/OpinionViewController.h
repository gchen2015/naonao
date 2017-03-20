//
//  OpinionViewController.h
//  Naonao
//
//  Created by Richard Liu on 15/12/14.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "TapScrollView.h"
#import "BRPlaceholderTextView.h"

@interface OpinionViewController : STChildViewController

@property (nonatomic, weak) IBOutlet TapScrollView *scrollView;
@property (nonatomic, weak) IBOutlet BRPlaceholderTextView *textView;

@end
