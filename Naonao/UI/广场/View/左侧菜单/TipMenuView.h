//
//  TipMenuView.h
//  Naonao
//
//  Created by 刘敏 on 16/7/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipMenuView : UIView

- (CGFloat)setMenuWithskuMenuData:(NSArray *)array titleN:(NSString *)titS tag:(NSUInteger)index;

//还原（重置）
- (void)reductionMenuView;

@end
