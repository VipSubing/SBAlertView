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

@property (nonatomic,readonly) UIAlertControllerStyle alertStyle;

@property (nonatomic , getter=isVisible) BOOL visible;

@property (nonatomic) NSArray <UIView *> *items;

- (void)reloadData;

- (void)dissmissAnimationWithCompleted:(void(^)(id <SBAlertDelegate>  alert))completedBlock;

- (void)showAnimationWithCompleted:(void(^)(id <SBAlertDelegate> alert))completedBlock;

- (void)dissmiss;

@end
