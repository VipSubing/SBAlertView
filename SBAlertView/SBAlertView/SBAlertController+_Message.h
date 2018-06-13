//
//  SBAlertController+_Message.h
//  SBAlertView
//
//  Created by qyb on 2018/6/11.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "SBAlertController.h"
@class SBAlertButton;

extern NSString *const kNSTextAlignmentKey;

@interface SBAlertController (_Message)

/**
 显示message

 @param message message
 @return alert view
 */
+ (id <SBAlertDelegate> )showWithMessage:(NSString *)message;


/**
 显示标准提示消息  最上为 Image  icon

 @param title 提示标题
 @param message 提示message
 @param icon 提示icon
 @param block 事件block  buttonIndex == 0默认为 取消按钮
 @param cancelButtonTitle 取消按钮标题
 @param otherButtonTitles 其他标题  末尾以 nil结尾
 @return alertview
 */
+ (id <SBAlertDelegate> )showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                               icon:(UIImage *)icon
                    completionBlock:(void (^)(NSUInteger buttonIndex, id <SBAlertDelegate> alertView))block
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSString *)otherButtonTitles, ...;


+ (id <SBAlertDelegate> )showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                               icon:(UIImage *)icon
                    titleAttributes:(NSDictionary *)titleAttributes
                  messageAttributes:(NSDictionary *)messageAttributes
                    completionBlock:(void (^)(NSUInteger buttonIndex, id <SBAlertDelegate> alertView))block
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSString *)otherButtonTitles, ...;


#pragma mark   - private
+ (UILabel *)titleLabel;

+ (UILabel *)messageLabel;

+ (UIColor *)systemTintColor;

+ (SBAlertButton *)cancleButtonWithButtonCount:(NSInteger)count;

+ (SBAlertButton *)otherButton;

+ (CGFloat)defaultAlertWidth;
@end
