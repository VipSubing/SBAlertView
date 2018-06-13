//
//  SBAlertButton.h
//  SBAlertView
//
//  Created by qyb on 2018/6/11.
//  Copyright © 2018年 qyb. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger const baesTag;

@interface SBAlertButton : UIButton

- (void)addActionBlock:(void(^)(NSUInteger index, id alertView))actionBlock tag:(NSUInteger)tag alertView:(id)alertView;

@end
