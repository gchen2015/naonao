//
//  MessageFaceView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-12.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "ZBMessageManagerFaceView.h"


#define FaceSectionBarHeight  36   // 表情下面控件
#define FacePageControlHeight 30   // 表情pagecontrol

#define Pages 5

@implementation ZBMessageManagerFaceView
{
    UIPageControl *pageControl;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    _eArray = [[NSMutableArray alloc] init];

    UIImageView *lineV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_line"]];
    [lineV1 setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [self addSubview:lineV1];

    self.backgroundColor = [UIColor colorWithHex:0xfafafa];

    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f,20.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)-FacePageControlHeight-FaceSectionBarHeight)];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    [scrollView setPagingEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame)*Pages,CGRectGetHeight(scrollView.frame))];
    
    for (int i= 0;i<Pages;i++) {
        ZBFaceView *faceView = [[ZBFaceView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(self.bounds),0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(scrollView.bounds)) forIndexPath:i];
        [scrollView addSubview:faceView];
        faceView.delegate = self;
    }
    
    pageControl = [[UIPageControl alloc]init];
    [pageControl setFrame:CGRectMake(0,CGRectGetMaxY(scrollView.frame)+8,CGRectGetWidth(self.bounds),FacePageControlHeight)];
    [self addSubview:pageControl];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    pageControl.numberOfPages = Pages;
    pageControl.currentPage   = 0;

}

#pragma mark  scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/320;
    pageControl.currentPage = page;
    
}

#pragma mark ZBFaceView Delegate
- (void)didSelecteFace:(NSString *)faceName andIsSelecteDelete:(BOOL)del{
    if ([self.delegate respondsToSelector:@selector(SendTheFaceStr: isDelete:) ]) {
        
        if (faceName) {
            [_eArray addObject:faceName];
        }
        
        if (del && [_eArray count] > 0) {
            faceName = [NSString stringWithFormat:@"%@", [_eArray objectAtIndex:_eArray.count-1]];
            
        }
        
        
        [self.delegate SendTheFaceStr:faceName isDelete:del];
    }
}

@end
