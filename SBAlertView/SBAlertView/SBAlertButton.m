//
//  SBAlertButton.m
//  SBAlertView
//
//  Created by qyb on 2018/6/11.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "SBAlertButton.h"

NSInteger const baesTag = 1000;

@implementation SBAlertButton
{
     NSUInteger _tag;
    __weak id _alertView;
    void(^_actionBlock)(NSUInteger index, id alertView);
}
- (void)addActionBlock:(void(^)(NSUInteger index, id alertView))actionBlock tag:(NSUInteger)tag alertView:(id)alertView{
    _actionBlock = actionBlock;
    _tag = tag;
    _alertView = alertView;
    [self addTarget:self action:@selector(alertAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)alertAction:(UIButton *)sender{
    if (_actionBlock) {
        _actionBlock(_tag-baesTag,_alertView);
    }
}
@end
