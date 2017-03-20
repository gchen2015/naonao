//
//  TagsTableCell.m
//  Naonao
//
//  Created by Richard Liu on 16/2/23.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "TagsTableCell.h"
#import "IMJIETagFrame.h"
#import "IMJIETagView.h"


@interface TagsTableCell ()<IMJIETagViewDelegate>

@property (nonatomic, weak) UILabel *keyL;

@end

@implementation TagsTableCell

+ (TagsTableCell *)cellWithTableView:(UITableView *)tableView{

    static NSString *ID = @"TagsTableCell";
    
    TagsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //删除重用
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    
    cell = [[TagsTableCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //随机颜色
        UILabel *keyL = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 100, 20)];
        _keyL = keyL;
        [_keyL setTextColor:PINK_COLOR];
        [_keyL setFont:[UIFont boldSystemFontOfSize:18.0]];
        [self.contentView addSubview:_keyL];
    }
    
    return self;
}

- (void)setCellWithCellInfo:(NSArray *)array{
    
    IMJIETagFrame *frame = [[IMJIETagFrame alloc] init];
    frame.tagsMinPadding = 4;
    frame.tagsMargin = 10;
    frame.tagsLineSpacing = 10;
    frame.tagsArray = array;
    
    IMJIETagView *tagView = [[IMJIETagView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.tagsHeight)];
    tagView.clickbool = YES;
    tagView.tagsFrame = frame;
    tagView.clickStart = 0;   //0为单选， 1为多选

    tagView.delegate = self;
    [self.contentView addSubview:tagView];
}


- (void)setCellWithmultiSelectCellInfo:(NSArray *)array key:(NSString *)key
{
    [_keyL setText:key];
    
    IMJIETagFrame *frame = [[IMJIETagFrame alloc] init];
    frame.tagsMinPadding = 4;
    frame.tagsMargin = 10;
    frame.tagsLineSpacing = 10;
    frame.tagsArray = array;
    
    IMJIETagView *tagView = [[IMJIETagView alloc] initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, frame.tagsHeight)];
    tagView.clickbool = YES;
    tagView.tagsFrame = frame;
    tagView.clickStart = 1;   //0为单选， 1为多选
    
    tagView.delegate = self;
    [self.contentView addSubview:tagView];
}



#pragma mark 选中
- (void)IMJIETagView:(NSArray *)tagArray{
    NSLog(@"%@",tagArray);
}


@end



