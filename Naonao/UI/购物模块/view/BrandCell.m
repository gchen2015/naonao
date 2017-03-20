//
//  BrandCell.m
//  Naonao
//
//  Created by 刘敏 on 16/3/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "BrandCell.h"
#import "MLEmojiLabel.h"

@interface BrandCell ()

@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) MLEmojiLabel *desLabel;
@property (nonatomic, weak) UILabel *lineV;

@end


@implementation BrandCell

+ (BrandCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"BrandCell";
    
    BrandCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BrandCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
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
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 30, SCREEN_WIDTH-28, 20)];
    _titLabel = titLabel;
    [_titLabel setTextAlignment:NSTextAlignmentCenter];
    [_titLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [_titLabel setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_titLabel];
    
    
    MLEmojiLabel *desLabel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    _desLabel = desLabel;
    _desLabel.numberOfLines = 3;
    _desLabel.font = [UIFont systemFontOfSize:14.0];
    _desLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _desLabel.customEmojiPlistName = @"MLEmoji_ExpressionImage";
    _desLabel.textAlignment = NSTextAlignmentLeft;
    _desLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    [_desLabel setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
    _desLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_desLabel];
    
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineV = lineV;
    [_lineV setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [self.contentView addSubview:_lineV];
    
    
    //按钮
    UIButton *brandBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 29, 80, 25)];
    UIImage *imageA = [UIImage imageNamed:@"icon_arrow_right.png"];
    [brandBtn setImage:imageA forState:UIControlStateNormal];
    [brandBtn setTitle:@"品牌详情" forState:UIControlStateNormal];
    [brandBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    [brandBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    
    [brandBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, imageA.size.width)];
    [brandBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
    
    [brandBtn addTarget:self action:@selector(brandBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:brandBtn];
}


- (void)setCellWithCellInfo:(BrandInfo *)bInfo
{
    NSString *st = [NSString stringWithFormat:@"  %@  ", bInfo.en_name];
    // 创建一个富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:st];

    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"brand_point.png"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, 3, 5, 5);

    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    //插入到首位
    [attri insertAttributedString:string atIndex:0];
    //添加到尾部
    [attri appendAttributedString:string];
    
    // 用label的attributedText属性来使用富文本
    _titLabel.attributedText = attri;
    
    [_desLabel setText:bInfo.story];
    CGSize size = [_desLabel preferredSizeWithMaxWidth:SCREEN_WIDTH-28];
    

    //根据字符串长度和Label显示的宽度计算出contentLab的高
    [_desLabel setFrame:CGRectMake(14, CGRectGetMaxY(_titLabel.frame)+14, SCREEN_WIDTH-28, size.height)];

    [_lineV setFrame:CGRectMake(14, CGRectGetMaxY(_desLabel.frame)+29.5, SCREEN_WIDTH-28, 0.5)];
}


- (void)brandBtnTapped:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(brandCellJumpToBrandDetails)]) {
        [_delegate brandCellJumpToBrandDetails];
    }
}

@end
