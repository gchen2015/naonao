//
//  PersonalInfoViewController.m
//  Naonao
//
//  Created by Richard Liu on 15/12/10.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "SJAvatarBrowser.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "LXActionSheet.h"
#import "TextFieldEditViewController.h"
#import "SexSelectionViewController.h"
#import "FindPasswordViewController.h"
#import "ThirdPartyViewController.h"
#import "PersonalityViewController.h"
#import "AddressViewController.h"
#import "FigureGuideViewController.h"


@interface PersonalInfoViewController  ()<UITableViewDataSource, UITableViewDelegate, LXActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic, weak) UIButton *headButton;

@property (nonatomic, strong) UIImage *headImage;        //存储临时头像
@end

@implementation PersonalInfoViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"我的资料"];

    UITableView *tableView = [[UITableView alloc] initWithFrame:MAINSCREEN style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self resetScrollView:self.tableView tabBar:NO];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 65;
    }

    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [UserLogic sharedInstance].user;
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"HeadCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            cell.textLabel.text = @"头像";
            
            
            UIButton *headButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 10, 45, 45)];
            _headButton = headButton;
            [_headButton addTarget:self action:@selector(headButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_headButton];
            
        }
        
        _headButton.layer.cornerRadius = CGRectGetHeight(_headButton.frame)/2;//设置那个圆角的有多圆; //设置那个圆角的有多圆
        _headButton.layer.masksToBounds = YES;  //设为NO去试试
        _headButton.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
        _headButton.layer.borderColor = [BACKGROUND_GARY_COLOR CGColor];//设置边框的颜色
        
        if(_headImage)
        {
            [_headButton setImage:_headImage forState:UIControlStateNormal];
        }
        else{
            [_headButton sd_setImageWithURL:[NSURL URLWithString:[user.basic.avatarUrl smallHead]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_avatar_large.png"]];
        }
        
        return cell;
        
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
            [cell.textLabel setTextColor:[UIColor blackColor]];
            
            
            cell.detailTextLabel.minimumScaleFactor = 0.6f;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
            [cell.detailTextLabel setTextColor:LIGHT_BLACK_COLOR];
        }
        
        NSString *title;
        NSString *value;
        
        if (indexPath.row == 1) {
            title = @"挠挠ID";
            value = [NSString stringWithFormat:@"%@", user.basic.userId];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
        
        if (indexPath.row == 2) {
            title = @"昵称";
            value = user.basic.userName;
        }
        
        if (indexPath.row == 3) {
            title = @"性别";
            if ([user.basic.gender isEqualToString:@"female"]) {
                value = @"女";
            }
            else if ([user.basic.gender isEqualToString:@"male"])
            {
                value = @"男";
            }
        }
        
        if (indexPath.row == 4) {
            title = @"手机号码";
            value = user.basic.telephone;
        }
        
        if (indexPath.row == 5) {
            title = @"第三方账号";
            value = nil;
        }
        
        if (indexPath.row == 6) {
            title = @"收货地址";
            value = nil;
        }

        cell.textLabel.text = title;
        cell.detailTextLabel.text = value;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0)
    {
        LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照", @"从手机相册中选择"]];
        [actionSheet showInView:self.view];
    }
    
    if (indexPath.row == 2) {
        TextFieldEditViewController *tVC = [[TextFieldEditViewController alloc] init];
        [self.navigationController pushViewController:tVC animated:YES];
    }
    
    if (indexPath.row == 3)
    {
        //性别
        SexSelectionViewController *sVC = [[SexSelectionViewController alloc] init];
        [self.navigationController pushViewController:sVC animated:YES];
    }
    
    if (indexPath.row == 4) {
        User *user = [UserLogic sharedInstance].user;
        //有值
        if ([user.basic.telephone length] > 1) {
            return;
        }
        
        FindPasswordViewController *bVC = [[FindPasswordViewController alloc] init];
        bVC.mType = KChangePassword_BindPhone;
        [self.navigationController pushViewController:bVC animated:YES];
    }
    
    if (indexPath.row == 5)
    {
        ThirdPartyViewController *sVC = [[ThirdPartyViewController alloc] init];
        [self.navigationController pushViewController:sVC animated:YES];
    }
    
    if (indexPath.row == 6)
    {
        //收货地址
        AddressViewController *pVC = [[AddressViewController alloc] init];
        [self.navigationController pushViewController:pVC animated:YES];
    }
    
}

#pragma mark - LXActionSheetDelegate
- (void)actionSheet:(LXActionSheet *)mActionSheet didClickOnButtonIndex:(int)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //照相机
            if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
                AlertWithTitleAndMessage(@"您的设备不支持拍照功能",@"");
                return;
            }
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
            
            //调用前摄像头
            //imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        case 1:
        {
            //相簿
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
            
        default:
            break;
    }
}

#pragma mark UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* userImage = [info objectForKey:UIImagePickerControllerEditedImage];
    _headImage = ImageWithImageSimple(userImage, CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
    [_tableView reloadData];
    
    NSData *tempData = UIImageJPEGRepresentation(_headImage, 1.0);
    
    __typeof (&*self) __weak weakSelf = self;
    
    //上传头像到七牛云
    [[UserLogic sharedInstance] updateUserHeadImage:tempData withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //成功之后更新用户信息
            [weakSelf updateUserInfo:result.mObject];
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];
}


//更新用户信息
- (void)updateUserInfo:(NSString *)imageUrl{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    //头像
    [dict setObject:imageUrl forKey:@"url"];
    
    if ([UserLogic sharedInstance].user.basic.gender) {
        //性别
        [dict setObject:[UserLogic sharedInstance].user.basic.gender forKey:@"gender"];
    }
    else{
        [dict setObject:@"famale" forKey:@"gender"];
    }
    
    
    __typeof (&*self) __weak weakSelf = self;
    [[UserLogic sharedInstance] modifyUserData:dict withCallback:^(LogicResult *result) {
        if(result.statusCode == KLogicStatusSuccess)
        {
            //成功
            CLog(@"成功");
        }
        else
            [weakSelf.view makeToast:result.stateDes];
    }];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



//头像
- (void)headButtonTouch:(id)sender
{
    [SJAvatarBrowser showImage:self.headButton.imageView];
}

@end
