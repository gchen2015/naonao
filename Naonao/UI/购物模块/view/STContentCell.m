//
//  STContentCell.m
//  Naonao
//
//  Created by 刘敏 on 16/4/14.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STContentCell.h"
#import "SHLUILabel.h"

@interface STContentCell ()

@property (nonatomic, weak) STInterBtn *leftBtn;
@property (nonatomic, weak) STInterBtn *rightBtn;

@property (nonatomic, weak) SHLUILabel *desLabel;

@end

@implementation STContentCell


+ (STContentCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"STContentCell";
    
    STContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //删除重用
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    
    cell = [[STContentCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView
{
    STInterBtn *leftBtn = [[STInterBtn alloc] initWithFrame:CGRectMake(26, 0, SCREEN_WIDTH/2-26, 45)
                                                   setTitle:@"购物流程"
                                                normalImage:@"goods_icon14_nor.png"
                                              selectedImage:@"goods_icon14_sel.png"];
    _leftBtn = leftBtn;
    [_leftBtn addTarget:self action:@selector(leftBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_leftBtn];
    
    
    
    STInterBtn *rightBtn = [[STInterBtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5, 0, SCREEN_WIDTH/2-26, 45)
                                                    setTitle:@"购物保障"
                                                 normalImage:@"goods_icon15_nor.png"
                                               selectedImage:@"goods_icon15_sel.png"];
    _rightBtn = rightBtn;
    [_rightBtn addTarget:self action:@selector(rightBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_rightBtn];
    
    
    
    SHLUILabel* desLabel = [[SHLUILabel alloc] init];
    _desLabel = desLabel;
    [_desLabel setTextColor:[UIColor grayColor]];
    [_desLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_desLabel setTextColor:[UIColor colorWithHex:0x626262]];
    _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _desLabel.numberOfLines = 0;
    [self addSubview:_desLabel];
}

- (void)leftBtnTapped:(STInterBtn *)sender
{
    sender.selected = YES;
    _rightBtn.selected = NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateUI:)]) {
        [_delegate updateUI:YES];
    }
}

- (void)rightBtnTapped:(STInterBtn *)sender
{
    _leftBtn.selected = NO;
    sender.selected = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateUI:)]) {
        [_delegate updateUI:NO];
    }
}

- (CGFloat)setCellWithCellInfo:(BOOL)isLeft
{
    if (isLeft) {
        [_desLabel setText:K_Shop_Instructions];
        _leftBtn.selected = YES;
        _rightBtn.selected = NO;
    }
    else
    {
        [_desLabel setText:K_Good_Instructions];
        _leftBtn.selected = NO;
        _rightBtn.selected = YES;
    }

    //根据字符串长度和Label显示的宽度计算出contentLab的高
    int labelHeight = [_desLabel getAttributedStringHeightWidthValue:SCREEN_WIDTH-28];
    [_desLabel setFrame:CGRectMake(14, 65, SCREEN_WIDTH-28, labelHeight)];
    
    return labelHeight +85;
}


@end


@interface STInterBtn ()

@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) UIImageView *iconV;

@end

@implementation STInterBtn

- (instancetype)initWithFrame:(CGRect)frame
                     setTitle:(NSString *)tit
                  normalImage:(NSString *)imageN
                selectedImage:(NSString *)imageS
{
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _iconV = iconV;
        [_iconV setImage:[UIImage imageNamed:imageN]];
        [_iconV setHighlightedImage:[UIImage imageNamed:imageS]];
        _iconV.center = CGPointMake(CGRectGetWidth(frame)/2, self.center.y-8);

        [self addSubview:_iconV];
        
        //标题
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        _titLabel = titLabel;
        [_titLabel setText:tit];
        [_titLabel setTextAlignment:NSTextAlignmentCenter];
        [_titLabel setTextColor:LIGHT_BLACK_COLOR];
        [_titLabel setFont:[UIFont systemFontOfSize:11.0]];
        _titLabel.center = CGPointMake(CGRectGetWidth(frame)/2, self.center.y+10);
        [self addSubview:_titLabel];
        
        
        [self setBackgroundColor:[UIColor whiteColor]];

        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected
{
    if (selected) {
        [_iconV setHighlighted:YES];
        [_titLabel setTextColor:BLACK_COLOR];
    }
    else
    {
        [_iconV setHighlighted:NO];
        [_titLabel setTextColor:LIGHT_BLACK_COLOR];
    }
    
    [super setSelected:selected];
}

@end

