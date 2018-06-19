//
//  UIView+SBAlertItem.m
//  SBAlertView
//
//  Created by qyb on 2018/6/9.
//  Copyright © 2018年 qyb. All rights reserved.
//
#import <objc/runtime.h>
#import "UIView+SBAlertItem.h"

@implementation UIView (SBAlertItem)

- (void)setSb_itemSize:(CGSize)sb_itemSize{
    objc_setAssociatedObject(self, @selector(sb_itemSize), [NSValue valueWithCGSize:sb_itemSize], OBJC_ASSOCIATION_ASSIGN);
}

- (CGSize)sb_itemSize{
    return [(NSValue *)objc_getAssociatedObject(self, _cmd) CGSizeValue];
}

- (void)setSb_centerOffset:(CGPoint)sb_centerOffset{
    objc_setAssociatedObject(self, @selector(sb_centerOffset), [NSValue valueWithCGPoint:sb_centerOffset], OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)sb_centerOffset{
    return [(NSValue *)objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setSb_boundsInsets:(UIEdgeInsets)sb_boundsInsets{
    objc_setAssociatedObject(self, @selector(sb_boundsInsets), [NSValue valueWithUIEdgeInsets:sb_boundsInsets], OBJC_ASSOCIATION_ASSIGN);
}

- (UIEdgeInsets)sb_boundsInsets{
    return [(NSValue *)objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setSb_parallel:(BOOL)sb_parallel{
    objc_setAssociatedObject(self, @selector(sb_parallel), @(sb_parallel), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)sb_parallel{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setSb_maxWidthBase:(BOOL)sb_maxWidthBase{
    objc_setAssociatedObject(self, @selector(sb_maxWidthBase), @(sb_maxWidthBase), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)sb_maxWidthBase{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setSb_newline:(BOOL)sb_newline{
    objc_setAssociatedObject(self, @selector(sb_newline), @(sb_newline), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)sb_newline{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)sb_setBlock:(id)block tag:(NSUInteger)tag alert:(id)alert{
    objc_setAssociatedObject(self, "_sb.alert.action.block", block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, "_sb.alert.action.tag", @(tag), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, "_sb.alert.action.alert", alert, OBJC_ASSOCIATION_ASSIGN);
}

- (id)sb_alert_actionBlock{
    return objc_getAssociatedObject(self, "_sb.alert.action.block");
}
- (NSUInteger)sb_alert_actionTag{
    return [objc_getAssociatedObject(self, "_sb.alert.action.tag") integerValue];
}
- (id)sb_alert_actionAlert{
    return objc_getAssociatedObject(self, "_sb.alert.action.alert");
}
- (void)sb_addTapActionBlock:(void(^)(id alertView,NSUInteger index))actionBlock tag:(NSUInteger)tag alertView:(id)alertView{
    [self sb_setBlock:actionBlock tag:tag alert:alertView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sb_alertAction:)];
    [self addGestureRecognizer:tap];
    if (!self.userInteractionEnabled) {
        self.userInteractionEnabled = YES;
    }
}


- (void)sb_alertAction:(UIButton *)sender{
    void(^actionBlock)(id alertView,NSUInteger index) = [self sb_alert_actionBlock];
    if (actionBlock) {
        actionBlock([self sb_alert_actionAlert],[self sb_alert_actionTag]);
    }
}
@end
