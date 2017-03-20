//
//  ZWTagListView.h
//  自定义流式标签
//
//  Created by zhangwei on 15/10/22.
//  Copyright (c) 2015年 zhangwei. All rights reserved.
//

#import "ZWTagListView.h"


#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      10.0f



@implementation ZWTagListView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        totalHeight=0;
        self.frame=frame;
    }
    return self;
}
-(void)setTagWithTagArray:(NSArray*)arr{
    
    previousFrame = CGRectZero;
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        UILabel*tag=[[UILabel alloc]initWithFrame:CGRectZero];
        
        if(_signalTagColor){
            //可以单一设置tag的颜色
            tag.backgroundColor=_signalTagColor;
        }
        
        tag.textAlignment = NSTextAlignmentCenter;
        tag.textColor = [UIColor whiteColor];
        tag.font = [UIFont boldSystemFontOfSize:13];
        tag.text = str;
        tag.layer.cornerRadius = 3;
        tag.clipsToBounds=YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]};
        CGSize Size_str=[str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*2;
        Size_str.height += VERTICAL_PADDING*2;
        CGRect newRect = CGRectZero;
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
            newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
        }
        newRect.size = Size_str;
        [tag setFrame:newRect];
        previousFrame = tag.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tag];
    }
     ];
}
#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}
@end
