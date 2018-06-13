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
@end
