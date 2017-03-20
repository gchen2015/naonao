//
//  DemandMenu.h
//  Naonao
//
//  Created by 刘敏 on 16/3/3.
//  Copyright © 2016年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "MTLModel.h"


@interface DemandMenu : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSMutableArray* sceneArray;
@property (nonatomic, strong) NSMutableArray* bodyParamsArray;
@property (nonatomic, strong) NSMutableArray* categoryArray;
@property (nonatomic, strong) NSMutableArray* styleArray;
@property (nonatomic, strong) NSMutableArray* bodyDefectArray;
@property (nonatomic, strong) NSMutableArray* subCategoryArray;     //产品的二级分类

@end




// 场景
@interface sceneModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSArray *styleArray;

@end




// 身材类型
@interface bodyParamsModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *desc;

@end




// 商品类型
@interface categoryModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString *image;

@end




// 风格类型
@interface styleModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *icon;

@end





// 身材缺陷
@interface bodyDefectModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber* mId;
@property (nonatomic, strong) NSString* name;

@end





