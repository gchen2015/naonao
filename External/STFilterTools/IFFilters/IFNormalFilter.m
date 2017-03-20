//
//  IFNormalFilter.m
//  STFilterTools
//
//  Created by Richard Liu on 15/5/27.
//  Copyright (c) 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.


#import "IFNormalFilter.h"

NSString *const kIFNormalShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;

 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation IFNormalFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFNormalShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
