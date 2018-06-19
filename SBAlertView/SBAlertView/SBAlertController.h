//
//  SBAlertController.h
//  SBAlertView
//
//  Created by qyb on 2018/6/8.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBAlertDelegate.h"
#import "UIView+SBAlertItem.h"

/**
 AlertView整体的控制器， 掌控所有Alert的显示和隐藏 ，本身是一个单例
 */
@interface SBAlertController : NSObject

// 是否有 Alert正在显示
@property (nonatomic , getter=isVisible) BOOL visible;
//  当前正在显示的AlertView ，没有显示时 nil
@property (nonatomic,readonly) id <SBAlertDelegate> alertView;
// 通过 style 生成Alert
+ (id <SBAlertDelegate>)alertViewWithStyle:(UIAlertControllerStyle)style;
// 单例
+ (instancetype)shareAlert;
// 展示特定的 alertview
- (void)showAlert:(id <SBAlertDelegate>)alertView;
//使正在显示的Alert消失
- (void)dissmiss;

@end
