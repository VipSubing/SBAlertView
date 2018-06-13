//
//  SBAlertQueue.h
//  SBAlertView
//
//  Created by qyb on 2018/6/8.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 保存alert所在，可以按序列显示多个alert
 */
@interface SBAlertQueue : NSObject

+ (instancetype)sharedInstance;

- (void)addAlert:(id)alertView;

- (void)removeAlert:(id)alertView;

- (NSInteger)alertsCount;

- (id)topAlert;

@end
