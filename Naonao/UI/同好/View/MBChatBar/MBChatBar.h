//
//  MBChatBar.h
//  MeeBra
//
//  Created by Richard Liu on 15/10/16.
//  Copyright © 2015年 广州杉川投资管理有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COVER_HEIGHT        49.0f

@protocol MBChatBarDelegate;

@interface MBChatBar : UIView

@property (weak, nonatomic) id<MBChatBarDelegate> delegate;

/**
 *  弹出键盘
 */
- (void)showKeyboard:(NSString *)pStr;


/**
 *  回收键盘
 */
- (void)recyclingKeyboard;

/**
 *  清楚输入框中内容
 */
- (void)clearData;

@end


@protocol MBChatBarDelegate <NSObject>



@optional

//发送消息
- (void)chatBar:(MBChatBar *)chatBar sendMessage:(NSString *)msg;

- (void)growingTextViewDidBeginEditing;



@end
