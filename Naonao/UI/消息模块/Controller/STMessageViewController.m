//
//  STMessageViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/4/20.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "STMessageViewController.h"
#import "STMessageTabView.h"
#import "FlipTableView.h"
#import "NoticeController.h"
#import "PraiseController.h"
#import "MQChatViewManager.h"
#import "PushCenter.h"
#import "MessageCenter.h"


@interface STMessageViewController ()<STMessageTabViewDelegate, FlipTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) STMessageTabView *segment;
@property (nonatomic, strong) FlipTableView *flipView;


@end

@implementation STMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarLeftBtn:nil];
    [self setNavbar:nil];
    [self initSegment];
    [self initFlipTableView];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 64.0f +6.0f), 22.0f, 64.0f, 40.0f)];
    [rightBtn setImage:[UIImage imageNamed:@"icon_customer.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(serviceTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

- (void)initSegment{
    self.segment = [[STMessageTabView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160)/2, 23, 160, 40) withDataArray:[NSArray arrayWithObjects:@"通知", @"赞", nil] withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
}

- (void)initFlipTableView{
    if (!self.allVC) {
        self.allVC = [[NSMutableArray alloc] init];
    }
    
    NoticeController *aVC = [[NoticeController alloc] initWithStyle:UITableViewStylePlain];
    aVC.rootVC = self;
    [self.allVC addObject:aVC];
    
    
    PraiseController *arVC = [[PraiseController alloc] initWithStyle:UITableViewStylePlain];
    arVC.rootVC = self;
    [self.allVC addObject:arVC];
    
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - Bottom_H) withArray:self.allVC];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}


- (void)serviceTapped:(id)sender {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];
    [chatViewManager.chatViewStyle setEnableRoundAvatar:YES];

    //自定义顾客信息
    User *user = [[UserLogic sharedInstance] getUser];
    if (user) {

        NSMutableDictionary *clientInfo = [[NSMutableDictionary alloc] init];

        [clientInfo setValue:user.basic.userName forKey:@"name"];
        [clientInfo setValue:user.basic.avatarUrl forKey:@"avatar"];
        [clientInfo setValue:[user.basic.userId stringValue] forKey:@"client_id"];

        if (user.basic.telephone) {
            [clientInfo setValue:user.basic.telephone forKey:@"tel"];
        }

        [chatViewManager setClientInfo:clientInfo];
    }

    [chatViewManager pushMQChatViewControllerInViewController:self];
    [chatViewManager setScheduleLogicWithRule:MQChatScheduleRulesRedirectEnterprise];
    [chatViewManager.chatViewStyle setEnableOutgoingAvatar:YES];

    [[UINavigationBar appearance] setTranslucent:YES];
    
}


#pragma mark -------- select Index
- (void)selectedIndex:(NSInteger)index
{
    CLog(@"%ld",index);
    [self.flipView selectIndex:index];
}


- (void)scrollChangeToIndex:(NSInteger)index
{
    CLog(@"%ld",index);
    [self.segment selectIndex:index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
