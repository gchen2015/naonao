//
//  STCircleHeadView.m
//  MeeBra
//
//  Created by Richard Liu on 15/9/23.
//  Copyright © 2015年 广州杉川投资管理有限公司. All rights reserved.
//

#import "STCircleHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface STCircleHeadView ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *imageScrollView;
@property (nonatomic, weak) UIImageView *backImageView;

@property (nonatomic, weak) UILabel *titLabel;
@property (nonatomic, weak) UILabel *desLabel;

@end


static CGFloat kParallaxDeltaFactor = 0.5f;
static CGFloat kMaxTitleAlphaOffset = 100.0f;

@implementation STCircleHeadView

- (id)initWithFrame:(CGRect)frame
     backGroudImage:(NSString *)imageName
             isMask:(BOOL)isMask
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.imageScrollView = scrollView;
        [self addSubview:self.imageScrollView];
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.backImageView = backImageView;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        if (imageName) {
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[imageName originalImageTurnWebp]] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
        }
        
        
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageScrollView addSubview:self.backImageView];
        
        if (isMask) {
            CALayer *maskLayer = [CALayer layer];
            [maskLayer setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [maskLayer setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.25].CGColor];
            [self.imageScrollView.layer addSublayer:maskLayer];
        }

        
        
        
        CGRect labelRect = CGRectMake(0, CGRectGetHeight(self.imageScrollView.frame)/2 - 15, SCREEN_WIDTH, 30);
        UILabel *titLabel = [[UILabel alloc] initWithFrame:labelRect];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titLabel.autoresizingMask = _backImageView.autoresizingMask;
        titLabel.textColor = [UIColor whiteColor];
        titLabel.font = [UIFont boldSystemFontOfSize:17.0];
        self.titLabel = titLabel;
        [self.imageScrollView addSubview:self.titLabel];
        
        CGRect desRect = CGRectMake(0, CGRectGetHeight(self.imageScrollView.frame)/2 +15, SCREEN_WIDTH, 20);
        UILabel *desLabel = [[UILabel alloc] initWithFrame:desRect];
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.lineBreakMode = NSLineBreakByWordWrapping;
        desLabel.autoresizingMask = _backImageView.autoresizingMask;
        desLabel.textColor = [UIColor whiteColor];
        desLabel.font = [UIFont systemFontOfSize:13.0];
        self.desLabel = desLabel;
        [self.imageScrollView addSubview:self.desLabel];
        

        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset scrollView:(UIScrollView *)scrollView
{
    CGRect frame = self.imageScrollView.frame;
    
    if (offset.y > 0)
    {
        //上顶
        frame.origin.y = MAX(offset.y *kParallaxDeltaFactor, 0);
        self.imageScrollView.frame = frame;
        self.clipsToBounds = YES;
    }
    else
    {
        //下拉
        CGFloat delta = 0.0f;
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.imageScrollView.frame = rect;
        
        
        self.titLabel.alpha = 1 - (delta) * 1 / kMaxTitleAlphaOffset;
        self.desLabel.alpha = 1 - (delta) * 1 / kMaxTitleAlphaOffset;
        
        self.clipsToBounds = NO;
    }
}

- (void)setHeadImage:(NSString *)imageName
{
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[imageName originalImageTurnWebp]]
                          placeholderImage:[UIImage imageNamed:@"default_image.png"]];
}


- (void)setTitle:(NSString *)tit setDes:(NSString *)des
{
    [_titLabel setText:tit];
    [_desLabel setText:des];
}


@end
