//
//  ShapeInfoCell.m
//  Naonao
//
//  Created by 刘敏 on 16/6/17.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "ShapeInfoCell.h"
#import "UserLogic.h"
#import "InterestModel.h"

@interface ShapeInfoCell ()

@property (nonatomic, weak) UIImageView *headV;
@property (nonatomic, weak) UILabel *titA;
@property (nonatomic, weak) UILabel *desL;

@end


@implementation ShapeInfoCell

+ (ShapeInfoCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ShapeInfoCell";
    
    ShapeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ShapeInfoCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpChildView];
    }
    
    return self;
}

- (void)setUpChildView{
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
    _headV = headV;
    [self.contentView addSubview:_headV];
    
    UILabel *titA = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, 60, 30)];
    _titA = titA;
    [_titA setFont:[UIFont systemFontOfSize:14.0]];
    [_titA setTextColor:BLACK_COLOR];
    [self.contentView addSubview:_titA];
    
    UILabel *desL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 5, 100, 60)];
    _desL = desL;
    [_desL setNumberOfLines:0];
    [_desL setFont:[UIFont systemFontOfSize:14.0]];
    [_desL setTextColor:[UIColor blackColor]];
    [_desL setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_desL];
    
}

- (void)setCellWithCellInfo:(NSUInteger)mRow setArray:(NSArray *)mArray{
    
    NSString *imageName = nil;
    NSString *titS = nil;
    NSString *des = nil;
    
    User *user = [[UserLogic sharedInstance] getUser];
    
    switch (mRow) {
        case 0:
            imageName = @"shape_age_icon.png";
            titS = @"我是";
            des = [NSString stringWithFormat:@"%@后", user.body.lifeStage];
            break;
            
        case 1:
            imageName = @"shape_size_icon.png";
            titS = @"体型";
            des = user.body.bodyStyle;
            break;
            
        case 2:
        {
            imageName = @"shape_defect_icon.png";
            titS = @"改善";
            
            NSMutableArray *temA = [NSMutableArray arrayWithCapacity:user.body.bodydefect.count];
            for (NSNumber *item in user.body.bodydefect) {
                switch ([item integerValue]) {
                    case KBodyCharacterNone:
                        [temA addObject:@"无"];
                        break;
                        
                    case KWaistThick:
                        [temA addObject:@"腰粗"];
                        break;
                        
                    case KShoulderBreadth:
                        [temA addObject:@"肩宽"];
                        break;
                        
                    case KArmCoarse:
                        [temA addObject:@"胳膊粗"];
                        break;
                        
                    case KHaveBelly:
                        [temA addObject:@"有肚腩"];
                        break;
                        
                    case KLegThick:
                        [temA addObject:@"腿粗"];
                        break;
                        
                    case KNeckCoarse:
                        [temA addObject:@"脖子粗"];
                        break;
                        
                    case KBigChest:
                        [temA addObject:@"大胸"];
                        break;
                        
                    case KFlatChest:
                        [temA addObject:@"平胸"];
                        break;
                        
                    case KBigHips:
                        [temA addObject:@"PP大"];
                        break;
                        
                    case KShortLegs:
                        [temA addObject:@"腿短"];
                        break;
                        
                    case KBigFace:
                        [temA addObject:@"脸大"];
                        break;
                        
                    default:
                        break;
                }
            }
 
            des = [temA componentsJoinedByString:@"、"];
        }
            break;
            
        case 3:
            imageName = @"shape_weight_icon.png";
            titS = @"体重";
            des = [NSString stringWithFormat:@"%@kg", user.body.weight];
            break;
            
        case 4:
            imageName = @"shape_height_icon.png";
            titS = @"身高";
            des = [NSString stringWithFormat:@"%@cm", user.body.height];
            break;
            
        case 5:
            imageName = @"shape_chest_icon.png";
            titS = @"胸围";
            des = user.body.bust;
            break;
            
        case 6:
            imageName = @"shape_waist_icon.png";
            titS = @"腰围";
            des = [NSString stringWithFormat:@"%@cm", user.body.waistline];
            break;
            
        case 7:
            imageName = @"shape_hip_icon.png";
            titS = @"臀围";
            des = [NSString stringWithFormat:@"%@cm", user.body.hipline];
            break;
            
        case 8:
            imageName = @"shape_shoes_icon.png";
            titS = @"鞋码";
            des = [NSString stringWithFormat:@"%@码", user.body.shoes];
            break;
            
        case 9:
        {
            imageName = @"shape_hobby_icon.png";
            titS = @"爱好";
            
            NSMutableArray *temA = [NSMutableArray arrayWithCapacity:mArray.count];
            for (InterestModel *md in mArray) {
                [temA addObject:md.name];
            }
            
            des = [temA componentsJoinedByString:@"、"];
        }

            break;
            
            
        default:
            break;
    }
    
    [_headV setImage:[UIImage imageNamed:imageName]];
    [_titA setText:titS];
    [_desL setText:des];
    
}

@end
