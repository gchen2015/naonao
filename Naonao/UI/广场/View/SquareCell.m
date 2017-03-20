//
//  SquareCell.m
//  Naonao
//
//  Created by 刘敏 on 16/5/31.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "SquareCell.h"
#import "TimeUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MLEmojiLabel.h"

@interface SquareCell ()
@property (nonatomic, weak) UIImageView *quotesV;
@property (nonatomic, weak) UILabel *numLabel;
@property (nonatomic, weak) MLEmojiLabel *contentL;          //问题
@property (nonatomic, weak) UIImageView *rightV;
@property (nonatomic, weak) UILabel *desLabel;             //品类、场景、风格

@end

@implementation SquareCell


+ (SquareCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"SquareCell";
    
    SquareCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell = [[SquareCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIImageView *quotesV = [[UIImageView alloc] initWithFrame:CGRectMake(14, 13, 17.5, 16)];
    _quotesV = quotesV;
    [_quotesV setImage:[UIImage imageNamed:@"quotes.png"]];
    [self.contentView addSubview:_quotesV];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 16, 100, 15)];
    _numLabel = numLabel;
    [_numLabel setFont:[UIFont systemFontOfSize:11.0]];
    [_numLabel setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_numLabel];
    
    MLEmojiLabel *contentL = [[MLEmojiLabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(_quotesV.frame)+13, SCREEN_WIDTH - 142, 50)];
    _contentL = contentL;
    _contentL.numberOfLines = 0;
    [_contentL setFont:[UIFont systemFontOfSize:16.0]];
    [_contentL setTextColor:BLACK_COLOR];
    _contentL.backgroundColor = [UIColor clearColor];
    _contentL.userInteractionEnabled = NO;
    _contentL.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;

    [self.contentView addSubview:_contentL];

    
    UIImageView *rightV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 118, 16, 103, 103)];
    _rightV = rightV;
    //填充方式
    [_rightV setContentMode:UIViewContentModeScaleAspectFill];
    _rightV.layer.masksToBounds = YES;
    [self.contentView addSubview:_rightV];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 100, 200, 18)];
    _desLabel = desLabel;
    [_desLabel setFont:[UIFont systemFontOfSize:11.0 weight:UIFontWeightLight]];
    [_desLabel setTextColor:GARY_COLOR];
    [_desLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_desLabel];
    
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 134.5, SCREEN_WIDTH, 0.5)];
    lineV.backgroundColor = STROKE_GARY_COLOR;
    [self.contentView addSubview:lineV];
}


- (void)setCellWithCellInfo:(SquareModel *)model {
    [_numLabel setText:[NSString stringWithFormat:@"%@个答案", model.answerInfo.num]];
    [_contentL setText:model.orderInfo.content];

    CGSize mSize = [_contentL preferredSizeWithMaxWidth:(SCREEN_WIDTH - 142)];
    if (mSize.height < 25) {
        [_contentL setFrame:CGRectMake(14, CGRectGetMaxY(_quotesV.frame)+13, SCREEN_WIDTH - 142, 25)];
    }

    [_rightV setImageWithURL:[NSURL URLWithString:[model.orderInfo.orderImg smallHead]] placeholderImage:[UIImage imageNamed:@"default_image.png"] animate:YES];
    [_desLabel setText:model.orderInfo.summarize];
}


@end
