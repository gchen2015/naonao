//
//  IFInkwellFilter.m
//  STFilterTools
//
//  Created by Richard Liu on 15/5/27.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.


#import "IFInkwellFilter.h"

NSString *const kIFInkWellShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     texel = vec3(dot(vec3(0.3, 0.6, 0.1), texel));
     texel = vec3(texture2D(inputImageTexture2, vec2(texel.r, .16666)).r);
     gl_FragColor = vec4(texel, 1.0);
 }
);

@implementation IFInkwellFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFInkWellShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
