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

@interface SBAlertController : NSObject

@property (nonatomic , getter=isVisible) BOOL visible;

@property (nonatomic,readonly) id <SBAlertDelegate> alertView;

+ (id <SBAlertDelegate>)alertViewWithStyle:(UIAlertControllerStyle)style;

+ (instancetype)shareAlert;

- (void)showAlert:(id <SBAlertDelegate>)alertView;

- (void)dissmiss;

@end
