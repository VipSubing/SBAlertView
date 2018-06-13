//
//  SBAlertController+Status.h
//  SBAlertView
//
//  Created by qyb on 2018/6/11.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "SBAlertController.h"

@interface SBAlertController (Status)
/**
 展示失败状态
 
 @param message message
 @return alertview
 */
+ (id <SBAlertDelegate> )showFailWithMessage:(NSString *)message;

/**
 展示成功状态
 
 @param message message
 @return alertview
 */
+ (id <SBAlertDelegate> )showSuccessWithMessage:(NSString *)message;

/**
 展示成功状态
 
 @param message message
 @param timeInterval 倒计时 为0 不显示倒计时
 @return alertview
 */
+ (id <SBAlertDelegate> )showSuccessWithMessage:(NSString *)message
                      afterTimeInterval:(NSTimeInterval)timeInterval;


/**
 展示状态

 @param success 成功与否
 @param message message
 @param timeInterval 倒计时 为0 不显示倒计时
 @return alertview
 */
+ (id <SBAlertDelegate> )showWithStatus:(BOOL)success
                        message:(NSString *)message
              afterTimeInterval:(NSTimeInterval)timeInterval;


/**
 展示状态
 
 @param success 成功与否
 @param message message
 @param timeInterval 倒计时 为0 不显示倒计时
 @param completedBlock  显示完毕回调
 @return alertview
 */
+ (id <SBAlertDelegate> )showWithStatus:(BOOL)success
                        message:(NSString *)message
              afterTimeInterval:(NSTimeInterval)timeInterval
                 completedBlock:(void(^)(void))completedBlock;



/**
 
展示错误详情
 @param title error title
 @param descTitle decsTitle
 @param desc desc
 @param block 回调
 @param cancelButtonTitle cancle title
 @param otherButtonTitl desc
  @return alert view
 */
+ (id <SBAlertDelegate> )showErrorWithTitle:(NSString *)title
                          descTitle:(NSString *)descTitle
                               desc:(NSString *)desc
                    completionBlock:(void (^)(NSUInteger buttonIndex, id <SBAlertDelegate> alertView))block
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSString *)otherButtonTitles, ...;
/**
 展示错误详情

 @param title error title
 @param icon error icon
 @param descTitle decsTitle
 @param desc desc
 @param block 回调
 @param cancelButtonTitle cancle title
 @param otherButtonTitles nil ...
 @return alert view
 */
+ (id <SBAlertDelegate> )showErrorWithTitle:(NSString *)title
                               icon:(UIImage *)icon
                          descTitle:(NSString *)descTitle
                               desc:(NSString *)desc
                    completionBlock:(void (^)(NSUInteger buttonIndex, id <SBAlertDelegate> alertView))block
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSString *)otherButtonTitles, ...;

/**
 展示错误详情
 
 @param title error title
 @param icon error icon
 @param descTitle decsTitle
 @param desc desc
 @titleAttributes title attribute  个性化设定 title文字属性
 @descAttributes desc attribute  个性化设定 desc 文字属性
 @param block 回调
 @param cancelButtonTitle cancle title
 @param otherButtonTitles nil ...
 @return alert view
 */
+ (id <SBAlertDelegate> )showErrorWithTitle:(NSString *)title
                               icon:(UIImage *)icon
                          descTitle:(NSString *)descTitle
                               desc:(NSString *)desc
                    titleAttributes:(NSDictionary *)titleAttributes
                  descAttributes:(NSDictionary *)descAttributes
                    completionBlock:(void (^)(NSUInteger buttonIndex, id <SBAlertDelegate> alertView))block
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSArray *)otherTitles;
@end
