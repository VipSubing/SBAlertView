//
//  SBAlertController+Sheet.h
//  SBAlertView
//
//  Created by qyb on 2018/6/13.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "SBAlertController.h"

@interface SBAlertController (Sheet)

/**
 以sheet方式添加 带有 title cancle按钮的sheet alert ，title和 cancleTitle为空则没有title或者cancleTIlte

 @param contents 以block方式返回
 @param title title
 @param cancleTitle cancleTIlte
 @return alert
 */
+ (id <SBAlertDelegate>)alertWithContents:(NSArray *(^)(id <SBAlertDelegate> alert))contents
                                    title:(NSString *)title
                              cancleTitle:(NSString *)cancleTitle;

/**
 以sheet方式展现item 矩阵排布, 带有 title cancle按钮的sheet alert ，title和 cancleTitle为空则没有title或者cancleTIlte
 
 @param layout 布局信息参照 UICollectionViewFlowLayout
 @param itemCount  Itemcount
 @param itemReload reload block
 @param didSelected 选中block
 @param title title
 @param cancleTitle cancleTIlte
 @return alert
 */
+ (id <SBAlertDelegate>)alertWithItemLayout:(UICollectionViewFlowLayout *)layout
                                  itemCount:(NSInteger)itemCount
                          itemForRowAtIndex:(UIView *(^)(id <SBAlertDelegate> alertView,NSInteger index))itemReload
                     didSelectedItemAtIndex:(void(^)(id <SBAlertDelegate> alertView,NSInteger index))didSelected
                                      title:(NSString *)title
                                cancleTitle:(NSString *)cancleTitle;

@end
