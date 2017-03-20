//
//  STBodyView.m
//  Naonao
//
//  Created by 刘敏 on 16/6/15.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STBodyView.h"
#import "STRuler.h"
#import "ChestRuler.h"
#import "User.h"
#import "UserLogic.h"


@interface STBodyView ()<STRulerDelegate, ChestRulerDelegate>

@property (weak, nonatomic) UILabel *mName;
@property (weak, nonatomic) STRuler *mRuler;
@property (weak, nonatomic) UILabel *showLabel;
@property (nonatomic, assign) NSInteger mRow;

@property (nonatomic, strong) NSArray *bustArray;       //胸围尺码表

@end

@implementation STBodyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView
{
    UILabel *mName = [[UILabel alloc] initWithFrame:CGRectMake(30, 17, 150, 20)];
    _mName = mName;
    [_mName setFont:[UIFont systemFontOfSize:14.0]];
    [_mName setTextColor:LIGHT_BLACK_COLOR];
    [self addSubview:_mName];
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, SCREEN_WIDTH - 60, 30)];
    _showLabel = showLabel;
    [_showLabel setTextAlignment:NSTextAlignmentCenter];
    [_showLabel setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:24.0]];
    [_showLabel setTextColor:BLACK_COLOR];
    [self addSubview:_showLabel];
    
    
    _bustArray = [NSArray arrayWithObjects:@"70A", @"70B", @"70C", @"70D", @"75A", @"75B", @"75C", @"75D", @"75E", @"80A", @"80B", @"80C",
                          @"80D", @"80E", @"85A", @"85B", @"85C", @"85D", @"85E", @"90B", @"90C", @"90D", @"90E", nil];
    
}

- (void)setCellWithCellInfo:(NSInteger)row
{
    _mRow = row;
    
    if (_mRow == 3) {
        ChestRuler *cRuler = [[ChestRuler alloc] initWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 46)];
        cRuler.deletate = self;
        //设置圆角
        cRuler.layer.cornerRadius = 12;
        cRuler.layer.masksToBounds = YES;
        cRuler.layer.borderColor = [UIColor grayColor].CGColor;
        cRuler.layer.borderWidth = 0.5;
        
        [_mName setText:@"胸围（国际尺码）"];
        [cRuler showRulerScrollViewWithCount:_bustArray.count-1 dataArray:_bustArray average:[NSNumber numberWithFloat:1] currentValue:7.f];
        
        [self addSubview:cRuler];
        
        UIImageView *pV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_bar.png"]];
        [pV setFrame:CGRectMake(0, 0, 13, 61)];
        pV.center = cRuler.center;
        [self addSubview:pV];
        
    }
    else{
        STRuler *mRuler = [[STRuler alloc] initWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 46)];
        _mRuler = mRuler;
        _mRuler.deletate = self;
        //设置圆角
        _mRuler.layer.cornerRadius = 12;
        _mRuler.layer.masksToBounds = YES;
        _mRuler.layer.borderColor = [UIColor grayColor].CGColor;
        _mRuler.layer.borderWidth = 0.5;
        
        
        switch (_mRow) {
            case 0:
                [_mName setText:@"你是生于？"];
                [_mRuler showRulerScrollViewWithStartCount:1950 count:60 average:[NSNumber numberWithFloat:1] currentValue:40.f];
                break;
                
            case 1:
                [_mName setText:@"体重"];
                [_mRuler showRulerScrollViewWithStartCount:30 count:90 average:[NSNumber numberWithFloat:1] currentValue:20.f];
                break;
                
            case 2:
                [_mName setText:@"身高"];
                [_mRuler showRulerScrollViewWithStartCount:120 count:90 average:[NSNumber numberWithFloat:1] currentValue:45.f];
                break;

            case 4:
                [_mName setText:@"腰围"];
                [_mRuler showRulerScrollViewWithStartCount:40 count:80 average:[NSNumber numberWithFloat:1] currentValue:20.f];
                break;
                
                
            case 5:
                [_mName setText:@"臀围"];
                [_mRuler showRulerScrollViewWithStartCount:40 count:80 average:[NSNumber numberWithFloat:1] currentValue:30.f];
                break;
                
            case 6:
                [_mName setText:@"鞋码"];
                [_mRuler showRulerScrollViewWithStartCount:20 count:30 average:[NSNumber numberWithFloat:1] currentValue:17.f];
                break;
                
            default:
                break;
        }
        
        [self addSubview:_mRuler];
        
        UIImageView *pV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_bar.png"]];
        [pV setFrame:CGRectMake(0, 0, 13, 61)];
        pV.center = _mRuler.center;
        [self addSubview:pV];
    }

}


#pragma mark - STRulerDelegate
- (void)ruler:(STRulerScrollView *)rulerScrollView{
    UserBody *uBody = [UserLogic sharedInstance].uBody;
    
    switch (_mRow) {
        case 0:
        {
            NSInteger year = rulerScrollView.rulerValue+rulerScrollView.startValue;
            //十位
            NSInteger mT = year%100;
            mT = mT/10;
            
            
            //个位
            NSInteger mBit = year%10;
            if(mBit >= 5)
            {
                mBit = 5;
            }
            else
                mBit = 0;
            
            
            //年代
            NSString *st = [NSString stringWithFormat:@"%ld%ld 后", (long)mT, (long)mBit];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
            [str addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:NSMakeRange(st.length-1, 1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(st.length-1, 1)];
            _showLabel.attributedText = str;
            
            uBody.lifeStage = [NSString stringWithFormat:@"%ld%ld", (long)mT, (long)mBit];

        }
            break;
            
        case 1:
        {
            //体重
            NSString *st = [NSString stringWithFormat:@"%.f kg", rulerScrollView.rulerValue+rulerScrollView.startValue];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
            [str addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:NSMakeRange(st.length-2, 2)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(st.length-2, 2)];
            _showLabel.attributedText = str;
            
            uBody.weight = [NSNumber numberWithInteger:rulerScrollView.rulerValue+rulerScrollView.startValue];
        }
            break;
            
        case 2:
        {
            //身高
            NSString *st = [NSString stringWithFormat:@"%.f cm", rulerScrollView.rulerValue+rulerScrollView.startValue];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
            [str addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:NSMakeRange(st.length-2, 2)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(st.length-2, 2)];
            _showLabel.attributedText = str;
            
            
            uBody.height = [NSNumber numberWithInteger:rulerScrollView.rulerValue+rulerScrollView.startValue];
        }
            break;
            
            
        case 4:
        {
            //腰围
            NSString *st = [NSString stringWithFormat:@"%.f cm", rulerScrollView.rulerValue+rulerScrollView.startValue];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
            [str addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:NSMakeRange(st.length-2, 2)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(st.length-2, 2)];
            _showLabel.attributedText = str;
            
            uBody.waistline = [NSNumber numberWithInteger:rulerScrollView.rulerValue+rulerScrollView.startValue];
        }
            break;
            
        case 5:
        {
            //臀围
            NSString *st = [NSString stringWithFormat:@"%.f cm", rulerScrollView.rulerValue+rulerScrollView.startValue];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
            [str addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:NSMakeRange(st.length-2, 2)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(st.length-2, 2)];
            _showLabel.attributedText = str;
            
            uBody.hipline = [NSNumber numberWithInteger:rulerScrollView.rulerValue+rulerScrollView.startValue];
        }
            break;
            
        case 6:
        {
            //鞋码
            NSString *st = [NSString stringWithFormat:@"%.f 码", rulerScrollView.rulerValue+rulerScrollView.startValue];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
            [str addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:NSMakeRange(st.length-1, 1)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(st.length-1, 1)];
            _showLabel.attributedText = str;
            
            uBody.shoes = [NSNumber numberWithInteger:rulerScrollView.rulerValue+rulerScrollView.startValue];
        }
            
            
            break;
            
        default:
            break;
    }
}

#pragma mark -ChestRulerDelegate
- (void)chestRuler:(ChestScrollView *)rulerScrollView
{
    //胸围专用
    UserBody *uBody = [UserLogic sharedInstance].uBody;
    uBody.bust = [_bustArray objectAtIndex:rulerScrollView.rulerValue];
    
    
    NSString *headS = [uBody.bust substringWithRange:NSMakeRange(0, uBody.bust.length-1)];
    NSString *tailS = [uBody.bust substringWithRange:NSMakeRange(uBody.bust.length-1, 1)];
    
    // 插入空格
    NSString *st = [NSString stringWithFormat:@"%@ %@", headS, tailS];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
    [str addAttribute:NSForegroundColorAttributeName value:BLACK_COLOR range:NSMakeRange(st.length-1, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(st.length-1, 1)];
    _showLabel.attributedText = str;
    
}

@end
