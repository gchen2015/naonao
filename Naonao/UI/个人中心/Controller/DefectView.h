//
//  DefectView.h
//  LewPopupViewController
//
//  Created by 刘敏 on 16/6/15.
//  Copyright © 2016年 pljhonglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STShapeViewController;

@interface DefectView : UIView

@property (nonatomic, strong)IBOutlet UIView *innerView;
@property (nonatomic, weak) STShapeViewController *parentVC;


+ (instancetype)defaultPopupView;

@end


@interface DefectBtn : UIButton


@end
