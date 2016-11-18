//
//  FeatherView.h
//  PieDrawDemo
//
//  Created by wangguopeng on 2016/11/14.
//  Copyright © 2016年 joymake. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^VOIDBLOCK)();

@interface FeatherView : UIView
- (void)drawFeatherViewTouchBlock:(VOIDBLOCK)touchBlock;
@end
