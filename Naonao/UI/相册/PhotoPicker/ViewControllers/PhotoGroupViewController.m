//
//  PhotoGroupViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PhotoGroupViewController.h"
#import "PhotoViewController.h"
#import "STPhotoPickerDatas.h"
#import "PhotoGroupViewCell.h"
#import "STPhotoPickerGroup.h"

@interface PhotoGroupViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation PhotoGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getCameraRollGroup];
    
    [self performSelector:@selector(laodUI) withObject:nil afterDelay:0.6f];
}

- (void)laodUI{
    [self setNavBarTitle:@"选择相册"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
    [self resetScrollView:self.tableView tabBar:NO];
    [self setExtraCellLineHidden:_tableView];
}

//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

//获取相机胶卷
- (void)getCameraRollGroup{
    //当前用以下方法代替组别记忆功能
    STPhotoPickerGroup *gp = nil;
    
    for (STPhotoPickerGroup *group in self.groups) {
        if ([group.groupName isEqualToString:@"Camera Roll"] || [group.groupName isEqualToString:@"相机胶卷"] || [group.groupName isEqualToString:@"所有照片"] || [group.groupName isEqualToString:@"All Photos"]) {
            gp = group;
            break;
        }
    }
    
    if (!gp) return ;
    
    [self setupAssetsVCWithGroup:gp];
}


- (void)setupAssetsVCWithGroup:(STPhotoPickerGroup *)group{

    PhotoViewController *pVC = [[PhotoViewController alloc] init];
    pVC.maxCount = self.maxCount;
    pVC.pickerGroup = group;
    [self.navigationController pushViewController:pVC animated:NO];
}



#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoGroupViewCell *cell = [PhotoGroupViewCell cellWithTableView:tableView];
    [cell setCellWithCellInfo:self.groups[indexPath.row]];

    return cell;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    STPhotoPickerGroup *group = self.groups[indexPath.row];
    
    PhotoViewController *pVC = [[PhotoViewController alloc] init];
    pVC.maxCount = self.maxCount;
    pVC.pickerGroup = group;
    [self.navigationController pushViewController:pVC animated:YES];
}

@end
