//
//  PopupView.m
//  买布易
//
//  Created by 张建 on 15/6/26.
//  Copyright (c) 2015年 张建. All rights reserved.
//

#import "AddressPickView.h"

#define pickViewViewHeight      217.0f
#define buttonWidth             60.0f

#define kProComponent       0
#define kCityComponent      1


@interface AddressPickView ()

/** 全部数组 */
@property (nonatomic, strong) NSArray *stateArray;

@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSArray *selectedArray;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSArray *townArray;

@property (nonatomic, strong) UIView *bottomView;      //包括导航视图和地址选择视图
@property (nonatomic, strong) UIPickerView *pickView;  //地址选择视图
@property (nonatomic, strong) UIView *navigationView;  //上面的导航视图

@end

@implementation AddressPickView



+ (instancetype)shareInstance
{
    static AddressPickView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AddressPickView alloc] init];
    });
    
    [shareInstance showBottomView];
    return shareInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self _addTapGestureRecognizerToSelf];
        [self _getPickerData];
        [self _createView];
    }
    return self;
  
}


#pragma mark - get data
- (void)_getPickerData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    self.stateArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSMutableArray *tempA = [NSMutableArray array];
    for (NSDictionary * dic in self.stateArray) {
        // 数组中包含的是是省数组
        [tempA addObject:dic[@"state"]];
    }
    
    self.provinceArray = tempA;
    
    //默认选择数组
    self.selectedArray = [[self.stateArray objectAtIndex:0] objectForKey:@"cities"];

    //城市
    NSMutableArray *tempB = [NSMutableArray array];
    if (self.selectedArray.count > 0) {
        
        for (NSDictionary * dic in self.selectedArray) {
            // 数组中包含的是是省数组
            [tempB addObject:dic[@"city"]];
        }
        self.cityArray = tempB;
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:@"areas"];
    }
    
}

- (void)_addTapGestureRecognizerToSelf
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBottomView)];
    [self addGestureRecognizer:tap];
}


- (void)_createView
{
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, NaviBar_H + pickViewViewHeight)];
    [self addSubview:_bottomView];
    
    //导航视图
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, StatusBar_H)];
    _navigationView.backgroundColor = [UIColor colorWithHex:0xf6f6f8];
    [_bottomView addSubview:_navigationView];
    
    
    //这里添加空手势不然点击navigationView也会隐藏,
    UITapGestureRecognizer *tapNavigationView = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [_navigationView addGestureRecognizer:tapNavigationView];
    NSArray *buttonTitleArray = @[@"取消", @"确定"];
    for (int i = 0; i <buttonTitleArray.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i*(SCREEN_WIDTH-buttonWidth), 0, buttonWidth, StatusBar_H);
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_navigationView addSubview:button];
        
        button.tag = i;
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, StatusBar_H, SCREEN_WIDTH, pickViewViewHeight)];
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.dataSource = self;
    _pickView.delegate =self;
    [_bottomView addSubview:_pickView];
}

- (void)tapButton:(UIButton*)button
{
    //点击确定回调block
    if (button.tag == 1) {
        NSString *province = [self.provinceArray objectAtIndex:[_pickView selectedRowInComponent:0]];
        NSString *city = [self.cityArray objectAtIndex:[_pickView selectedRowInComponent:1]];
        
        NSString *town = nil;
        
        if (self.townArray.count > 0)
        {
            town = [self.townArray objectAtIndex:[_pickView selectedRowInComponent:2]];
        }
        _block(province, city, town);
    }
    else{
        _block(nil, nil, nil);
    }
    
    [self hiddenBottomView];
}

- (void)showBottomView
{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.top = SCREEN_HEIGHT-StatusBar_H-pickViewViewHeight;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    } completion:^(BOOL finished) {

    }];
}


- (void)hiddenBottomView
{
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.top = SCREEN_HEIGHT;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}


#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == kProComponent) {
        return _provinceArray.count;
    }
    else if (component == kCityComponent) {
        return _cityArray.count;
    }
    else {
        return _townArray.count;
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *lable = [[UILabel alloc] init];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.numberOfLines = 2;
    lable.font = [UIFont systemFontOfSize:15.0f];
    
    if (component == kProComponent) {
        lable.text = [self.provinceArray objectAtIndex:row];
    }
    else if (component == kCityComponent) {
        lable.text = [self.cityArray objectAtIndex:row];
    }
    else {
        lable.text = [self.townArray objectAtIndex:row];
    }
    return lable;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat pickViewWidth = SCREEN_WIDTH/3;
    return pickViewWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == kProComponent) {
        self.selectedArray = [[self.stateArray objectAtIndex:row] objectForKey:@"cities"];
        
        if (self.selectedArray.count > 0) {
            //城市
            NSMutableArray *tempB = [NSMutableArray array];
            for (NSDictionary * dic in self.selectedArray) {
                // 数组中包含的是是省数组
                [tempB addObject:dic[@"city"]];
            }
            
            self.cityArray = tempB;
        }
        else {
            self.cityArray = nil;
        }
        
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:@"areas"];
        }
        else {
            self.townArray = nil;
        }
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:row] objectForKey:@"areas"];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}


@end
