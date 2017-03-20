//
//  STPopupView.m
//  Naonao
//
//  Created by 刘敏 on 16/7/6.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STPopupView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "UserCenterViewController.h"
#import "InterestModel.h"
#import "DemandMenu.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface STPopupView ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation STPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
        
        //圆角
        _innerView.layer.cornerRadius = 6;                     //设置那个圆角的有多圆
        _innerView.layer.masksToBounds = YES;                  //设为NO去试试
        _innerView.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
        _innerView.layer.borderWidth = 0.5;
        
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [_scrollView setContentSize:CGSizeMake(10+80*_dataArray.count, 116)];
    
    for (int i = 0; i < _dataArray.count; i++) {
        
        InterestModel *pM = [[InterestModel alloc] init];
        UIImageView *mv = [[UIImageView alloc] initWithFrame:CGRectMake(15+80*i, 10, 60, 60)];
        
        if ([[_dataArray objectAtIndex:i] isKindOfClass:[InterestModel class]]) {
            pM = [_dataArray objectAtIndex:i];
            [mv sd_setImageWithURL:[NSURL URLWithString:pM.icon] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
        }
        else if ([[_dataArray objectAtIndex:i] isKindOfClass:[styleModel class]]) {
            styleModel *sm = [_dataArray objectAtIndex:i];
            pM.name = sm.name;
            pM.icon = sm.icon;
            [mv setImage:[UIImage imageNamed:pM.icon]];
        }

        
        
        //圆角
        mv.layer.cornerRadius = CGRectGetWidth(mv.frame)/2; //设置那个圆角的有多圆
        mv.layer.masksToBounds = YES;  //设为NO去试试
        mv.layer.borderWidth = 0.3;
        mv.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;

        
        UILabel *lA = [[UILabel alloc] initWithFrame:CGRectMake(15+80*i, 80, 60, 15)];
        [lA setText:pM.name];
        [lA setTextColor:BLACK_COLOR];
        [lA setFont:[UIFont systemFontOfSize:14.0]];
        [lA setTextAlignment:NSTextAlignmentCenter];
        
        [_scrollView addSubview:lA];
        
        [_scrollView addSubview:mv];
    }
    
    

}



+ (instancetype)defaultPopupView{
    return [[STPopupView alloc]initWithFrame:CGRectMake(0, 0, 260, 164)];
}

- (IBAction)closeBtnTapped:(id)sender{
    [_parentVC lew_dismissPopupView];
}

@end
