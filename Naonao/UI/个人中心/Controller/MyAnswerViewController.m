//
//  MyAnswerViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/4.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MyAnswerViewController.h"
#import "UITableView+Mascot.h"
#import "UserLogic.h"
#import "MyAnswersCell.h"
#import "AnswerViewController.h"
#import "MLEmojiLabel.h"
#import "SquareLogic.h"

@interface MyAnswerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@end


@implementation MyAnswerViewController


#pragma mark - 懒加载
- (NSMutableArray *)tableArray
{
    if (!_tableArray) {
        self.tableArray = [NSMutableArray array];
    }
    return _tableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavBarTitle:@"我的回答"];
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"编辑" target:self action:@selector(editTapped:)]];

    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //校正滚动区域
    [self resetScrollView:_tableView tabBar:NO];
    
    [self getSquareList];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setLoadedImageName:@"bird_no_order.png"];
    [self.tableView setDescriptionText:@"还没有任何消息，到别处看看吧"];
    [self.tableView setButtonText:@""];
}


- (void)editTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }
    else {
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (void)getSquareList
{
    // 只需一行代码，我来解放你的代码
    self.tableView.loading = YES;
    
    __typeof (&*self) __weak weakSelf = self;
    
    [[UserLogic sharedInstance] requestUserAnswersList:nil withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf.tableArray addObjectsFromArray:result.mObject];
            [weakSelf.tableView reloadData];
            
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
        
        self.tableView.loading = NO;
    }];
}

//// 删除我的回答
//- (void)deleteSquareAnswer
//{
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
//    [dict setObject:@"18,19,43" forKey:@"ids"];
//    
//    [[SquareLogic sharedInstance] deleteSquareAnswer:dict withCallback:^(LogicResult *result) {
//        
//    }];
//}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserAnswer *answer = _tableArray[indexPath.section];
    return [self calculateHeight:answer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAnswersCell *cell = [MyAnswersCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:_tableArray[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserAnswer *answer = [self.tableArray objectAtIndex:indexPath.section];
    AnswerViewController *nVC = [[AnswerViewController alloc] init];
    nVC.orderId = answer.orderId;
    nVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:nVC animated:YES];
}


- (CGFloat)calculateHeight:(UserAnswer *)answer{
    MLEmojiLabel *contentL = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    contentL.numberOfLines = 0;
    [contentL setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
    contentL.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    [contentL setText:answer.orderT];
    CGSize mSize = [contentL preferredSizeWithMaxWidth:(SCREEN_WIDTH - 54)];
    
    MLEmojiLabel *answerL = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
    answerL.numberOfLines = 0;
    [answerL setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]];
    answerL.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    
    [answerL setText:answer.content];
    CGFloat mH = [answerL preferredSizeWithMaxWidth:(SCREEN_WIDTH - 92)].height;
    
    if (mH < 24) {
        mH = 24;
    }
    
    return mSize.height + mH + 50;

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteCellWithTableView:_tableArray[indexPath.section] didSelectRowAtIndexPath:indexPath];
    }
}

- (void)deleteCellWithTableView:(UserAnswer *)model didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [dic setObject:model.mId forKey:@"ids"];
    
    __typeof (&*self) __weak weakSelf = self;
    
    // 只需一行代码，我来解放你的代码
    self.tableView.loading = YES;
    
    [[SquareLogic sharedInstance] deleteSquareAnswer:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [weakSelf.tableArray removeObjectAtIndex:indexPath.section];
            [weakSelf.tableView reloadData];
        }
        else
        {
            [weakSelf.view makeToast:result.stateDes];
        }
        
        self.tableView.loading = NO;
    }];
    
}



@end
