//
//  ParallaxHeaderView.h
//  ParallaxTableViewHeader
//
//  Created by Vinodh  on 26/10/14.
//  Copyright (c) 2014 Daston~Rhadnojnainva. All rights reserved.

//

#import <UIKit/UIKit.h>

@interface ParallaxHeaderView : UIView

//@property (nonatomic, weak) UILabel *headerTitleLabel;
//@property (nonatomic, weak) UILabel *desLabel;

@property (nonatomic, strong) NSNumber *style;

@property (nonatomic, strong) NSString *headerURL;

+ (id)parallaxHeaderViewWithCGSize:(CGSize)headerSize;
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;

@end

