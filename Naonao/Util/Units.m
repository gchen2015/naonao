//
//  Units.m
//  Naonao
//
//  Created by Richard Liu on 15/11/23.
//  Copyright © 2015年 深圳市轩腾华兴科技开发有限公司. All rights reserved.
//

#import "Units.h"
#import <objc/runtime.h>
#import "CoreArchive.h"

NSString *const NewFeatureVersionKey = @"NewFeatureVersionKey";

void AlertWithTitleAndMessage(NSString* title, NSString* message)
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert show];
}

void AlertWithTitleAndMessageAndPay(NSString* title, NSString* message, id delegate,
                                      NSString* button1)
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"继续付款"
                                          otherButtonTitles:button1, nil];
    
    [alert show];
}

void AlertWithTitleAndMessageAndBtton(NSString* title, NSString* message, id delegate,
                                      NSString* button1)
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:button1, nil];
    
    [alert show];
}

void AlertWithTitleAndMessageAndUnits(NSString* title, NSString* message, id delegate,
                                      NSString* button1, NSString* button2)
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:button1, button2, nil];
    
    [alert show];
}


void AlertWithTitleAndMessageAndUnitsToTag(NSString* title, NSString* message, id delegate,
                                           NSString* button1, NSString* button2, NSInteger tag)
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles: button1, button2, nil];
    alert.tag = tag;
    
    [alert show];
}


UIImage* ImageWithImageSimple(UIImage *imageA, CGSize newSize){
    UIGraphicsBeginImageContext(newSize);
    
    [imageA drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


@implementation Units
#pragma mark - File

+ (NSString *)docDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths firstObject];
    return docDirectory;
}

+ (NSString*)getProfilePath:(NSString *)paths {
    return [[[Units docDirectory] stringByAppendingString:@"/"] stringByAppendingString:paths];
}

+ (BOOL)removeFileAtPath:(NSString*)path {
    NSError *error;
    return [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
}



+ (NSString*)getTimeStrWithDateFormat:(NSString*)format withTime:(NSTimeInterval)time {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    return timeStr;
    
}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (NSString *)notNilString:(NSString *)string {
    if (string) {
        return string;
    }
    return @"";
}

// 将时间格式化作为文件的名字
+ (NSString *)formatTimeAsFileName
{
    //获取Taday
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
    NSString *currentDateStr = [formater stringFromDate:[NSDate date]];
    currentDateStr = [currentDateStr stringByReplacingOccurrencesOfString:@"_" withString:@""];
    //删除空格
    currentDateStr = [currentDateStr stringByReplacingOccurrencesOfString:@"." withString:@""];

    return currentDateStr;
}


//拼接淘宝商品图片
+ (NSString *)TBImage320Thumbnails:(NSString *)urls
{
    if (urls == nil || (NSNull *)urls == [NSNull null])
    {
        return nil;
    }
    
    NSString *imageURL = [NSString stringWithFormat:@"%@%@", urls, IMAGE_320_320_TAOBAO];
    
    return imageURL;
}


//转换成货币形式
+ (NSString *)currencyStringWithNumber:(NSNumber *)number
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#####0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:number];
    
    return [NSString stringWithFormat:@"￥%@", formattedNumberString];
}

+ (UIViewController*)viewControllerForStoryboardName:(NSString*)storyboardName class:(id)classA
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    NSString* className = nil;
    
    if ([classA isKindOfClass:[NSString class]])
        className = [NSString stringWithFormat:@"%@", classA];
    else
        className = [NSString stringWithFormat:@"%s", class_getName([classA class])];
    
    UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@", className]];
    return viewController;
}


//图像旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


//是否应该显示版本新特性页面
+ (BOOL)canShowNewFeature{
    
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow = [[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    
    //读取本地版本号
    NSString *versionLocal = [CoreArchive strForKey:NewFeatureVersionKey];
    
    //说明有本地版本记录，且和当前系统版本一致
    if(versionLocal!=nil && [versionValueStringForSystemNow isEqualToString:versionLocal])
    {
        return NO;
    }
    else
    {
        //无本地版本记录或本地版本记录与当前系统版本不一致
        //保存
        [CoreArchive setStr:versionValueStringForSystemNow key:NewFeatureVersionKey];
        return YES;
    }
}


// URL编码
+ (NSString *)encodeToPercentEscapeString:(NSString *)input
{
    // Encode all the reserved characters, per RFC 3986
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}


// URL解码
+ (NSString *)decodeFromPercentEscapeString:(NSString *)input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}



@end
