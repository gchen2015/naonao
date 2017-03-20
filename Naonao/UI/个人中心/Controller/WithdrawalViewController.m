//
//  WithdrawalViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/5/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "WithdrawAmountCell.h"
#import "WithdrawLogic.h"

@interface WithdrawalViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *paymentList;
@property (nonatomic, strong) WithdrawChannelInfo *selectModel;

@property (nonatomic, strong) NSArray *titArray;
@property (nonatomic, strong) NSString *nameS;
@property (nonatomic, strong) NSString *accountS;

@end

@implementation WithdrawalViewController

//初始化数据
- (void)initData
{
    _titArray = [[NSArray alloc] initWithObjects:@"姓名", @"账号", nil];
    _paymentList = [[WithdrawLogic sharedInstance] laodConfigListWithPayment];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    CGFloat mf = 325.0f;
    if (_mType == KWithdrawal_WX) {
        [self setNavBarTitle:@"微信提现"];
    }
    else if (_mType == KWithdrawal_ZFB) {
        mf += 48.0f;
        [self setNavBarTitle:@"支付宝提现"];
    }

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self resetScrollView:self.tableView tabBar:NO];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, mf, SCREEN_WIDTH-30, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:@"ST_btn_2.png"] forState:UIControlStateNormal];
    [btn setTitle:@"提 现" forState:UIControlStateNormal];
    //圆角
    btn.layer.cornerRadius = 3; //设置那个圆角的有多圆
    btn.layer.masksToBounds = YES;  //设为NO去试试
    
    [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:btn];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_mType == KWithdrawal_WX) {
            return 1;
        }
        
        return 2;
    }
    else
        return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    if (section == 1) {
        UIView *mV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        
        UILabel *lA = [[UILabel alloc] initWithFrame:CGRectMake(14, 6, 250, 20)];
        [lA setTextColor:[UIColor colorWithHex:0x6e6e6e]];
        [lA setFont:[UIFont systemFontOfSize:14.0]];
        [mV addSubview:lA];
        
        
        NSString *acount = @"0";
        if (_selectModel) {
            switch ([_selectModel.mId integerValue]) {
                case 0:
                    acount = @"50";
                    break;
                    
                case 1:
                    acount = @"100";
                    break;
                    
                case 2:
                    acount = @"200";
                    break;
                    
                default:
                    break;
            }
        }
        NSString *sl = [NSString stringWithFormat:@"%.2f", [[WithdrawLogic sharedInstance].amount floatValue]];
        NSString *st = [NSString stringWithFormat:@"实际支出%@元， 目前账户余额%@元", acount, sl];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, acount.length)];
        
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(st.length - sl.length - 1, sl.length)];
        lA.attributedText = str;

        
        
        return mV;
    }
    
    return nil;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *st = nil;
    if(section == 0)
    {
        if (_mType == KWithdrawal_WX) {
            st = @"提现微信号必须经过实名认证，否则无法成功提现";
        }
        else if (_mType == KWithdrawal_ZFB) {
            st = @"提现支付宝账号必须经过实名认证，否则无法成功提现";
        }
    }
    
    return st;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        WithdrawAmountCell *wCell = [WithdrawAmountCell cellWithTableView:tableView];
        [wCell setCellWithCellInfo:_paymentList[indexPath.row]];
        wCell.btn.tag = indexPath.row;
        [wCell.btn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        return wCell;
    }
    
    
    
    NSInteger row = [indexPath row];
    static NSString  *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [_titArray objectAtIndex:row];
    
    CGRect textFieldRect = CGRectMake(0.0, 0.0f, SCREEN_WIDTH - 105.0f, 31.0f);
    UITextField *theTextField = [[UITextField alloc] initWithFrame:textFieldRect];
    theTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    theTextField.returnKeyType = UIReturnKeyDone;
    theTextField.clearButtonMode = YES;
    theTextField.tag = row;
    theTextField.delegate = self;
    
    //此方法为关键方法
    [theTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    switch (row) {
        case 0:
            theTextField.text = _nameS;
            theTextField.placeholder = @"实名认证的姓名";
            break;
            
        case 1:
            theTextField.text = _accountS;
            theTextField.placeholder = @"支付宝账号";
            break;

        default:
            break;
    }
    
    cell.accessoryView = theTextField;
    
    return cell;
}


- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            self.nameS = textField.text;
            break;
        case 1:
            self.accountS = textField.text;
            break;

        default:
            break;
    }
}

//选中
- (void)ClickBtn:(UIButton *)btn
{
    if (self.selectModel) {
        if([self.selectModel.isSelected boolValue])
        {
            self.selectModel.isSelected = [NSNumber numberWithBool:NO];
        }
        else
            self.selectModel.isSelected = [NSNumber numberWithBool:YES];
    }
    
    WithdrawChannelInfo *model = self.paymentList[btn.tag];
    
    if (![model.isSelected boolValue]) {
        
        if([model.isSelected boolValue])
        {
            model.isSelected = [NSNumber numberWithBool:NO];
        }
        else
            model.isSelected = [NSNumber numberWithBool:YES];
        
        self.selectModel = model;
    }
    
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)btnTapped:(id)sender
{
    if (_nameS.length == 0)
    {
        [self.view makeToast:@"姓名不能为空"];
        return;
    }
    
    
    if (_accountS.length == 0 && _mType == KWithdrawal_ZFB)
    {
        [self.view makeToast:@"账号不能为空"];
        return;
    }
    
    
    if(!_selectModel)
    {
        [self.view makeToast:@"请选择提现金额"];
        return;
    }
    else
    {
#ifdef DEBUG
        // 调试环境
        NSInteger acount = 100;
        
#else
        
        // 正式环境
        NSInteger acount = 0;
        
        if (_selectModel) {
            switch ([_selectModel.mId integerValue]) {
                case 0:
                    acount = 5000;
                    break;
                    
                case 1:
                    acount = 10000;
                    break;
                    
                case 2:
                    acount = 20000;
                    break;
                    
                default:
                    break;
            }
        }
        
        if ([[WithdrawLogic sharedInstance].amount floatValue] < acount) {
            [self.view makeToast:@"余额不足"];
            return;
        }
        
#endif

        //发起提现请求
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //金额(单位为分)
        [dict setObject:[NSNumber numberWithInteger:acount] forKey:@"amount"];   //测试1元
        //提现方式
        [dict setObject:[NSNumber numberWithInteger:_mType] forKey:@"channel"];
        [dict setObject:_nameS forKey:@"username"];
        
        __typeof (&*self) __weak weakSelf = self;
        
        [[WithdrawLogic sharedInstance] getApplyWithdraw:dict withCallback:^(LogicResult *result) {
            if(result.statusCode == KLogicStatusSuccess)
            {
                [weakSelf.view makeToast:@"提现操作已发起，将在2小时内到账"];
            }
            else
            {
                [weakSelf.view makeToast:result.stateDes];
            }
        }];
    }
}
    
    
    

@end
