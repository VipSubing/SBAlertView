//
//  SBAlertDelegate.h
//  SBAlertView
//
//  Created by qyb on 2018/6/13.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SBAlertView;

@protocol SBAlertDelegate 

@required
//展示方式  ， alert 或 sheet 参照 UIAlertController
@property (nonatomic,readonly) UIAlertControllerStyle alertStyle;
//是否显示 因为Alert存在叠加情况 所以这个属性是必须的
@property (nonatomic , getter=isVisible) BOOL visible;
// 内容 item  ，alertview通过items作为内容完成自动布局
@property (nonatomic) NSArray <UIView *> *items;
//布局
- (void)reloadData;
// 消除动画和完成回调
- (void)dissmissAnimationWithCompleted:(void(^)(id <SBAlertDelegate>  alert))completedBlock;
// 展示动画和完成回调
- (void)showAnimationWithCompleted:(void(^)(id <SBAlertDelegate> alert))completedBlock;
// 手动调动 来消除这个  Alert
- (void)dissmiss;

@end
