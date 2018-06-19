//
//  UIView+SBAlertItem.h
//  SBAlertView
//
//  Created by qyb on 2018/6/9.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SBAlertItem)
//必须的属性 根据它设置相对布局
@property (nonatomic) CGSize sb_itemSize;
//中心点偏移 一般只调节横坐标 x
@property (nonatomic) CGPoint sb_centerOffset;
//边缘间距 相对于其他item 调节 y,left 和 right 只在 sb_parallelToPrevious 起作用
@property (nonatomic) UIEdgeInsets sb_boundsInsets;
//是否平行于上一个 Item  默认NO ， 为 YES  会与上一个Item平行
@property (nonatomic) BOOL sb_parallel;
// 最宽的基准 ，布局时将会以这个作为基准来设置外部Alert宽度 ，都没有找到将会以最宽item计算 默认 NO
@property (nonatomic) BOOL sb_maxWidthBase;
//换行
@property (nonatomic) BOOL sb_newline;

#pragma mark   -  Private
//
//@property (nonatomic) NSInteger sb_alertIndex;

- (void)sb_addTapActionBlock:(void(^)(id alertView,NSUInteger index))actionBlock tag:(NSUInteger)tag alertView:(id)alertView;

@end
