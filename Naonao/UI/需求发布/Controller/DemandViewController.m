//
//  DemandViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/15.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "DemandViewController.h"
#import "RequirementViewController.h"
#import "MenuScrollView.h"
#import "DemandLogic.h"
#import "DemandMenu.h"
#import "UIImage+UIImageScale.h"
#import "UIImage+KIAdditions.h"

@class ST_NNReqData;
@interface DemandViewController ()<MenuScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *SceneView;        //场景
@property (weak, nonatomic) IBOutlet UIImageView *StyleView;        //风格

@property (nonatomic, weak) MenuScrollView *categoryMenu;           //品类
@property (nonatomic, weak) MenuScrollView *sceneMenu;              //场景
@property (nonatomic, weak) MenuScrollView *styleMenu;              //风格

@property (nonatomic, weak) UIImageView *categoryView;              //品类

@property (assign, nonatomic) TagSelectionStage selectionStage;

@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, strong) NSArray *styleArray;                  //风格

@end


@implementation DemandViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"选择品类"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //状态栏遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [_SceneView setContentMode:UIViewContentModeScaleAspectFit];
    [_StyleView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 46, 44)];
    _backBtn = backBtn;
    [_backBtn setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"icon_close_highlighted.png"] forState:UIControlStateHighlighted];
    [_backBtn setImage:[UIImage imageNamed:@"icon_close_highlighted.png"] forState:UIControlStateSelected];
    [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.navbar addSubview:_backBtn];
    
    [self setNavBarLeftBtn:nil];
    [self setupTagScrollView];
    _selectionStage = kTagSelectionStateCategory;
    
    //品类
    UIImageView *categoryView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame)+20, SCREEN_WIDTH, SCREEN_HEIGHT - 84 -110)];
    _categoryView = categoryView;
    [_categoryView setImage:[UIImage imageNamed:@"category_0.png"]];
    //填充方式
    [_categoryView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_categoryView];
}

- (void)setupTagScrollView {
    _sceneMenu = [self setupScrollView:kTagSelectionStateScene];
    _categoryMenu = [self setupScrollView:kTagSelectionStateCategory];
}

- (MenuScrollView *)setupScrollView:(TagSelectionStage)selectionStage {
    
    NSArray *mArray = nil;
    CGRect scrollViewRect = CGRectMake(0, SCREEN_HEIGHT- 90, SCREEN_WIDTH, 86);
    
    switch (selectionStage) {
        case kTagSelectionStateCategory:
            mArray = [DemandLogic sharedInstance].categoryArray;
            break;
            
        case kTagSelectionStateScene:
            mArray = [DemandLogic sharedInstance].sceneArray;
            break;
        case kTagSelectionStageStyle:
            mArray = _styleArray;
            break;
            
        default:
            break;
    }
    
    MenuScrollView* scrollView = [[MenuScrollView alloc] initWithFrame:scrollViewRect setArray:mArray tag:selectionStage];
    scrollView.mDelegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    
    scrollView.contentSize = CGSizeMake(12+80*mArray.count, 86);
    
    return scrollView;
}


- (void)back:(id)sender {
    Requirement* requirement = [[DemandLogic sharedInstance] getRequirementToPublish];
    
    if (_selectionStage == kTagSelectionStateCategory) {
        [self dismissViewControllerAnimated:YES completion:NULL];
        //清除发布数据
        [[DemandLogic sharedInstance] cleanRequirement];
    }
    else if (_selectionStage == kTagSelectionStateScene) {
        [_categoryMenu moveToDirection:kDirectionTypeRight];
        _selectionStage--;
        [self setNavBarTitle:@"选择品类"];
        
        [_backBtn setImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"icon_close_highlighted.png"] forState:UIControlStateHighlighted];
        [_backBtn setImage:[UIImage imageNamed:@"icon_close_highlighted.png"] forState:UIControlStateSelected];
        
        //清除部分数据
        [_sceneMenu clearData];
        [_SceneView setImage:nil];
        requirement.sceneID = nil;
    }
    else if (_selectionStage == kTagSelectionStageStyle) {
        [_sceneMenu moveToDirection:kDirectionTypeRight];
        _selectionStage--;
        [self setNavBarTitle:@"选择场景"];
        
        //清除部分数据
        [_styleMenu clearData];
        [_StyleView setImage:nil];
        requirement.styleID = nil;
        
        [self performSelector:@selector(clearStyleMenuScrollView) withObject:nil afterDelay:1.0f];
    }
}


#pragma mark  --MenuScrollViewDelegate
- (void)menuScrollView:(MenuScrollView *)menuScrollView
             selectTag:(NSInteger)index
        selectionStage:(NSUInteger)selectionStage{
    
    Requirement* requirement = [[DemandLogic sharedInstance] getRequirementToPublish];

    switch (selectionStage) {
        case kTagSelectionStateCategory:
        {
            sceneModel *model = [DemandLogic sharedInstance].categoryArray[index];
            [_categoryView setImage:[UIImage imageNamed:model.image]];
            requirement.categoryID = model.mId;
            requirement.categoryN = model.name;
        }
            break;
            
        case kTagSelectionStateScene:
        {
            sceneModel *model = [DemandLogic sharedInstance].sceneArray[index];
            [_SceneView setImage:[UIImage imageNamed:model.image]];
            requirement.sceneID = model.mId;
            requirement.sceneN = model.name;
            
            _styleArray = model.styleArray;
        }
            break;
            
        case kTagSelectionStageStyle:
        {
            sceneModel *model = _styleArray[index];
            [_StyleView setImage:[UIImage imageNamed:model.image]];
            requirement.styleID = model.mId;
            requirement.styleN = model.name;
        }
            break;
            
        default:
            break;
    }
    
    [self nextTapped];
}


- (void)nextTapped {
    if (![self whetherContinue]) {
        return;
    }
    
    if (_selectionStage == kTagSelectionStateCategory) {
        [self setNavBarTitle:@"选择场景"];
        [_categoryMenu moveToDirection:kDirectionTypeLeft];
        _selectionStage++;
        
        [_backBtn setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"nav_back_highlighted.png"] forState:UIControlStateHighlighted];
        [_backBtn setImage:[UIImage imageNamed:@"nav_back_highlighted.png"] forState:UIControlStateSelected];
    }
    else if (_selectionStage == kTagSelectionStateScene) {
        [self setNavBarTitle:@"选择风格"];
        [_sceneMenu moveToDirection:kDirectionTypeLeft];
        _selectionStage++;
        
        [self initStyleMenuScrollView];
    }
    else if (_selectionStage == kTagSelectionStageStyle) {
        
        RequirementViewController *rVC = [[RequirementViewController alloc] init];
        rVC.screenImage = [self captureCustomScreen];
        [self.navigationController pushViewController:rVC animated:YES];
    }
}
                          

- (BOOL)whetherContinue{
    Requirement* requirement = [[DemandLogic sharedInstance] getRequirementToPublish];
    
    if (_selectionStage == kTagSelectionStateCategory) {
        if (!requirement.categoryID) {
            [self.view makeToast:@"请先选择品类"];
            return NO;
        }
    }
    else if (_selectionStage == kTagSelectionStateScene) {
        if (!requirement.sceneID) {
            [self.view makeToast:@"请先选择场景"];
            return NO;
        }
    }
    else if (_selectionStage == kTagSelectionStageStyle) {
        if (!requirement.styleID) {
            [self.view makeToast:@"请先选择风格"];
            return NO;
        }
    }
    
    return YES;
}


// 初始化风格菜单
- (void)initStyleMenuScrollView
{
    _styleMenu = [self setupScrollView:kTagSelectionStageStyle];
    [self.view sendSubviewToBack:_styleMenu];
}

// 清除风格菜单
- (void)clearStyleMenuScrollView
{
    [_styleMenu removeFromSuperview];
}

- (UIImage *)captureCustomScreen{
    //截取屏幕
    UIImage *mImage = [[UIImage alloc] imageWithCaputureView:self.view];
    //裁剪图片
    UIImage *screenImage = [mImage cropImageWithX:0 y:64 width:SCREEN_WIDTH height:SCREEN_HEIGHT - 64 - 95];

    return screenImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
