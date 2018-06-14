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

+ (id <SBAlertDelegate>)alertWithContents:(NSArray *(^)(id <SBAlertDelegate> alert))contents
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
    if (contents) {
         [items addObjectsFromArray:contents(alert)];
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

+ (id <SBAlertDelegate>)alertWithItemLayout:(UICollectionViewFlowLayout *)layout
                                  itemCount:(NSInteger)itemCount
                          itemForRowAtIndex:(UIView *(^)(id <SBAlertDelegate> alertView,NSInteger index))itemReload
                     didSelectedItemAtIndex:(void(^)(id <SBAlertDelegate> alertView,NSInteger index))didSelected
                                    title:(NSString *)title
                              cancleTitle:(NSString *)cancleTitle{
    
    
    
    return [self alertWithContents:^NSArray *(id<SBAlertDelegate> alert) {
                NSMutableArray *items = [NSMutableArray new];
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                NSInteger x = 1;// item number
                while (x) {
                    if (x*layout.itemSize.width+(x-1)*layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right > width) {
                        x --;
                        break;
                    }
                    x ++;
                }
        
                CGFloat interitemSpacing = x <= 1 ?0:(width - x*layout.itemSize.width - layout.sectionInset.left - layout.sectionInset.right)/(x-1);
        
                void (^didSelectedBlock) (id alert , NSUInteger index) = ^(id alertView , NSUInteger index){
                    if (didSelected) {
                        didSelected(alertView,index);
                    }
                };
                UIView *previous = nil;
                NSInteger sectionMax = itemCount%x>0?itemCount/x + 1:itemCount/x;
                for (int section = 0; section < sectionMax; section ++) {
                    NSInteger rowMax = x;
                    if (section == sectionMax - 1 && itemCount%x != 0) rowMax = itemCount%x;
                    for (int row = 0; row < rowMax; row ++) {
                        NSInteger index = section * x + row;
                        UIView *item = itemReload(alert,index);
                        if (!row) item.sb_newline = YES;
                        item.sb_parallel = YES;
                        item.sb_itemSize = layout.itemSize;
                        item.sb_boundsInsets = UIEdgeInsetsMake(section?layout.minimumLineSpacing:layout.sectionInset.top, !row?layout.sectionInset.left:interitemSpacing, 0, row-1 == x?layout.sectionInset.right:0);
                        if (didSelected) {
                            [item sb_addTapActionBlock:didSelectedBlock tag:index alertView:alert];
                        }
                        previous = item;
                        [items addObject:item];
                    }
                }
                return items;
    } title:title cancleTitle:cancleTitle];
}


@end
