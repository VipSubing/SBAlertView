//
//  SBAlertController+Status.m
//  SBAlertView
//
//  Created by qyb on 2018/6/11.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "SBAlertController+Status.h"
#import "SBAlertButton.h"
#import "SBAlertController+_Message.h"

@implementation SBAlertController (Status)

+ (id <SBAlertDelegate> )showErrorWithTitle:(NSString *)title
                          descTitle:(NSString *)descTitle
                               desc:(NSString *)desc
                    completionBlock:(void (^)(NSUInteger buttonIndex, id <SBAlertDelegate> alertView))block
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSString *)otherButtonTitles, ...{
    NSMutableArray *otherTitles = [NSMutableArray new];
    if (otherButtonTitles) {
        [otherTitles addObject:otherButtonTitles];
        id arg;
        va_list argList;
        va_start(argList, otherButtonTitles);
        while ((arg = va_arg(argList, id)))
        {
            [otherTitles addObject:arg];
        }
        va_end(argList);
    }
    return [self showErrorWithTitle:title icon:[UIImage imageNamed:@"fail"] descTitle:descTitle desc:desc titleAttributes:nil descAttributes:nil completionBlock:block cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherTitles.copy];;
}

+ (id <SBAlertDelegate> )showErrorWithTitle:(NSString *)title
                               icon:(UIImage *)icon
                          descTitle:(NSString *)descTitle
                               desc:(NSString *)desc
                    completionBlock:(void (^)(NSUInteger buttonIndex, id <SBAlertDelegate> alertView))block
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSString *)otherButtonTitles, ...{
    NSMutableArray *otherTitles = [NSMutableArray new];
    if (otherButtonTitles) {
        [otherTitles addObject:otherButtonTitles];
        id arg;
        va_list argList;
        va_start(argList, otherButtonTitles);
        while ((arg = va_arg(argList, id)))
        {
            [otherTitles addObject:arg];
        }
        va_end(argList);
    }
    return [self showErrorWithTitle:title icon:icon descTitle:descTitle desc:desc titleAttributes:nil descAttributes:nil completionBlock:block cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherTitles.copy];
            
}
+ (id <SBAlertDelegate> )showErrorWithTitle:(NSString *)title
                               icon:(UIImage *)icon
                          descTitle:(NSString *)descTitle
                               desc:(NSString *)desc
                    titleAttributes:(NSDictionary *)titleAttributes
                  descAttributes:(NSDictionary *)descAttributes
                    completionBlock:(void (^)(NSUInteger buttonIndex, id <SBAlertDelegate> alertView))block
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSArray *)otherTitles{
    
    id <SBAlertDelegate> alertView = [self alertViewWithStyle:UIAlertControllerStyleAlert];
    NSMutableArray *items = [NSMutableArray new];
    
    CGFloat alertwidth = [UIScreen mainScreen].bounds.size.width - 50;
    if (icon) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.sb_itemSize = CGSizeMake(35, 35);
        iconView.sb_boundsInsets = UIEdgeInsetsMake(25, 0, 0, 0);
        [items addObject:iconView];
    }
    if (title.length) {
        UILabel *titleLabel = [self titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = title;
        CGFloat itemheight = [title boundingRectWithSize:CGSizeMake(alertwidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLabel.font} context:nil].size.height+1;
        titleLabel.sb_itemSize = CGSizeMake(alertwidth-30, itemheight);
        titleLabel.sb_boundsInsets = UIEdgeInsetsMake(15, 0, 0, 0);
        if (titleAttributes[NSFontAttributeName]) {
            titleLabel.font = titleAttributes[NSFontAttributeName];
        }
        if (titleAttributes[NSForegroundColorAttributeName]) {
            titleLabel.textColor = titleAttributes[NSForegroundColorAttributeName];
        }
        if (titleAttributes[kNSTextAlignmentKey]) {
            titleLabel.textAlignment = (NSTextAlignment)[titleAttributes[kNSTextAlignmentKey] integerValue];
        }
        [items addObject:titleLabel];
    }
    if (descTitle.length) {
        UILabel *descTitleLabel = [self titleLabel];
        descTitleLabel.text = descTitle;
        descTitleLabel.font = [UIFont systemFontOfSize:15];
        descTitleLabel.textAlignment = NSTextAlignmentLeft;
        descTitleLabel.sb_itemSize = CGSizeMake(alertwidth-30, 30);
        descTitleLabel.sb_boundsInsets = UIEdgeInsetsMake(15, 0, 0, 0);
        [items addObject:descTitleLabel];
    }
    if (desc.length) {
        UILabel *descLabel = [self messageLabel];
        descLabel.textAlignment = NSTextAlignmentLeft;
        descLabel.text = desc;
        
        CGFloat itemheight = [desc boundingRectWithSize:CGSizeMake(alertwidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:descLabel.font} context:nil].size.height+1;
        descLabel.sb_itemSize = CGSizeMake(alertwidth-30, itemheight);
        descLabel.sb_boundsInsets = UIEdgeInsetsMake(15, 0, 0, 0);
        if (descAttributes[NSFontAttributeName]) {
            descLabel.font = descAttributes[NSFontAttributeName];
        }
        if (descAttributes[NSForegroundColorAttributeName]) {
            descLabel.textColor = descAttributes[NSForegroundColorAttributeName];
        }
        if (descAttributes[kNSTextAlignmentKey]) {
            descLabel.textAlignment = (NSTextAlignment)[descAttributes[kNSTextAlignmentKey] integerValue];
        }
        [items addObject:descLabel];
    }
    
    //
    void (^copyBlock)(NSUInteger index, id <SBAlertDelegate> alertView) ;
    copyBlock = ^(NSUInteger index, id <SBAlertDelegate> alertView){
        if (index == 0) {
            //dissmiss
            [alertView dissmiss];
        }
        if (block) {
            block(index,alertView);
        }
    };
    
    if (cancelButtonTitle.length) {
        SBAlertButton *cancleButton = [self cancleButtonWithButtonCount:otherTitles.count+1];
        cancleButton.tag = baesTag ;
        [cancleButton addActionBlock:copyBlock tag:cancleButton.tag alertView:alertView];
        [cancleButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        cancleButton.sb_itemSize = CGSizeMake(otherTitles.count?(alertwidth-30-20)/2:alertwidth-30, 35);
        cancleButton.sb_boundsInsets = UIEdgeInsetsMake(15, 0, 20, 10);
        cancleButton.sb_parallel = YES;
        [items addObject:cancleButton];
    }
    NSString *otherTitle = [otherTitles firstObject];
    if (otherTitle.length) {
        SBAlertButton *button = [self otherButton];
        button.tag = baesTag + 1;
        [button addActionBlock:copyBlock tag:button.tag alertView:alertView];
        [button setTitle:otherTitle forState:UIControlStateNormal];
        button.sb_itemSize = CGSizeMake((alertwidth-30-20)/2, 35);
        button.sb_boundsInsets = UIEdgeInsetsMake(15, 10, 20, 0);
        button.sb_parallel = YES;
        [items addObject:button];
    }
    alertView.items = items;
    [alertView reloadData];
    [[SBAlertController shareAlert] showAlert:alertView];
    return alertView;
}

+ (id <SBAlertDelegate> )showFailWithMessage:(NSString *)message{
    return [self showWithStatus:NO message:message afterTimeInterval:0];
}

+ (id <SBAlertDelegate> )showSuccessWithMessage:(NSString *)message{
    return [self showSuccessWithMessage:message afterTimeInterval:0];
}

+ (id <SBAlertDelegate> )showSuccessWithMessage:(NSString *)message
                      afterTimeInterval:(NSTimeInterval)timeInterval{
    return [self showWithStatus:YES message:message afterTimeInterval:timeInterval];
}

+ (id <SBAlertDelegate> )showWithStatus:(BOOL)success
                        message:(NSString *)message
              afterTimeInterval:(NSTimeInterval)timeInterval{
    return [self showWithStatus:success message:message afterTimeInterval:timeInterval completedBlock:nil];
}

+ (id <SBAlertDelegate> )showWithStatus:(BOOL)success
                        message:(NSString *)message
              afterTimeInterval:(NSTimeInterval)timeInterval
                 completedBlock:(void(^)(void))completedBlock{
    id <SBAlertDelegate> alertView = [self alertViewWithStyle:UIAlertControllerStyleAlert];
    NSMutableArray *items = [NSMutableArray new];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:success?@"success":@"fail"]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.sb_itemSize = CGSizeMake(35, 35);
    iconView.sb_boundsInsets = UIEdgeInsetsMake(25, 0, 0, 0);
    [items addObject:iconView];
    
    UILabel *titleLabel = [self status_titleLabel];
    CGFloat messageWidth = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLabel.font} context:nil].size.width+1;
    titleLabel.sb_itemSize = CGSizeMake(messageWidth, 30);
    titleLabel.sb_boundsInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    titleLabel.text = message;
    [items addObject:titleLabel];
    
    if (timeInterval > 0) {
        UILabel *timerLabel = [self status_timerLabel];
        timerLabel.attributedText = [self timerAttributesWithSeconds:3];
        timerLabel.sb_itemSize = CGSizeMake(70, 25);
        timerLabel.sb_boundsInsets = UIEdgeInsetsMake(5, 0, 20, 0);
        __block NSInteger seconds = 3;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (seconds <= 0) {
                    //回掉并且关闭 alert
                    [alertView dissmiss];
                    if (completedBlock) {
                        completedBlock();
                    }
                    dispatch_source_cancel(timer);
                } else {
                    timerLabel.attributedText = [self timerAttributesWithSeconds:seconds];
                    seconds--;
                }
            });
        });
        dispatch_resume(timer);
        [items addObject:timerLabel];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //回掉并且关闭 alert
            [alertView dissmiss];
            if (completedBlock) {
                completedBlock();
            }
        });
    }
    
    alertView.items = items;
    [alertView reloadData];
    [[SBAlertController shareAlert] showAlert:alertView];
    return alertView;
}

+ (NSAttributedString *)timerAttributesWithSeconds:(NSInteger)seconds{
    NSMutableAttributedString *beforeText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld ",seconds] attributes:@{NSForegroundColorAttributeName:[self systemTintColor]}];
    NSAttributedString *lastText = [[NSAttributedString alloc] initWithString:@"秒后返回" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    [beforeText appendAttributedString:lastText];
    return beforeText.copy;
}
+ (UILabel *)status_timerLabel{
    UILabel *timerLabel = [[UILabel alloc] init];
    timerLabel.textColor = [UIColor grayColor];
    timerLabel.font = [UIFont systemFontOfSize:12];
    timerLabel.textAlignment = NSTextAlignmentCenter;
    return timerLabel;
}

+ (UILabel *)status_titleLabel{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

+ (UIColor *)systemTintColor{
    return [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
}
@end
