//
//  UINavigationBar+SSAlphaView.m
//  SunnyCalendar
//
//  Created by sun on 2019/2/14.
//  Copyright © 2019年 sunny. All rights reserved.
//

#import "UINavigationBar+SSAlphaView.h"
#import "objc/runtime.h"

static const char *alphaV = "alphaV";

@implementation UINavigationBar (SSAlphaView)

- (UIView *)alphaView{
    return objc_getAssociatedObject(self, alphaV);
}

- (void)setAlphaView:(UIView *)alphaView{
    objc_setAssociatedObject(self, alphaV, alphaView, OBJC_ASSOCIATION_RETAIN);
}

- (void)overRideSetBackgroundColor:(UIColor *)backgroundColor{
    
    if (!self.alphaView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
        self.alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, -Height_StatusBar, kScreenW, self.bounds.size.height + Height_StatusBar)];
        self.alphaView.userInteractionEnabled = NO; 
        [self insertSubview:self.alphaView atIndex:0];
    }
    self.alphaView.backgroundColor = backgroundColor;
}

@end
