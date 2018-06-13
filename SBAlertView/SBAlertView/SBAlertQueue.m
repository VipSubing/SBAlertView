//
//  SBAlertQueue.m
//  SBAlertView
//
//  Created by qyb on 2018/6/8.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "SBAlertQueue.h"

@implementation SBAlertQueue
{
    NSMutableArray *_alertQueue;
}


+ (instancetype)sharedInstance
{
    static SBAlertQueue *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SBAlertQueue alloc] init];
    });
    
    return _sharedInstance;
}
- (instancetype)init{
    if (self = [super init]) {
        _alertQueue = [NSMutableArray new];
    }
    return self;
}

- (NSInteger)alertsCount{
    return _alertQueue.count;
}

- (void)addAlert:(id)alertView
{
    [_alertQueue addObject:alertView];
}

- (void)removeAlert:(id)alertView
{
    [_alertQueue removeObject:alertView];
}

- (id)topAlert{
    return [_alertQueue firstObject];
}
@end
