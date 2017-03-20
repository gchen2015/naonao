//
//  GoodsResultsViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "GoodsResultsViewController.h"
#import "SegmentViewController.h"
#import "ExampleViewController.h"
#import "DemandLogic.h"


@interface GoodsResultsViewController ()

@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *arrayTittles;


@end

@implementation GoodsResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavBarTitle:@"选择商品"];
    
    [self getProductCategory];
    
    SegmentViewController *vc = [[SegmentViewController alloc] init];
    vc.titleArray = _arrayTittles;
    NSMutableArray *controlArray = [[NSMutableArray alloc]init];
    
    //临时存储文字宽度
    CGFloat mW = 0.0;
    
    for (int i = 0; i < vc.titleArray.count; i ++) {
        bodyDefectModel *body = _categoryArray[i];
        
        ExampleViewController *vc = [[ExampleViewController alloc] initWithIndex:i categoryId:body.mId orderId:_orderInfo.orderId];
        [controlArray addObject:vc];
        
        //计算字符长度
        NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0]};
        CGSize titleSize = [_arrayTittles[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 40)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:attrs
                                                          context:nil].size;
        
        if (i == 0) {
            mW = titleSize.width;
        }
        else
        {
            if (titleSize.width > mW) {
                mW = titleSize.width;
            }
        }
    }
    
    mW += 30.0f;
    vc.titleSelectedColor = PINK_COLOR;
    vc.subViewControllers = controlArray;
    
    if(mW < SCREEN_WIDTH/_arrayTittles.count)
    {
        mW = SCREEN_WIDTH/_arrayTittles.count;
    }
    
    vc.buttonWidth = mW;
    vc.buttonHeight = 40;
    [vc initSegment];
    [vc addParentController:self];

}


- (void)getProductCategory{
    NSArray *sA = [DemandLogic sharedInstance].demandMenu.subCategoryArray;
    
    _categoryArray = [NSMutableArray arrayWithCapacity:0];
    _arrayTittles = [NSMutableArray arrayWithCapacity:0];
    
    for (bodyDefectModel *body in sA) {
        NSUInteger categoryID = [body.mId integerValue]/100;
        if (categoryID == [_orderInfo.categoryId integerValue]) {
            [_categoryArray addObject:body];
            
            [_arrayTittles addObject:body.name];
        }
    }
    
}

@end
