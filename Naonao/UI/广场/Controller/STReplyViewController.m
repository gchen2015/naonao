//
//  STReplyViewController.m
//  Naonao
//
//  Created by 刘敏 on 16/6/24.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//


#import "STReplyViewController.h"
#import "STPhotoBrowserViewController.h"
#import "DMCameraViewController.h"
#import "PlaceholderTextView.h"
#import "PhotoGroupViewController.h"
#import "GoodsResultsViewController.h"
#import "SquareLogic.h"
#import "SCGoodsView.h"
#import "LXActionSheet.h"
#import "STPhotoPickerDatas.h"
#import <SDWebImage/UIImage+WebP.h>
#import "AnswerModeFrame.h"



#define K_S_W       (SCREEN_WIDTH- 30 - 4*3)/4.0f
#define M_Quality   75.0f                                   //质量

@interface STReplyViewController () <UITextViewDelegate, SCGoodsViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,
STPhotoBrowserViewControllerDelegate, STPhotoBrowserViewControllerDataSource, LXActionSheetDelegate>

@property (nonatomic, weak) UIButton *cancelBtn;        //取消
@property (nonatomic, weak) UIButton *sendBtn;          //发送
@property (weak, nonatomic) UIView *inputV;             //文字输入区域

@property (nonatomic, weak) UIButton *chooseBtn;        //挑选商品
@property (nonatomic, weak) UIButton *albumBtn;         //相册按钮

@property (weak, nonatomic) PlaceholderTextView *textView;

@property (weak, nonatomic) SCGoodsView *goodView;      //选择的商品
@property (weak, nonatomic) UICollectionView *cv;

@property (nonatomic, strong) STPhotoBrowserViewController *broswerVC;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) GoodsMode *mode;

@property (nonatomic, strong) NSMutableArray *compressionArray;    //压缩后的图片数据

@end


@implementation STReplyViewController

#pragma mark - 注册消息事件
- (void)initNotionCenter{
    //选择了商品
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addGoodsMode:)
                                                 name:@"AddGoodsModeCompletionNotification"
                                               object:nil];

    //添加照片
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addPic:)
                                                 name:@"AddPicCompletionNotification"
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddGoodsModeCompletionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddPicCompletionNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithHex:0xF5F5F3]];
    
    if (!_compressionArray) {
        self.compressionArray = [NSMutableArray array];
    }
    
    [self initNotionCenter];
    
    [self initView];

    [self addCollectionView];
}

- (void)initView {
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 27, 50, 30)];
    _cancelBtn = cancelBtn;
    [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    //发送按钮
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 55, 27, 50, 30)];
    _sendBtn = sendBtn;
    [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //添加按钮点击事件
    [_sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBtn];
    
    // 文字输入区域
    PlaceholderTextView *contentView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(15, 67, SCREEN_WIDTH - 30, 100)];
    contentView.font = [UIFont  systemFontOfSize:15];
    contentView.placeholder = @"写下你的回复，显示你独到的品味吧";
    contentView.placeholderColor = [UIColor lightGrayColor];
    contentView.placeholderFont = [UIFont  systemFontOfSize:15];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.borderColor = LIGHT_BLACK_COLOR.CGColor;
    contentView.layer.borderWidth = 0.5;
    //圆角
    contentView.layer.cornerRadius = 6.0;
    contentView.layer.masksToBounds = YES;  //设为NO去试试
    contentView.delegate = self;
    contentView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:contentView];
    self.textView = contentView;
    //弹出键盘
    [_textView becomeFirstResponder];
    
    
    //绘制挑选商品按钮
    UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.textView.frame) + 12, 107, 30)];
    _chooseBtn = chooseBtn;
    [_chooseBtn setBackgroundImage:[UIImage imageNamed:@"choose_goods_icon.png"] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(chooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseBtn];
    
    UIButton *albumBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 137, CGRectGetMaxY(self.textView.frame) + 12, 107, 30)];
    _albumBtn = albumBtn;
    [_albumBtn setBackgroundImage:[UIImage imageNamed:@"choose_goods_pic.png"] forState:UIControlStateNormal];
    [_albumBtn addTarget:self action:@selector(albumBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_albumBtn];
}

- (void)addCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
    
    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_chooseBtn.frame)+20, SCREEN_WIDTH-30, K_S_W*2+4) collectionViewLayout:layout];
    _cv = cv;
    [_cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_cv setUserInteractionEnabled:YES];
    [_cv setDataSource:self];
    [_cv setDelegate:self];
    [_cv setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_cv];
}

#pragma mark - 按钮事件响应
- (void)closeBtnClick {
    [self clearData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendBtnClicked
{
    [_sendBtn setEnabled:YES];
    
    if (!_textView || _textView.text.length == 0) {
        [self.view makeToast:@"说点什么吧，您的建议也许能帮到他人哦"];
        return;
    }
    
    StorageAnswer *sT = [[StorageAnswer alloc] init];
    sT.orderId = _orderInfo.orderId;
    sT.content = [Units encodeToPercentEscapeString:_textView.text];
    
    if (_mode) {
        sT.gMode = _mode;
        sT.productId = _mode.mId;
    }
    
    if (_imageArray){
        sT.imageArray = _imageArray;
    }

    //缓存发布数据
    [[SquareLogic sharedInstance] temporaryStorageAnswerInfo:sT];
    
    [self clearData];
    
    [self sendNotification];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)sendNotification {
    
    AnUserInfo *userInfo = [[AnUserInfo alloc] init];
    User *user = [[UserLogic sharedInstance] getUser];
    
    userInfo.userId = user.basic.userId;
    userInfo.isContract = user.basic.contract;
    userInfo.nickname = user.basic.userName;
    userInfo.avatar = user.basic.avatarUrl;
    
    
    STCommentInfo *cI = [[STCommentInfo alloc] init];
    cI.total = [NSNumber numberWithInteger:0];
    
    AnswerMode *amode = [[AnswerMode alloc] init];
    amode.content = [SquareLogic sharedInstance].sT.content;
    amode.proData = [SquareLogic sharedInstance].sT.gMode;
    amode.userInfo = userInfo;
    amode.links = [SquareLogic sharedInstance].sT.imageArray;
    amode.comments = cI;
    
    AnswerModeFrame *anFrame = [[AnswerModeFrame alloc] init];
    anFrame.aMode = amode;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SimulationAddAnswerCompletionNotification" object:anFrame];

}


#pragma mark - 按钮事件响应
- (void)chooseBtnClicked:(id)sender
{
    [_textView resignFirstResponder];
    
    [[SquareLogic sharedInstance] setGMode:nil];
    
    GoodsResultsViewController *gVC = [[GoodsResultsViewController alloc] init];
    gVC.orderInfo = _orderInfo;
    [self.navigationController pushViewController:gVC animated:YES];
}

- (void)albumBtnClicked:(id)sender
{
    [_textView resignFirstResponder];
    
    LXActionSheet *actionSheet = [[LXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照", @"从手机相册中选择"]];
    [actionSheet showInView:self.view];
}


#pragma mark - SCGoodsViewDelegate
- (void)goodsViewDisappear {
    [_goodView removeFromSuperview];
    _goodView = nil;
    _mode = nil;
    
    [_cv setFrame:CGRectMake(15, CGRectGetMaxY(_chooseBtn.frame)+20, SCREEN_WIDTH-30, K_S_W*2+4)];
}

#pragma mark - 执行消息事件
- (void)addGoodsMode:(NSNotification *)notification {
    _mode = [SquareLogic sharedInstance].gMode;
    if (_mode) {
        
        if (!_goodView) {
            SCGoodsView *goodView = [[SCGoodsView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_albumBtn.frame) + 15, SCREEN_WIDTH - 30, 64)];
            _goodView  = goodView;
            _goodView.delegate = self;
            [self.view addSubview:_goodView];
        }
        
        [_goodView setMode:_mode];
        
        
        [_cv setFrame:CGRectMake(15, CGRectGetMaxY(_goodView.frame)+20, SCREEN_WIDTH-30, K_S_W*2+4)];
    }
}

- (void)addPic:(NSNotification *)notification {
    _imageArray = [SquareLogic sharedInstance].selectImages;
    [_cv reloadData];
    
    if (_imageArray.count == KPhotoShowMaxCount) {
        [_albumBtn setEnabled:NO];
    }
}


#pragma mark collectionView
#pragma mark - collectionView data source
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imageArray.count == KPhotoShowMaxCount) {
        return _imageArray.count;
    }
    else if (_imageArray.count > 0 && _imageArray.count  < KPhotoShowMaxCount){
        return [_imageArray count] + 1;
    }
    return 0;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat m_unit = K_S_W;
    CGFloat m_Width = m_unit;
    
    return CGSizeMake(m_unit, m_Width);
}

//设定全局的行间距，如果想要设定指定区内Cell的最小行距，可以使用下面方法
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0f;
}

//设定全局的Cell间距，如果想要设定指定区内Cell的最小间距，可以使用下面方法：
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //删除重用
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *mv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_S_W, K_S_W)];
    //填充方式
    [mv setContentMode:UIViewContentModeScaleAspectFill];
    mv.layer.masksToBounds = YES;
    
    if (_imageArray.count == KPhotoShowMaxCount) {
        [mv setImage:_imageArray[indexPath.row]];
    }
    else{
        if (indexPath.row == _imageArray.count) {
            [mv setImage:[UIImage imageNamed:@"squre_add_image.png"]];
        }
        else
            [mv setImage:_imageArray[indexPath.row]];
    }
    
    [cell.contentView addSubview:mv];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_imageArray.count == KPhotoShowMaxCount)  {
        // 图片游览器
        [self pickerBrowserWithIndexPath:indexPath];
    }
    else{
        if (indexPath.row == _imageArray.count) {
            [self albumBtnClicked:nil];
        }
        else{
            // 图片游览器
            [self pickerBrowserWithIndexPath:indexPath];
        }
    }
}

- (void)pickerBrowserWithIndexPath:(NSIndexPath *)indexPath{
    // 图片游览器
    _broswerVC = [[STPhotoBrowserViewController alloc] init];
    _broswerVC.delegate = self;
    _broswerVC.dataSource = self;
    _broswerVC.showType = STShowImageTypeImageBroswer;
    // 是否可以删除照片
    _broswerVC.editing = YES;
    // 当前选中的值
    _broswerVC.currentIndexPath = indexPath;

    [self.navigationController pushViewController:_broswerVC animated:YES];
}


#pragma mark - STPhotoBrowserViewControllerDataSource
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(STPhotoBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(STPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.imageArray.count;
}

- (STBrowserPhoto *)photoBrowser:(STPhotoBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    STBrowserPhoto *photo = [[STBrowserPhoto alloc] init];
    photo.photoImage = [self.imageArray objectAtIndex:indexPath.row];

    return photo;
}


#pragma mark - STPhotoBrowserViewControllerDelegate
// 删除当前页面的图片
- (void)photoBrowserDeleteCurrentPage:(STPhotoBrowserViewController *)photoBrowser {
    _imageArray = [SquareLogic sharedInstance].selectImages;
    [_cv reloadData];
    [_broswerVC reloadData];
    
    if (_imageArray.count < KPhotoShowMaxCount) {
        [_albumBtn setEnabled:YES];
    }
}

#pragma mark - LXActionSheetDelegate
- (void)actionSheet:(LXActionSheet *)mActionSheet didClickOnButtonIndex:(int)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //照相机
            DMCameraViewController * pVC = [[DMCameraViewController alloc] init];
            [self.navigationController pushViewController:pVC animated:YES];;
        }
            break;

        case 1:
        {
            //相簿
            [self getPhotoGroups];
        }
            break;
            
            
        default:
            break;
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger mx = textView.text.length - range.length + text.length;
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [_textView resignFirstResponder];        
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        return NO;
    }
    
#define MY_MAX 150
    if (mx > MY_MAX)
    {
        NSString *substring = [text substringToIndex:MY_MAX - (textView.text.length - range.length)];
        NSMutableString *lastString = [textView.text mutableCopy];
        [lastString replaceCharactersInRange:range withString:substring];
        textView.text = [lastString copy];
        return NO;
    }
    else
    {
        return YES;
    }
}

// 获取所有相册分组
- (void)getPhotoGroups {
    //获取相册所有分组
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[STPhotoPickerDatas defaultPicker] getAllGroupWithPhotos:^(id obj) {
            
            PhotoGroupViewController * mVC = [[PhotoGroupViewController alloc] init];
            mVC.maxCount = KPhotoShowMaxCount - _imageArray.count;
            mVC.groups = (NSArray *)obj;
            [weakSelf.navigationController pushViewController:mVC animated:YES];

        }];
    });
}


// 清除数据
- (void)clearData {
    _goodView = nil;
    _mode = nil;
    _imageArray = nil;
    
    [SquareLogic sharedInstance].gMode = nil;
    [SquareLogic sharedInstance].selectImages = nil;
}



@end
