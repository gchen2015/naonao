//
//  DesModeView.m
//  Naonao
//
//  Created by 刘敏 on 16/3/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "DesModeView.h"
#import "SHLUILabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SJAvatarBrowser.h"

#define K_ImageW     SCREEN_WIDTH-28

@interface DesModeView ()

@property (nonatomic, weak) STMenuBtn *leftBtn;
@property (nonatomic, weak) STMenuBtn *rightBtn;

@property (nonatomic, weak) SHLUILabel *desLabel;
@property (nonatomic, weak) UIView *imageV;

@property (nonatomic, weak) UIImageView *sizeV;

@end

@implementation DesModeView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setUpChildView {
    
    STMenuBtn *leftBtn = [[STMenuBtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4-32, 20, 64, 64)
                                                 setTitle:@"详情介绍"
                                              normalImage:@"goods_icon12_nor.png"
                                            selectedImage:@"goods_icon12_sel"];
    _leftBtn = leftBtn;
    [self addSubview:_leftBtn];
    
    
    STMenuBtn *rightBtn =[[STMenuBtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4-32, 20, 64, 64)
                                                 setTitle:@"颜色尺寸"
                                              normalImage:@"goods_icon13_nor.png"
                                            selectedImage:@"goods_icon13_sel"];
    _rightBtn = rightBtn;
    
    [self addSubview:_rightBtn];
    
    
    SHLUILabel* desLabel = [[SHLUILabel alloc] init];
    _desLabel = desLabel;
    [_desLabel setTextColor:[UIColor grayColor]];
    [_desLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_desLabel setTextColor:[UIColor colorWithHex:0x626262]];
    _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _desLabel.numberOfLines = 0;
    _desLabel.paragraphSpacing = 3.5;
    [self addSubview:_desLabel];
    
    UIView *imageV = [[UIView alloc] init];
    _imageV = imageV;
    [_imageV setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_imageV];
    
    
    //科学计数法
    NSDecimalNumber *m_width = [NSDecimalNumber decimalNumberWithString:[[NSNumber numberWithInteger:SCREEN_WIDTH - 20] stringValue]];
    NSDecimalNumber *cof = [NSDecimalNumber decimalNumberWithString:[[NSNumber numberWithFloat:M_K] stringValue]];
    
    //除法
    NSDecimalNumber *m_height = [m_width decimalNumberByDividingBy:cof];
    UIImageView *sizeV = [[UIImageView alloc] initWithFrame:CGRectMake(7, 105, SCREEN_WIDTH - 20, m_height.floatValue)];
    _sizeV = sizeV;
    _sizeV.userInteractionEnabled = YES;
    //填充方式
    [_sizeV setContentMode:UIViewContentModeScaleAspectFit];
    _sizeV.layer.masksToBounds = YES;
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
    [_sizeV addGestureRecognizer:tapGesture];
    
    [self addSubview:_sizeV];
}

- (void)setDesFrame:(DesModeFrame *)desFrame
{
    _desFrame = desFrame;
    
    _leftBtn.frame = _desFrame.leftFrame;
    _rightBtn.frame = _desFrame.rightFrame;
    _desLabel.frame = _desFrame.desFrame;
    _imageV.frame = _desFrame.imageFrame;
    
    [self setChildViewData];

}

- (void)setIsLeft:(BOOL)isLeft {
    _isLeft = isLeft;
    
    if (_isLeft) {
        _leftBtn.selected = YES;
        _rightBtn.selected = NO;
        [_sizeV removeFromSuperview];
    }
    else
    {
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
        
        [self drawUI];
    }
}

- (void)drawUI {
    
    [_desLabel removeFromSuperview];
    [_imageV removeFromSuperview];
    
    if (_desFrame.sizeInfo.sizeArray.count > 0) {
        
        ImageM *mode = _desFrame.sizeInfo.sizeArray[0];
        [_sizeV sd_setImageWithURL:[NSURL URLWithString:[mode.url originalImageTurnWebp]] placeholderImage:[UIImage imageNamed:@"size.png"]];
    }
    else
        [_sizeV setImage:[UIImage imageNamed:@"size.png"]];
}


- (void)setChildViewData {
    [_leftBtn addTarget:self action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn addTarget:self action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_desLabel setText:_desFrame.desInfo.desc];
    
    CGFloat mH = 0.0;
    CGFloat nH = 0.0;
    
    for (ImageM *item in _desFrame.desInfo.imgArray) {
        
        //计算图片高度
        nH = [self calculateImageHigh:item];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, mH, K_ImageW, nH)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[item.url originalImageTurnWebp]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
        
        [_imageV addSubview:imageView];
        
        mH = mH + nH + 5.0;
    }
}

- (CGFloat)calculateImageHigh:(ImageM *)item
{
    //科学计数法，精确度高
    NSDecimalNumber *m_width = [NSDecimalNumber decimalNumberWithString:[item.width stringValue]];
    NSDecimalNumber *m_height = [NSDecimalNumber decimalNumberWithString:[item.height stringValue]];
    
    //系数
    NSDecimalNumber *cof = [m_width decimalNumberByDividingBy:m_height];
    
    NSDecimalNumber *mw = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.0f", K_ImageW]];
    
    NSDecimalNumber *mH = [mw decimalNumberByDividingBy:cof];
    
    
    return mH.floatValue;
}


- (void)leftBtnTapped:(STMenuBtn *)sender
{
    sender.selected = YES;
    _rightBtn.selected = NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(desModeView:updateUI:)]) {
        [_delegate desModeView:self updateUI:YES];
    }
}

- (void)rightBtnTapped:(STMenuBtn *)sender
{
    _leftBtn.selected = NO;
    sender.selected = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(desModeView:updateUI:)]) {
        [_delegate desModeView:self updateUI:NO];
    }
}

- (void)Actiondo:(UITapGestureRecognizer *)tapGesture
{
    [SJAvatarBrowser showImage:_sizeV];
}


@end



@interface STMenuBtn ()

@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) UIImageView *iconV;

@end

@implementation STMenuBtn

- (instancetype)initWithFrame:(CGRect)frame
                     setTitle:(NSString *)tit
                  normalImage:(NSString *)imageN
                selectedImage:(NSString *)imageS
{
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _iconV = iconV;
        [_iconV setImage:[UIImage imageNamed:imageN]];
        [_iconV setHighlightedImage:[UIImage imageNamed:imageS]];
        _iconV.center = CGPointMake(CGRectGetWidth(frame)/2, 18);
        //填充方式
        [_iconV setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_iconV];
        
        //标题
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        _titLabel = titLabel;
        [_titLabel setText:tit];
        [_titLabel setTextAlignment:NSTextAlignmentCenter];
        [_titLabel setTextColor:LIGHT_BLACK_COLOR];
        [_titLabel setFont:[UIFont systemFontOfSize:13.0]];
        _titLabel.center = CGPointMake(CGRectGetWidth(frame)/2, 45);
        [self addSubview:_titLabel];
        
        [self setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"ST_btn_7.png"] forState:UIControlStateSelected];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected
{
    if (selected) {
        [_titLabel setTextColor:[UIColor colorWithHex:0x595757 alpha:0.8]];
        [_iconV setHighlighted:YES];
    }
    else
    {
        [_titLabel setTextColor:LIGHT_BLACK_COLOR];
        [_iconV setHighlighted:NO];
    }
    
    [super setSelected:selected];
}

@end

