//
//  AnCommentsViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/30.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "AnCommentsViewController.h"
#import "UserCenterViewController.h"
#import "MBChatBar.h"
#import "CommentsCell.h"
#import "MJRefresh.h"
#import "SquareLogic.h"
#import "LXActionSheet.h"


@interface AnCommentsViewController ()<UITableViewDelegate, UITableViewDataSource, MBChatBarDelegate, CommentsCellDelegate, LXActionSheetDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong)  NSMutableArray *tableArray;
@property (nonatomic, weak) MBChatBar *chatBar;

@property (nonatomic, strong) NSNumber *atUserID;
@property (nonatomic, strong) NSNumber *commentID;

@property (nonatomic, assign) BOOL isSend;

@end


@implementation AnCommentsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"评论"];
    
    if(_tableArray == nil) {
        _tableArray = [NSMutableArray array];
    }
    
    //默认是可以发送评论的
    _isSend = YES;
    
    //默认为商品发布作者
    _atUserID = _aMode.userInfo.userId;
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:YES];
    
    // 添加下拉刷新
    [self setupRefresh];
    
    [self initInputBox];
    
    [self getCommentsList];
    
    [self setExtraCellLineHidden:_tableView];
}


//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}


// 刷新控件
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 下拉刷新更新数据
- (void)loadNewData{
    //    [self.findFrames removeAllObjects];
    //    _mPage = 1;
    // 发送网络请求
    [self getCommentsList];
}

#pragma mark - 上拉刷新更多数据
- (void)loadMoreData{
    //    _mPage++;
    //    // 发送网络请求
    //    [self getRecommandList];
    
}

- (void)initInputBox
{
    MBChatBar *chatBar = [[MBChatBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-COVER_HEIGHT, self.view.frame.size.width, COVER_HEIGHT)];
    self.chatBar = chatBar;
    self.chatBar.delegate = self;
    [self.view addSubview:self.chatBar];
    [self.view bringSubviewToFront:self.chatBar];
}


// 获取评论列表
- (void)getCommentsList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:_aMode.answerId forKey:@"answer_id"];
    [dic setObject:_aMode.userInfo.userId forKey:@"hobby_userid"];
    
    [[SquareLogic sharedInstance] getAnswerComments:dic withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            [_tableArray removeAllObjects];
            
            [_tableArray addObjectsFromArray:result.mObject];
            [_tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
        }
        else
        {
            [self.tableView.mj_header endRefreshing];
            
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArray.count;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsModelFrame *comModelFrame = self.tableArray[indexPath.row];
    return comModelFrame.rowHeight ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsCell *cell = [CommentsCell cellWithTableView:tableView];
    CommentsModelFrame *comModelFrame = self.tableArray[indexPath.row];
    cell.comModelFrame = comModelFrame;
    cell.lineNO = indexPath.row;
    cell.delegate = self;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommentsModelFrame *comModelFrame = self.tableArray[indexPath.row];
    User *user = [[UserLogic sharedInstance] getUser];
    
    if([comModelFrame.tData.userId integerValue] == [user.basic.userId integerValue])
    {
        _commentID = comModelFrame.tData.commentId;
        
        //删除自己的评论
        LXActionSheet *actionSheet = [[LXActionSheet alloc] initWithTitle:@"删除我的评论" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"删除"]];
        [actionSheet showInView:self.view];
        
        return;
    }
    
    //@某某人
    [_chatBar showKeyboard:[NSString stringWithFormat:@"@%@", comModelFrame.tData.nickName]];
    _atUserID = comModelFrame.tData.userId;
    
    [self scrollToRowAtIndexPath:indexPath];
}


- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置时间
    double delayInSeconds = 0.3;
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    //推迟两纳秒执行
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        [self adjustTableViewHeight];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}


- (void)adjustTableViewHeight
{
    CGRect containerFrame = _chatBar.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height + COVER_HEIGHT -20;
    
    self.tableView.frame = CGRectMake(0.0f, self.tableView.frame.origin.y, SCREEN_WIDTH, containerFrame.origin.y);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //回收键盘
    [_chatBar recyclingKeyboard];
    
    //默认为商品发布作者
    _atUserID = _aMode.userInfo.userId;
    
    self.tableView.frame = MAINSCREEN;
    
}


#pragma mark -CommentsCellDelegate
//头像点击事件
- (void)commentsCell:(CommentsCell *)commentsCell useId:(NSNumber *)useId
{
    //回收键盘
    [_chatBar recyclingKeyboard];
    
    if([[UserLogic sharedInstance].user.basic.userId integerValue] == [useId integerValue])
    {
        //自己
    }
    else{
        //进入个人中心页面
        UserCenterViewController *cVC = [[UserCenterViewController alloc] init];
        cVC.userId = useId;
        [self.navigationController pushViewController:cVC animated:YES];
    }
    
}

//发表评论
- (void)commentsCell:(CommentsCell *)commentsCell
    commentsWithInfo:(NSDictionary *)components
        indexWithRow:(NSUInteger)row
{
    //@某某人
    [_chatBar showKeyboard:[NSString stringWithFormat:@"@%@", [components objectForKey:@"at_nickname"]]];
    _atUserID = [components objectForKey:@"at_userid"];
}


#pragma mark - MBChatBarDelegate 发表评论
- (void)chatBar:(MBChatBar *)chatBar sendMessage:(NSString *)msg
{
    //利用计时器来防止重发发送
    if(!_isSend)
    {
        return;
    }
    
    CLog(@"重复发送");
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:5];
    //答案发布者
    [dict setObject:_aMode.userInfo.userId forKey:@"answer_userid"];
    //被评论ID
    [dict setObject:_atUserID forKey:@"at_userid"];
    //ID
    [dict setObject:_aMode.answerId forKey:@"answer_id"];
    //问题ID
    [dict setObject:_orderID forKey:@"order_id"];
    //评论内容
    [dict setObject:[Units encodeToPercentEscapeString:msg] forKey:@"content"];

    
    _isSend = NO;
    
    __typeof (&*self) __weak weakSelf = self;
    [[SquareLogic sharedInstance] addAnswerComment:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            
            //发送添加答案消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SuccessAddCommentsNotification" object:nil];
            
            
            //清空数据
            [weakSelf.chatBar clearData];
            [weakSelf.chatBar recyclingKeyboard];
            weakSelf.atUserID  = weakSelf.aMode.userInfo.userId;
            
            
            //延迟
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [weakSelf getCommentsList];
            });
        }
        else
        {
            
        }
        
        
        _isSend = YES;
        
    }];
}



#pragma mark - LXActionSheetDelegate
- (void)actionSheet:(LXActionSheet *)mActionSheet didClickOnButtonIndex:(int)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
            [dict setObject:_commentID forKey:@"comment_id"];
            
            
            //删除我的评论
            [[SquareLogic sharedInstance] deleteAnswerComment:dict withCallback:^(LogicResult *result) {
                if(result.statusCode == KLogicStatusSuccess)
                {
                    [self getCommentsList];
                }
                else
                {
                    
                }
                
            }];

        }
            break;

        default:
            break;
    }
}

@end
