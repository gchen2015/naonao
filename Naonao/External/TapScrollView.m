//
//  TapScrollView.m
//  Shitan
//
//  Created by 刘敏 on 14-10-10.
//  Copyright (c) 2014年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "TapScrollView.h"

@implementation TapScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!self.decelerating) {
		[[self nextResponder] touchesBegan:touches withEvent:event];
	}
	
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!self.decelerating) {
		[[self nextResponder] touchesMoved:touches withEvent:event];
	}
	
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!self.decelerating) {
		[[self nextResponder] touchesEnded:touches withEvent:event];
	}
    
	[super touchesEnded:touches withEvent:event];
}

@end
