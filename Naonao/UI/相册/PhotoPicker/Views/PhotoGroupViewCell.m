//
//  PhotoGroupViewCell.m
//  Naonao
//
//  Created by 刘敏 on 16/6/28.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "PhotoGroupViewCell.h"
#import "STPhotoPickerGroup.h"

@interface PhotoGroupViewCell ()

@property (weak, nonatomic) UIImageView *groupImageView;
@property (weak, nonatomic) UILabel *groupNameLabel;
@property (weak, nonatomic) UILabel *groupPicCountLabel;

@end

@implementation PhotoGroupViewCell

+ (PhotoGroupViewCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"PhotoGroupViewCell";
    
    PhotoGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PhotoGroupViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView {
    UIImageView *groupImageView = [[UIImageView alloc] init];
    _groupImageView = groupImageView;
    _groupImageView.frame = CGRectMake(14, 10.5, 69, 69);
    _groupImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_groupImageView];
    
    //组名
    UILabel *groupNameLabel = [[UILabel alloc] init];
    _groupNameLabel = groupNameLabel;
    _groupNameLabel.frame = CGRectMake(98, 24, self.frame.size.width - 100, 20);
    [self.contentView addSubview:_groupNameLabel];
    
    //相片数量
    UILabel *groupPicCountLabel = [[UILabel alloc] init];
    _groupPicCountLabel = groupPicCountLabel;
    _groupPicCountLabel.font = [UIFont systemFontOfSize:13];
    _groupPicCountLabel.frame = CGRectMake(98, 46, self.frame.size.width - 100, 20);
    [self.contentView addSubview:_groupPicCountLabel];
}

- (void)setCellWithCellInfo:(STPhotoPickerGroup *)group {
    self.groupNameLabel.text = group.groupName;
    self.groupImageView.image = group.thumbImage;
    self.groupPicCountLabel.text = [NSString stringWithFormat:@"%ld",(long)group.assetsCount];
}

@end
