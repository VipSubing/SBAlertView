//
//  SBAlertController+_Message.m
//  SBAlertView
//
//  Created by qyb on 2018/6/11.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "SBAlertController+_Message.h"
#import "SBAlertButton.h"

#define DefaultPFFontPt(Pt) [UIFont fontWithName:@"PingFangSC-Regular" size:Pt]

NSString *const kNSTextAlignmentKey = @"kNSTextAlignmentKey";

@implementation SBAlertController (_Message)

+ (id <SBAlertDelegate> )showWithMessage:(NSString *)message{
    return [self showAlertWithTitle:message message:nil icon:nil completionBlock:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
}
+ (id <SBAlertDelegate> )showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                               icon:(UIImage *)icon
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
    return [self standard_showAlertWithTitle:title message:message icon:icon titleAttributes:nil messageAttributes:nil completionBlock:block cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherTitles];
}
+ (id <SBAlertDelegate> )showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                               icon:(UIImage *)icon
                    titleAttributes:(NSDictionary *)titleAttributes
                  messageAttributes:(NSDictionary *)messageAttributes
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
    return [self standard_showAlertWithTitle:title message:message icon:icon titleAttributes:titleAttributes messageAttributes:messageAttributes completionBlock:block cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherTitles];
}
+ (id <SBAlertDelegate> )standard_showAlertWithTitle:(NSString *)title
                              message:(NSString *)message
                                 icon:(UIImage *)icon
                      titleAttributes:(NSDictionary *)titleAttributes
                    messageAttributes:(NSDictionary *)messageAttributes
                      completionBlock:(void (^)(NSUInteger buttonIndex, id <SBAlertDelegate> alertView))block
                    cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitles:(NSArray *)otherTitles{
    id <SBAlertDelegate> alertView = [self alertViewWithStyle:UIAlertControllerStyleAlert];
    NSMutableArray *items = [NSMutableArray new];
    
    CGFloat alertwidth = [UIScreen mainScreen].bounds.size.width - 50;
    if (icon) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        iconView.sb_itemSize = CGSizeMake(alertwidth/3, alertwidth/3);
        iconView.sb_boundsInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        [items addObject:iconView];
    }
    if (title.length) {
        UILabel *titleLabel = [self titleLabel];
        titleLabel.text = title;
        
        if (titleAttributes[NSFontAttributeName]) {
            titleLabel.font = titleAttributes[NSFontAttributeName];
        }
        if (titleAttributes[NSForegroundColorAttributeName]) {
            titleLabel.textColor = titleAttributes[NSForegroundColorAttributeName];
        }
        if (titleAttributes[kNSTextAlignmentKey]) {
            titleLabel.textAlignment = (NSTextAlignment)[titleAttributes[kNSTextAlignmentKey] integerValue];
        }
        CGFloat itemheight = [title boundingRectWithSize:CGSizeMake(alertwidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleLabel.font} context:nil].size.height+1;
        titleLabel.sb_itemSize = CGSizeMake(alertwidth-30, itemheight);
        titleLabel.sb_boundsInsets = UIEdgeInsetsMake(icon?10:20, 0, 0, 0);
        [items addObject:titleLabel];
    }
    if (message.length) {
        UILabel *messageLabel = [self messageLabel];
        messageLabel.text = message;
        
        if (messageAttributes[NSFontAttributeName]) {
            messageLabel.font = messageAttributes[NSFontAttributeName];
        }
        if (messageAttributes[NSForegroundColorAttributeName]) {
            messageLabel.textColor = messageAttributes[NSForegroundColorAttributeName];
        }
        if (messageAttributes[kNSTextAlignmentKey]) {
            messageLabel.textAlignment = (NSTextAlignment)[messageAttributes[kNSTextAlignmentKey] integerValue];
        }
        CGFloat itemheight = [message boundingRectWithSize:CGSizeMake(alertwidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:messageLabel.font} context:nil].size.height+1;
        messageLabel.sb_itemSize = CGSizeMake(alertwidth-30, itemheight);
        messageLabel.sb_boundsInsets = UIEdgeInsetsMake(15, 0, 15, 0);
        [items addObject:messageLabel];
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
+ (SBAlertButton *)otherButton{
    SBAlertButton *button = [[SBAlertButton alloc] init];
    [button.titleLabel setFont:DefaultPFFontPt(15)];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [self systemTintColor];
    
    return button;
}
+ (SBAlertButton *)cancleButtonWithButtonCount:(NSInteger)count{
    SBAlertButton *cancelButton = [[SBAlertButton alloc] init];
    [cancelButton.titleLabel setFont:DefaultPFFontPt(15)];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 5;
    if (count == 1) {
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [self systemTintColor];
    }else{
        [cancelButton setTitleColor:[self systemTintColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor whiteColor];
        cancelButton.layer.borderColor = [self systemTintColor].CGColor;
        cancelButton.layer.borderWidth = 1;
    }
    return cancelButton;
}

+ (UILabel *)titleLabel{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = DefaultPFFontPt(15) ;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}
+ (UILabel *)messageLabel{
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.font = DefaultPFFontPt(14) ;
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    return messageLabel;
}

+ (UIColor *)systemTintColor{
    return [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
}


+ (CGFloat)defaultAlertWidth{
    return [UIScreen mainScreen].bounds.size.width-50;
}
@end
