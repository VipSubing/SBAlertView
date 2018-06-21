//
//  SBAlertController.m
//  SBAlertView
//
//  Created by qyb on 2018/6/8.
//  Copyright © 2018年 qyb. All rights reserved.
//
#import <objc/runtime.h>
#import "SBAlertController.h"
#import "SBAlertQueue.h"
#import "SBAlertView.h"
#import "SBSheetView.h"

static BOOL appDidBecomeActiveFlag = NO;

@interface SBAlertController ()<CAAnimationDelegate,UIGestureRecognizerDelegate>
@property (nonatomic) UIWindow *mainWindow;
// alert window
@property (nonatomic) UIWindow *alertWindow;
// based view
@property (nonatomic) UIView *backgroundView;

@property (nonatomic) UILongPressGestureRecognizer *backgroundTap;

@end

@implementation SBAlertController
@dynamic alertView;

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.windowLevel == windowLevel) {
            return window;
        }
    }
    return nil;
}

+ (instancetype)shareAlert{
    static SBAlertController *alertC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertC = [SBAlertController new];
    });
    return alertC;
}

- (instancetype)init{
    if (self = [super init]) {
//        [self runloopObserve];
        [self initContent];
    }
    return self;
}

+ (id <SBAlertDelegate>)alertViewWithStyle:(UIAlertControllerStyle)style{
    if (style == UIAlertControllerStyleActionSheet) {
        return [[SBSheetView alloc] init];
    }
    return [[SBAlertView alloc] init];
}
- (void)initContent{
    // init windows
    _alertWindow = [self windowWithLevel:UIWindowLevelAlert];
    if (!_alertWindow) {
        _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertWindow.windowLevel = UIWindowLevelAlert;
    }
}
- (void)addBackgroundView{
    //background
    _backgroundView = [[UIView alloc] initWithFrame:_alertWindow.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    _backgroundView.alpha = 0.f;
    _backgroundTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTouchAction:)];
    _backgroundTap.minimumPressDuration = 0.01;
    _backgroundTap.delegate = self;
    [_backgroundView addGestureRecognizer:_backgroundTap];
    [_alertWindow addSubview:_backgroundView];
}
- (UIWindow *)mainWindow{
    if (_mainWindow == nil) {
         _mainWindow = [self windowWithLevel:UIWindowLevelNormal];
    }
    return _mainWindow;
}
- (void)removeBackgroundView{
    [_backgroundView removeFromSuperview];
}

- (void)backgroundAnimationWithShow:(BOOL)show completed:(void (^)(void))completed{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = show?1.f:0.f;
    } completion:^(BOOL finished) {
        if (completed) {
            completed();
        }
    }];
}
- (void)hide:(BOOL)hide{
    self.alertWindow.hidden = hide;
}
- (void)showWithAlert:(id <SBAlertDelegate>)alert{
    if (!alert.isVisible) {
        alert.visible = YES;
        _backgroundTap.enabled = !alert.alertStyle;
        [self.backgroundView addSubview:(UIView *)alert];
        [alert showAnimationWithCompleted:^(id <SBAlertDelegate> alert) {
            
        }];
    }
}
- (void)firstShow{
    //切换到 alert Window
    [self.alertWindow makeKeyAndVisible];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [self.mainWindow tintColorDidChange];
    }
    [self addBackgroundView];
    [self hide:NO];
    // back animation
    [self backgroundAnimationWithShow:YES completed:nil];
    //直接显示
    self.visible = YES;//标记正在显示
    [self showWithAlert:[SBAlertQueue sharedInstance].topAlert];
}

- (void)showAlert:(SBAlertView *)alertView{
    [[SBAlertQueue sharedInstance] addAlert:alertView];
    
    if (!self.isVisible && appDidBecomeActiveFlag) {
        [self firstShow];
    }
}
- (void)dissmiss{
    if ([[SBAlertQueue sharedInstance] alertsCount] == 1) {
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [self.mainWindow tintColorDidChange];
        }
        //back Animation
        [self backgroundAnimationWithShow:NO completed:^{
            //切换回主Window
            [self.mainWindow makeKeyAndVisible];
            [self removeBackgroundView];
            [self hide:YES];
        }];
        
    }
    [self.alertView dissmissAnimationWithCompleted:^(id <SBAlertDelegate>alert) {
        alert.visible = NO;
        //移除队列
        [(UIView *)alert removeFromSuperview];
        [[SBAlertQueue sharedInstance] removeAlert:self.alertView];
       id <SBAlertDelegate> topAlert = [[SBAlertQueue sharedInstance] topAlert];
        if (topAlert) {
            [self showWithAlert:topAlert];
        }else{
            self.visible = NO;
        }
    }];
   
}
- (BOOL)locationInBackgroundWithTouch:(UIGestureRecognizer *)touch{
    CGPoint point = [touch locationInView:_backgroundView];
    UIView *target = (UIView  *)self.alertView;
    point = [_backgroundView convertPoint:point toView:target];
    if (point.x < 0 || point.y < 0 || point.y > target.bounds.size.height || point.x > target.bounds.size.width) {
        return YES;
    }
    return NO;
}
#pragma mark  - Action
- (void)backgroundTouchAction:(UILongPressGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateEnded && [self locationInBackgroundWithTouch:tap]) {
        if (self.alertView.alertStyle == UIAlertControllerStyleActionSheet && [self.alertView isVisible]) {
            [self.alertView dissmiss];
        }
    }
}
#pragma mark  -
+ (void)appDidBecomeActive{
    if (!appDidBecomeActiveFlag) {
        appDidBecomeActiveFlag = YES;
        id <SBAlertDelegate> topAlert = [[SBAlertQueue sharedInstance] topAlert];
        if (topAlert && !topAlert.isVisible) {
            [[SBAlertController shareAlert] firstShow];
        }
    }
}
+ (void)runloopObserve{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

#pragma mark   -  UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;{

    return [self locationInBackgroundWithTouch:gestureRecognizer];
}
#pragma mark   -  Override
+ (void)load{
    [self runloopObserve];
}
- (SBAlertView *)alertView{
    return [[SBAlertQueue sharedInstance] topAlert];
}
@end
