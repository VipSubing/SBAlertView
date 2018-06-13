//
//  SBAlertController+Sheet.m
//  SBAlertView
//
//  Created by qyb on 2018/6/13.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "SBAlertController+Sheet.h"
#import "SBAlertButton.h"

@implementation SBAlertController (Sheet)

+ (id <SBAlertDelegate>)alertWithContents:(NSArray <UIView *>*)contents
                                    title:(NSString *)title
                              cancleTitle:(NSString *)cancleTitle{
    id <SBAlertDelegate> alert = [self alertViewWithStyle:UIAlertControllerStyleActionSheet];
    NSMutableArray *items = [NSMutableArray new];
    if (title.length) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor darkTextColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.sb_itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
        CALayer *titleBottomLine = [CALayer layer];
        titleBottomLine.frame = CGRectMake(0, titleLabel.sb_itemSize.height-0.5f, titleLabel.sb_itemSize.width, 0.5f);
        titleBottomLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        [titleLabel.layer addSublayer:titleBottomLine];
        [items addObject:titleLabel];
    }
    [items addObjectsFromArray:contents];
    
    void (^cancleBlock) (NSUInteger index , id alert) = ^(NSUInteger index , id alertView){
        if (index == 0) {
            [alertView dissmiss];
        }
    };
    
    SBAlertButton *cancleButton = [[SBAlertButton alloc] init];
    [cancleButton setTitle:cancleTitle forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleButton addActionBlock:cancleBlock tag:baesTag alertView:alert];
    cancleButton.sb_itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 35);
    CALayer *cancleTopLine = [CALayer layer];
    cancleTopLine.frame = CGRectMake(0, 0, cancleButton.sb_itemSize.width, 0.5f);
    cancleTopLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    [cancleButton.layer addSublayer:cancleTopLine];
    [items addObject:cancleButton];
    
    alert.items = items;
    [alert reloadData];
    [[SBAlertController shareAlert] showAlert:alert];
    return alert;
}

+ (id <SBAlertDelegate>)alertWithItemLayout:(UICollectionViewFlowLayout *)layout
                          itemForRowAtIndex:(UIView *(^)(id <SBAlertDelegate> alertView,NSInteger index))itemReload
                                    title:(NSString *)title
                              cancleTitle:(NSString *)cancleTitle{
    
    id <SBAlertDelegate> alert = [self alertViewWithStyle:UIAlertControllerStyleActionSheet];
    NSMutableArray *items = [NSMutableArray new];
    if (title.length) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor darkTextColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.sb_itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
        CALayer *titleBottomLine = [CALayer layer];
        titleBottomLine.frame = CGRectMake(0, titleLabel.sb_itemSize.height-0.5f, titleLabel.sb_itemSize.width, 0.5f);
        titleBottomLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        [titleLabel.layer addSublayer:titleBottomLine];
        [items addObject:titleLabel];
    }
    
    
    
    void (^cancleBlock) (NSUInteger index , id alert) = ^(NSUInteger index , id alertView){
        if (index == 0) {
            [alertView dissmiss];
        }
    };
    
    SBAlertButton *cancleButton = [[SBAlertButton alloc] init];
    [cancleButton setTitle:cancleTitle forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleButton addActionBlock:cancleBlock tag:baesTag alertView:alert];
    cancleButton.sb_itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 35);
    CALayer *cancleTopLine = [CALayer layer];
    cancleTopLine.frame = CGRectMake(0, 0, cancleButton.sb_itemSize.width, 0.5f);
    cancleTopLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    [cancleButton.layer addSublayer:cancleTopLine];
    [items addObject:cancleButton];
    
    alert.items = items;
    [alert reloadData];
    [[SBAlertController shareAlert] showAlert:alert];
    return alert;
}


@end
