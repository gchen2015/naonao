//
//  PickUpDateViewController.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/27.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PickUpDateViewController.h"
#import "AppointmentLogic.h"
#import "MerchantsMapViewController.h"
#import "SegmentTapView.h"
#import "BookModel.h"
#import "SHLUILabel.h"
#import "AppointmentView.h"
#import "TimeUtil.h"
#import "MyAppointmentViewController.h"


@interface PickUpDateViewController ()<SegmentTapViewDelegate, AppointmentViewDelegate>

@property (nonatomic, strong) AppointmentView *actionSheet;

@property (nonatomic, strong) NSArray *datesArray;
@property (nonatomic, strong) SegmentTapView *segment;
@property (nonatomic, strong) BookModel *bookData;
@property (nonatomic, strong) NSString *dateS;

@property (nonatomic, strong) NSString *reserveTime;   //预约的时间，用于网络请求
@property (nonatomic, strong) UIButton *temBtn;

@end


@implementation PickUpDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"选择取货日期"];
    
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"nav_back.png"
                                                           imgHighlight:@"nav_back_highlighted.png"
                                                                 target:self
                                                                 action:@selector(back:)]];
    _datesArray = [self getDates];
    self.dateS = _datesArray[0];
    
    [self initSegment];
    [self drawConventionalUI];
    // 获取
    [self getAppointmentsCalendar:[_datesArray[0] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    
}

- (void)back:(id)sender{
    
    AlertWithTitleAndMessage(@"您还没有预约到店取货日期，请完成预约", @"");
    
}

- (void)drawConventionalUI{
    UIView *mV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame), SCREEN_WIDTH, 33)];
    [mV setBackgroundColor:BACKGROUND_GARY_COLOR];
    [self.view addSubview:mV];
    
    // 绘制常规控件
    UILabel *pontR = [[UILabel alloc] initWithFrame:CGRectMake(25, 12, 9, 9)];
    // 圆角
    pontR.layer.cornerRadius = 4.5;                 //设置那个圆角的有多圆
    pontR.layer.masksToBounds = YES;                //设为NO去试试
    [pontR setBackgroundColor:PINK_COLOR];
    [mV addSubview:pontR];
    
    UILabel *lA = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pontR.frame)+4, 10.5, 50, 12)];
    [lA setText:@"可预约"];
    [lA setFont:[UIFont systemFontOfSize:11]];
    [lA setTextColor:GARY_COLOR];
    [mV addSubview:lA];
    
    
    UILabel *pontG = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, 9, 9)];
    // 圆角
    pontG.layer.cornerRadius = 4.5;                 //设置那个圆角的有多圆
    pontG.layer.masksToBounds = YES;                //设为NO去试试
    [pontG setBackgroundColor:LIGHT_GARY_COLOR];
    [mV addSubview:pontG];
    
    UILabel *lB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pontG.frame)+4, 10.5, 50, 12)];
    [lB setText:@"已约满"];
    [lB setFont:[UIFont systemFontOfSize:11]];
    [lB setTextColor:GARY_COLOR];
    [mV addSubview:lB];
}

//可以预定今日、明日、后天（3天）
- (NSArray *)getDates{
    
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int time = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *t = [cal components:time fromDate:now];
    int year = (int)[t year];
    int mouth = (int)[t month];
    int day = (int)[t day];
    //    int hour = (int)[t hour];
    //    int minute = (int)[t minute];
    
    NSMutableArray *dateArray = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < 3; i++) {
        if (mouth==1 || mouth==3 || mouth==5 || mouth==7 || mouth==8 || mouth==10 || mouth==12)
        {
            if (day > 31)
            {
                day = 1;
                mouth += 1;
            }
            else
            {
                CLog(@"不做任何处理");
            }
        }
        else if (mouth == 2)
        {
            if (day > 28) {
                day = 1;
                mouth += 1;
            }
            else
            {
                CLog(@"不做任何处理");
            }
        }
        else
        {
            if (day > 30) {
                day = 1;
                mouth += 1;
            }
            else{
                CLog(@"不做任何处理");
            }
        }
        
        NSString *st = [NSString stringWithFormat:@"%2d-%2d-%2d", year, mouth, day];
        NSString *date = [st stringByReplacingOccurrencesOfString:@" " withString:@"0"];
        [dateArray addObject:date];
        
        day += 1;
    }
    
    return dateArray;
}

- (void)drawDatesUI{
    
    CGFloat mW = (SCREEN_WIDTH-50)/4;
    UIScrollView *mV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segment.frame)+33, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.segment.frame)-33)];
    mV.tag = 0x9999;
    mV.showsVerticalScrollIndicator = YES;
    mV.userInteractionEnabled = YES;
    [mV setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mV];
    
    CGFloat mH = 0.0;
    for (int i = 0; i < self.bookData.calender.count; i++) {
        BookCalender *calender = self.bookData.calender[i];
        
        int x = i/4;
        int y = i%4;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(25+mW*y, 28+39*x, mW, 39)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        
        if (![calender.free boolValue]){
            //不可预约
            btn.enabled = NO;
        }
        else{
            btn.enabled = YES;
        }
        
        
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_whitle_1.png"] forState:UIControlStateNormal];
        [btn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"pink_point.png"] forState:UIControlStateNormal];
        
        //点击效果
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_pink.png"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"white_point.png"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_pink.png"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"white_point.png"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        
        
        // 禁用状态
        [btn setImage:[UIImage imageNamed:@"gary_point.png"] forState:UIControlStateDisabled];
        [btn setTitleColor:LIGHT_GARY_COLOR forState:UIControlStateDisabled];
        
        btn.layer.borderColor = LIGHT_GARY_COLOR.CGColor;
        btn.layer.borderWidth = 0.5;
        [btn setTitle:calender.time forState:UIControlStateNormal];
        
        [btn setTag:1000+i];
        [btn addTarget:self action:@selector(calendarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [mV addSubview:btn];
        
        mH = CGRectGetMaxY(btn.frame);
    }
    
    SHLUILabel *des = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    [des setText:@"*只要付款成功，即可得到免费提供的专业化妆、发型，专业摄影棚拍摄写真服务。"];
    [des setFont:[UIFont systemFontOfSize:12.0]];
    des.lineBreakMode = NSLineBreakByWordWrapping;
    [des setTextAlignment:NSTextAlignmentLeft];
    des.numberOfLines = 0;
    [des setTextColor:PINK_COLOR];
    
    CGFloat h = [des getAttributedStringHeightWidthValue:SCREEN_WIDTH-50];
    [des setFrame:CGRectMake(25, mH+15, SCREEN_WIDTH-50, h)];
    
    [mV addSubview:des];
    
    //地址
    UIImageView *pointV = [[UIImageView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(des.frame)+45, 14, 18)];
    [pointV setImage:[UIImage imageNamed:@"cell_address_icon.png"]];
    [mV addSubview:pointV];
    
    //添加点击事件
    UIButton *addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(des.frame)+34, SCREEN_WIDTH, 40)];
    [addressBtn addTarget:self action:@selector(pointTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [mV addSubview:addressBtn];
    
    
    //分割线
    UILabel *lineA = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pointV.frame)+15, CGRectGetMaxY(des.frame)+47, 0.8, 14)];
    [lineA setBackgroundColor:LINE_COLOR];
    [mV addSubview:lineA];
    
    UILabel *addressL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pointV.frame)+30, CGRectGetMaxY(des.frame)+45, SCREEN_WIDTH - 53, 18)];
    [addressL setText:_bookData.address.address];
    [addressL setFont:[UIFont systemFontOfSize:14.0]];
    [addressL setTextColor:BLACK_COLOR];
    [mV addSubview:addressL];
    
    //分割线
    UILabel *lineV = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(pointV.frame)+14, SCREEN_WIDTH-50, 0.5)];
    [lineV setBackgroundColor:LINE_COLOR];
    [mV addSubview:lineV];
    
    //电话
    UIImageView *phoneV = [[UIImageView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(lineV.frame)+14, 14, 18)];
    [phoneV setImage:[UIImage imageNamed:@"mine_phone_icon.png"]];
    [mV addSubview:phoneV];
    //添加点击事件
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineV.frame), SCREEN_WIDTH, 40)];
    [phoneBtn addTarget:self action:@selector(phoneTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [mV addSubview:phoneBtn];
    
    //分割线
    UILabel *lineB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneV.frame)+15, CGRectGetMaxY(lineV.frame)+16, 0.8, 14)];
    [lineB setBackgroundColor:LINE_COLOR];
    [mV addSubview:lineB];
    
    
    UILabel *phoneL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneV.frame)+30, CGRectGetMaxY(lineV.frame)+14, SCREEN_WIDTH - 53, 18)];
    [phoneL setText:_bookData.address.telephone];
    [phoneL setFont:[UIFont systemFontOfSize:14.0]];
    [phoneL setTextColor:BLACK_COLOR];
    [mV addSubview:phoneL];
    
    //预约说明
    SHLUILabel *insLabel = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    [insLabel setText:@"*预约成功后会收到预约成功短信，向工作人员出示短信即可得到服务。"];
    [insLabel setFont:[UIFont systemFontOfSize:12.0]];
    insLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [insLabel setTextAlignment:NSTextAlignmentLeft];
    [insLabel setTextColor:LIGHT_GARY_COLOR];
    CGFloat insLabel_h = [insLabel getAttributedStringHeightWidthValue:SCREEN_WIDTH-50];
    [insLabel setFrame:CGRectMake(25, CGRectGetMaxY(phoneV.frame)+45, SCREEN_WIDTH-50, insLabel_h)];
    
    [mV addSubview:insLabel];
    
    
    
    SHLUILabel *insL = [[SHLUILabel alloc] initWithFrame:CGRectZero];
    
    [insL setText:@"*预约后请准时到达，否则会影响您的下一次预约服务。"];
    [insL setFont:[UIFont systemFontOfSize:12.0]];
    insL.lineBreakMode = NSLineBreakByWordWrapping;
    [insL setTextAlignment:NSTextAlignmentLeft];
    insL.numberOfLines = 0;
    [insL setTextColor:LIGHT_GARY_COLOR];
    CGFloat insL_h = [insL getAttributedStringHeightWidthValue:SCREEN_WIDTH-50];
    [insL setFrame:CGRectMake(25, CGRectGetMaxY(insLabel.frame)+18, SCREEN_WIDTH-50, insL_h)];
    [mV addSubview:insL];
    
    [mV setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(insL.frame)+56)];
}

- (void)initSegment{
    NSMutableArray *dArray = [NSMutableArray arrayWithCapacity:_datesArray.count];
    
    int i = 0;
    
    for (NSString *st in _datesArray) {
        NSString *date = @"";
        if (i == 0) {
            date = [NSString stringWithFormat:@"今天 %@",  [st substringFromIndex:5]];
        }
        if (i == 1) {
            date = [NSString stringWithFormat:@"明天 %@",  [st substringFromIndex:5]];
        }
        if (i == 2) {
            date = [NSString stringWithFormat:@"后天 %@",  [st substringFromIndex:5]];
        }
        [dArray addObject:date];
        
        i++;
    }
    
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navbar.frame), SCREEN_WIDTH, 40) withDataArray:dArray withFont:13];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}

- (void)getAppointmentsCalendar:(NSString *)dateS{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:dateS forKey:@"date"];
    
    __typeof (&*self) __weak weakSelf = self;
    [[AppointmentLogic sharedInstance] getAppointmentCalendar:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            weakSelf.bookData = result.mObject;
            [weakSelf drawDatesUI];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
    }];
}

- (void)calendarButtonTapped:(UIButton *)sender{
    
    sender.selected = YES;
    
    _temBtn = sender;
    
    //得到预约的具体时间
    BookCalender *calender = self.bookData.calender[sender.tag-1000];
    NSString *times = [NSString stringWithFormat:@"%@（%@）%@", _dateS, [TimeUtil featureWeekdayWithDate:_dateS], calender.time];
    NSString *st = [NSString stringWithFormat:@"%@  \n%@--%@到门店取货", times, self.bookData.address.address, self.bookData.address.name];
    _reserveTime = [NSString stringWithFormat:@"%@ %@", _dateS, calender.time];
    
    NSString *desT = @"当面取货，还可获得专业化妆、发型，专业摄影棚拍摄写真服务~";
    self.actionSheet = [[AppointmentView alloc] initWithTitle:@"是否预约？" delegate:self message:st instructions:desT leftButtonTitle:@"放弃" rightButtonTitle:@"预约"];
    [self.actionSheet showInView:self.view];
}


#pragma mark - SegmentTapViewDelegate
- (void)selectedIndex:(NSInteger)index {
    //获取
    [self getAppointmentsCalendar:[_datesArray[index] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    
    //日期
    _dateS = _datesArray[index];
}


- (void)phoneTouchUpInside:(UITapGestureRecognizer *)recognizer{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", _bookData.address.telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)pointTouchUpInside:(UITapGestureRecognizer *)recognizer{
    MerchantsMapViewController *mVC = [[MerchantsMapViewController alloc] init];
    mVC.address = _bookData.address;
    [self.navigationController pushViewController:mVC animated:YES];
}


#pragma mark - AppointmentViewDelegate
- (void)didClickOnSureButton:(BOOL)isTure {
    
    //取消选中状态
    _temBtn.selected = NO;
    
    if (isTure) {
        // 发起预约请求
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
        [dic setObject:_reserveTime forKey:@"reserve_time"];
        [dic setObject:_orderId forKey:@"order_id"];
        
        __typeof (&*self) __weak weakSelf = self;
        [[AppointmentLogic sharedInstance] getChicdateTakeOrder:dic withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                [weakSelf showAlert];
            }
            else
            {
                [weakSelf.view makeToast:result.stateDes];
            }
        }];
    }
}


- (void)showAlert{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"预约成功"
                                                    message:@"去我的预约页面查看"
                                                   delegate:self
                                          cancelButtonTitle:@"返回上级"
                                          otherButtonTitles:@"查看", nil];
    
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //跳转到我的预约页面
        MyAppointmentViewController *sVC = [[MyAppointmentViewController alloc] init];
        sVC.isReturn = YES;
        sVC.isSecond = YES;
        [self.navigationController pushViewController:sVC animated:YES];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
