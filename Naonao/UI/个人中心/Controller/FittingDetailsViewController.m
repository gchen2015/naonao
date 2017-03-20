//
//  FittingDetailsViewController.m
//  Naonao
//
//  Created by 刘敏 on 2016/9/18.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "FittingDetailsViewController.h"
#import "GoodsOrderCell.h"
#import "MerchantsMapViewController.h"
#import "TimeUtil.h"


@interface FittingDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation FittingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"试衣详情"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self resetScrollView:self.tableView tabBar:NO];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            return 96.0;
        }
        return 58;
    }
    
    return 48.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 15.0;
    }
    
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            GoodsOrderCell * mCell = [GoodsOrderCell cellWithTableView:tableView];
            SKUOrderModel *sModel = _mInfo.skuData;
            [mCell setCellWithOrderCellInfo:sModel];
            
            return mCell;
        }
        else{
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
                [cell.textLabel setTextColor:BLACK_COLOR];
                
                
                cell.detailTextLabel.minimumScaleFactor = 0.6f;
                cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
                [cell.detailTextLabel setFont:[UIFont fontWithName:kAkzidenzGroteskBQ size:16.0]];
                [cell.detailTextLabel setTextColor:PINK_COLOR];
            }
        
            cell.textLabel.text = @"总价";
            
            NSString *st = [NSString stringWithFormat:@"￥%.2f", [_mInfo.skuData.price floatValue]];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:st];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, 1)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kAkzidenzGroteskBQ size:24.0] range:NSMakeRange(1, st.length-4)];
            cell.detailTextLabel.attributedText = str;
            
            return cell;
        }
    }
    else if (indexPath.section == 1){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
            [cell.textLabel setTextColor:BLACK_COLOR];

        }
        
        NSString *imageN = nil;
        NSString *titN = nil;
        
        if (indexPath.row == 0) {
            imageN = @"mine_time_icon.png";
            
            NSString *dateS = [_mInfo.reserveTime substringToIndex:10];
            NSString *timeS = [_mInfo.reserveTime substringFromIndex:11];
            titN = [NSString stringWithFormat:@"%@（%@）   %@", dateS, [TimeUtil featureWeekdayWithDate:dateS], timeS];
        }
        
        if (indexPath.row == 1) {
            imageN = @"cell_address_icon.png";
            titN = _mInfo.address.address;
        }
        
        if (indexPath.row == 2) {
            imageN = @"mine_phone_icon.png";
            titN = _mInfo.address.telephone;
        }
        
        [cell.imageView setImage:[UIImage imageNamed:imageN]];
        cell.textLabel.text = titN;
        
        return cell;

    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section == 1) {
        if (indexPath.row == 1) {
            MerchantsMapViewController *mVC = [[MerchantsMapViewController alloc] init];
            mVC.address = _mInfo.address;
            [self.navigationController pushViewController:mVC animated:YES];
        }
        if (indexPath.row == 2) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@", _mInfo.address.telephone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
