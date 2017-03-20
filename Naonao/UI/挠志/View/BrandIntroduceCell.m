//
//  BrandIntroduceCell.m
//  Naonao
//
//  Created by 刘敏 on 2016/10/9.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "BrandIntroduceCell.h"
#import "SHLUILabel.h"
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface BrandIntroduceCell ()

@property (nonatomic, weak) UILabel *nameL;             //品牌（店铺）名称
@property (nonatomic, weak) SHLUILabel *desL;           //品牌详情介绍
@property (nonatomic, weak) UIView *picView;

@end


@implementation BrandIntroduceCell

+ (BrandIntroduceCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"BrandIntroduceCell";
    
    BrandIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[BrandIntroduceCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView{
    
    //品牌名称
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 52, SCREEN_WIDTH - 30, 25)];
    _nameL = nameL;
    [_nameL setTextColor:BLACK_COLOR];
    [_nameL setTextAlignment:NSTextAlignmentCenter];
    [_nameL setFont:[UIFont boldSystemFontOfSize:20.0]];
    [self.contentView addSubview:_nameL];
    
    //品牌详情
    SHLUILabel *desL = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    _desL = desL;
    _desL.numberOfLines = 0;
    [_desL setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightLight]];
    [_desL setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_desL];

    UIView *picView = [[UIView alloc] initWithFrame:CGRectZero];
    _picView = picView;
    [self.contentView addSubview:_picView];
    
}

- (void)setCellWithCellInfo:(STBrand *)topic
{
    [_nameL setText:topic.content.name];
    [_desL setText:topic.content.story];

    CGFloat mH = [_desL getAttributedStringHeightWidthValue:SCREEN_WIDTH - 28];
    _desL.frame = CGRectMake(14, CGRectGetMaxY(_nameL.frame)+22, SCREEN_WIDTH-28, mH);
    
    CGFloat pic_H = 0.0;
    
    if (topic.content.brandArray.count > 0){
        pic_H = 20.0;
    }
    
    int i = 1000;
    for (NSString *imageS in topic.content.brandArray) {
        CLog(@"图片地址：%@", imageS);
        
        UIImageView *imageV = (UIImageView *)[_picView viewWithTag:i];
        if (!imageV) {
            imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, pic_H, SCREEN_WIDTH-28, (SCREEN_WIDTH-28)*0.5)];
            [imageV setTag:i];
            if ([imageS hasSuffix:@"gif"]){
                [imageV setImage:[UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageS]]]];
            }
            else{
                [imageV sd_setImageWithURL:[NSURL URLWithString:imageS] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
            }
            
            [_picView addSubview:imageV];
            //填充方式
            [imageV setContentMode:UIViewContentModeScaleAspectFill];
            imageV.layer.masksToBounds = YES;
        }

        pic_H = CGRectGetMaxY(imageV.frame)+4;
        i++;
    }
    
    [_picView setFrame:CGRectMake(14, CGRectGetMaxY(_desL.frame), SCREEN_WIDTH-28, pic_H)];
}

- (CGFloat)height {
    [self layoutIfNeeded];
    
    return CGRectGetMaxY(_picView.frame) + 20;
}

@end
