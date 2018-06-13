//
//  SBAlertController+Sheet.h
//  SBAlertView
//
//  Created by qyb on 2018/6/13.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import "SBAlertController.h"

@interface SBAlertController (Sheet)

+ (id <SBAlertDelegate>)alertWithContents:(NSArray <UIView *>*)contents
                                    title:(NSString *)title
                              cancleTitle:(NSString *)cancleTitle;

@end
