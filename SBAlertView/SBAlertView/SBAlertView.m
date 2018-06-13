//
//  SBAlertView.m
//  SBAlertView
//
//  Created by qyb on 2018/6/8.
//  Copyright © 2018年 qyb. All rights reserved.
//
#import <objc/runtime.h>
#import "SBAlertView.h"
#import "SBAlertQueue.h"
#import "SBAlertController.h"

static CGFloat leftDistance = 25;
static CGFloat rightDistance = 25;
static CGFloat topDistance = 0;
static CGFloat bottomDistance = 0;

static CGFloat alertBoundsDistance = 25;

@interface SBAlertView () <CAAnimationDelegate>
@property (nonatomic) NSArray *layoutItems;
@end
@implementation SBAlertView
{
    CGFloat _baseWidth;
    BOOL _privateVisible;
    NSArray <UIView *> * _priviteItems;
}
@synthesize visible = _privateVisible;
@synthesize items = _priviteItems;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initContent];
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        [self initContent];
    }
    return self;
}
- (void)initContent{
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
}


- (void)alertLayouts{
    UIView *previous = nil;
    NSArray *result = [self parallelCombination];
    UIView *baseItem = result[1];
    NSArray *layoutItems = result[0];
    //width
    CGFloat alertWidth = baseItem.sb_itemSize.width+leftDistance+rightDistance;
    alertWidth = alertWidth > ([UIScreen mainScreen].bounds.size.width - alertBoundsDistance*2) ? ([UIScreen mainScreen].bounds.size.width - alertBoundsDistance*2):alertWidth;
    for (int i = 0; i < layoutItems.count; i ++) {
        UIView *item = layoutItems[i];
        //size
        item.frame = CGRectMake(0, 0, item.sb_itemSize.width>alertWidth?alertWidth:item.sb_itemSize.width, item.sb_itemSize.height);
        //center
        //1.通过alertWidth 得到初始 center
        item.center = CGPointMake(alertWidth/2.f, CGRectGetMaxY(previous.frame)+item.sb_itemSize.height/2);
        //2.通过centerOffset 重计算 只计算x坐标
        item.center = CGPointMake(item.center.x+item.sb_centerOffset.x, item.center.y);
        //3.通过boundsInsets 重计算  只计算 自己的top和和previous 的 bottom
        item.center = CGPointMake(item.center.x, item.center.y+item.sb_boundsInsets.top+previous.sb_boundsInsets.bottom);
        //4. 如果是第一个Item
        if (previous == nil) {
            item.center = CGPointMake(item.center.x, item.center.y+topDistance);
        }
        [self addSubview:item];
        //作为previous 结束
        previous = item;
    }
    //height
    CGFloat height = CGRectGetMaxY(previous.frame)+bottomDistance+previous.sb_boundsInsets.bottom;
    if (height > [UIScreen mainScreen].bounds.size.height-140) {
        height = [UIScreen mainScreen].bounds.size.height-140;
    }
    self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-alertWidth)/2, ([UIScreen mainScreen].bounds.size.height-height)/2, alertWidth, height);
}

- (NSArray *)parallelCombination{
    NSMutableArray *datas = [NSMutableArray new];
    NSMutableArray *collections = nil;
    UIView *previous = nil;
    NSMutableArray *news = [NSMutableArray new];
    NSMutableArray *indexs = [NSMutableArray new];
    for (int i = 0; i < self.items.count; i ++) {
        UIView *item = self.items[i];
        if (item.sb_parallel) {
            if (!collections) collections = [NSMutableArray new];
            [collections addObject:item];
        }
        if ((previous.sb_parallel && !item.sb_parallel) || (item.sb_parallel && (i == self.items.count - 1))) {
            NSInteger count = news.count;
            [news addObject:@(count)];//插入占位符号
            [indexs addObject:@(count)];
            [datas addObject:collections];
            collections = nil;
        }
        if (!item.sb_parallel) {
            [news addObject:item];
        }
        previous = item;
    }
    for (int i = 0; i < datas.count; i ++) {
        NSArray *collections = datas[i];
        NSInteger index = [indexs[i] integerValue];
        //new
        UIView *layout = [[UIView alloc] init];
        layout.sb_parallel = YES;
        //delete
        UIView *lastItem = (UIView *)collections.lastObject;
        //init
        layout.sb_boundsInsets = lastItem.sb_boundsInsets;
        layout.sb_itemSize = CGSizeMake(0, lastItem.sb_itemSize.height);
        previous = nil;
        for (int i = 0; i < collections.count; i ++) {
            UIView *item = collections[i];
            [layout addSubview:item];
            item.frame = CGRectMake(CGRectGetMaxX(previous.frame)+previous.sb_boundsInsets.right+item.sb_boundsInsets.left, (layout.sb_itemSize.height-item.sb_itemSize.height)/2, item.sb_itemSize.width, item.sb_itemSize.height);
            previous = item;
        }
        layout.sb_itemSize = CGSizeMake(CGRectGetMaxX(previous.frame)+previous.sb_boundsInsets.right, lastItem.sb_itemSize.height);
        
        [news replaceObjectAtIndex:index withObject:layout];
    }
    
    UIView *baseItem = nil;
    for (UIView *item in news) {
        if (item.sb_maxWidthBase) {
            baseItem = item;
        }else{
            baseItem = item.sb_itemSize.width > baseItem.sb_itemSize.width ? item:baseItem;
        }
    }
    return @[news.copy,baseItem];
}
#pragma mark    -  SBAlertDelegate
- (UIAlertControllerStyle)alertStyle{
    return UIAlertControllerStyleAlert;
}
- (void)dissmiss{
    if ([[SBAlertQueue sharedInstance] topAlert] == self) {
        [[SBAlertController shareAlert] dissmiss];
    }else{
        [[SBAlertQueue sharedInstance] removeAlert:self];
    }
}
- (void)reloadData{
    [self alertLayouts];
}

- (void)showAnimationWithCompleted:(void(^)(id <SBAlertDelegate> alert))completedBlock{
    //alertview animation
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        if (completedBlock) {
            completedBlock(self);
        }
    }];

    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transform.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    transform.keyTimes = @[ @0, @0.5, @1 ];
    transform.fillMode = kCAFillModeForwards;
    transform.removedOnCompletion = YES;
    transform.duration = .3;
    [self.layer addAnimation:transform forKey:@"transform"];
}

- (void)dissmissAnimationWithCompleted:(void(^)(id <SBAlertDelegate> alert))completedBlock{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (completedBlock) {
            completedBlock(self);
        }
    }];
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transform.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    transform.keyTimes = @[ @0, @0.5, @1 ];
    transform.fillMode = kCAFillModeRemoved;
    transform.duration = .2;
    transform.removedOnCompletion = YES;
    [self.layer addAnimation:transform forKey:@"transform"];
}

#pragma mark   -
- (void)dealloc{
    NSLog(@"alertview  dealloc");
}
@end
