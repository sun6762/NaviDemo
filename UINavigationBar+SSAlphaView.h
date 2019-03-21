//
//  UINavigationBar+SSAlphaView.h
//  SunnyCalendar
//
//  Created by sun on 2019/2/14.
//  Copyright © 2019年 sunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kIS_iPhone_X ([UIScreen mainScreen].bounds.size.height == 812 ? YES:NO)
#define kTopMargin (kIS_iPhone_X ? 88:64)
#define kStatusBarH (kIS_iPhone_X ? 44:20)

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (SSAlphaView)

@property (nonatomic, retain)UIView *alphaView;

- (void)overRideSetBackgroundColor:(UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
