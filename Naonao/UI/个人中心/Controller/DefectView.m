//
//  DefectView.m
//  LewPopupViewController
//
//  Created by 刘敏 on 16/6/15.
//  Copyright © 2016年 pljhonglu. All rights reserved.
//

#import "DefectView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "DemandLogic.h"
#import "DemandMenu.h"
#import "STShapeViewController.h"
#import "UserLogic.h"


@interface DefectView ()

@property (nonatomic, strong) NSArray *defectArray;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) NSMutableArray *cacheArray;      //存储身材缺陷

@end


@implementation DefectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _cacheArray = [[NSMutableArray alloc] init];
        
        
        [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
        _innerView.frame = frame;
        [self addSubview:_innerView];
        
        //圆角
        _innerView.layer.cornerRadius = 6;                     //设置那个圆角的有多圆
        _innerView.layer.masksToBounds = YES;                  //设为NO去试试
        _innerView.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
        _innerView.layer.borderWidth = 0.5;
        
        
        _sureBtn.layer.cornerRadius = 16;                     //设置那个圆角的有多圆
        _sureBtn.layer.masksToBounds = YES;                  //设为NO去试试
        
        _defectArray = [DemandLogic sharedInstance].demandMenu.bodyDefectArray;
        
        for (int i = 0; i<_defectArray.count; i++) {
            bodyDefectModel *bMode = _defectArray[i];
            
            NSUInteger xff = i%2;
            NSUInteger yff = i/2;
            
            
            DefectBtn *btn = [[DefectBtn alloc] initWithFrame:CGRectMake(30+xff*125, 65+yff*41, 75, 25)];
            [btn setTitle:bMode.name forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:(100+[bMode.mId integerValue])];
            
            [self addSubview:btn];
        }

    }
    return self;
}


+ (instancetype)defaultPopupView{
    return [[DefectView alloc]initWithFrame:CGRectMake(0, 0, 260, 370)];
}

- (IBAction)closeBtnTapped:(id)sender{
    [_parentVC lew_dismissPopupView];
}

- (void)btnTapped:(DefectBtn *)sender{
    sender.selected = !sender.selected;
    
    NSUInteger tag = sender.tag -100;
    
    if (tag == KBodyCharacterNone) {
        //其他身材缺陷都清空
        for (NSNumber *item in _cacheArray) {
            UIButton *btn = (DefectBtn *)[self viewWithTag:[item integerValue]+100];
            btn.selected = NO;
        }
        
        //删除
        [_cacheArray removeAllObjects];
    }
    else{
        //大胸跟平胸不能共存
        if (tag == KBigChest) {
            for (NSNumber *item in _cacheArray) {
                if ([item integerValue] == KFlatChest) {
                    //删除
                    [_cacheArray removeObject:item];
                    UIButton *btn = (DefectBtn *)[self viewWithTag:KFlatChest+100];
                    btn.selected = NO;
                    break;
                }
            }
        }
        
        if (tag == KFlatChest) {
            for (NSNumber *item in _cacheArray) {
                if ([item integerValue] == KBigChest) {
                    //删除
                    [_cacheArray removeObject:item];
                    
                    UIButton *btn = (DefectBtn *)[self viewWithTag:KBigChest+100];
                    btn.selected = NO;
                    break;
                }
            }
        }
        
        //清空 无缺陷标签
        for (NSNumber *item in _cacheArray) {
            if ([item integerValue] == KBodyCharacterNone) {
                //删除
                [_cacheArray removeObject:item];
                
                UIButton *btn = (DefectBtn *)[self viewWithTag:KBodyCharacterNone+100];
                btn.selected = NO;
                break;
            }
        }
        
    }

    if (sender.selected) {
        [_cacheArray addObject:[NSNumber numberWithInteger:tag]];
    }
    else
    {
        for (NSNumber *item in _cacheArray) {
            if ([item integerValue] == tag) {
                [_cacheArray removeObject:item];
                return;
            }
        }
    }
 
}

- (IBAction)sureBtnTapped:(id)sender{
    if (_cacheArray.count == 0) {
        [theAppDelegate.window makeToast:@"身材特点不能为空"];
        return;
    }
    
    //传递身材缺陷
    [UserLogic sharedInstance].uBody.bodydefect = _cacheArray;
    
    //隐藏弹出框
    _parentVC.isDefect = YES;
    
    [_parentVC lew_dismissPopupView];
}

@end



@implementation DefectBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        self.layer.cornerRadius = 4;                     //设置那个圆角的有多圆
        self.layer.masksToBounds = YES;                  //设为NO去试试
        self.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
        self.layer.borderWidth = 1;
        
        
    }
    
    return self;
}

- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    //选中
    if (selected) {
        [self setTitleColor:PINK_COLOR forState:UIControlStateNormal];
        self.layer.borderColor = PINK_COLOR.CGColor;
    }
    else
    {
        [self setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        self.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    }
}

@end
