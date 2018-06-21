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
// 添加 Alert
- (void)addAlert:(id)alertView;
// 移除 Alert
- (void)removeAlert:(id)alertView;
// Alert Count
- (NSInteger)alertsCount;
//队列顶部Alert
- (id)topAlert;

@end
